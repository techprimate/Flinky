# frozen_string_literal: true

# ============================================================================
# GIT LANES
# ============================================================================
# Private lanes for Git commit and tagging operations.
# ============================================================================

VERSION_BUMP_FILES = [
  "Flinky.xcodeproj/project.pbxproj",
  "Targets/App/Sources/Resources/Settings.bundle/Root.plist"
].freeze

# Private lane: Commit version changes and create git tag (local use)
private_lane :_commit_and_tag_version do |options|
  version_number = options[:version]
  build_number = options[:build]

  version_tag = "v#{version_number}+#{build_number}"

  git_add(path: VERSION_BUMP_FILES)
  git_commit(
    path: VERSION_BUMP_FILES,
    message: "chore: Bump version to #{version_number} (#{build_number})"
  )

  add_git_tag(tag: version_tag)

  push_to_git_remote(
    remote: 'origin',
    tags: true
  )
end

# Private lane: Commit version changes via GitHub API (CI use)
# Creates a verified commit signed by GitHub and linked to the GitHub App.
# Requires RELEASE_BOT_TOKEN and GITHUB_REPOSITORY environment variables.
private_lane :_commit_and_tag_version_signed do |options|
  require 'octokit'
  require 'base64'

  version_number = options[:version]
  build_number = options[:build]

  unless version_number&.match?(/\A\d+(\.\d+)*\z/)
    UI.user_error!("version is required and must be numeric (e.g. 1.2.3)")
  end
  unless build_number&.to_s&.match?(/\A\d+\z/)
    UI.user_error!("build is required and must be numeric")
  end

  token = ENV.fetch("RELEASE_BOT_TOKEN")
  repo = ENV.fetch("GITHUB_REPOSITORY")
  commit_message = "chore: Bump version to #{version_number} (#{build_number})"
  version_tag = "v#{version_number}+#{build_number}"

  client = Octokit::Client.new(access_token: token)

  begin
    # Get current HEAD of main
    ref = client.ref(repo, "heads/main")
    base_sha = ref.object.sha
    base_commit = client.git_commit(repo, base_sha)

    # Create blobs for the modified files
    tree_items = VERSION_BUMP_FILES.map do |file_path|
      full_path = File.expand_path("../#{file_path}")
      unless File.file?(full_path)
        UI.user_error!("Version bump file not found: #{full_path}")
      end
      begin
        content = File.read(full_path)
      rescue => e
        UI.user_error!("Failed to read #{full_path}: #{e.message}")
      end
      blob_sha = client.create_blob(repo, Base64.strict_encode64(content), "base64")
      { path: file_path, mode: "100644", type: "blob", sha: blob_sha }
    end

    # Create tree, commit, update ref, and create tag
    new_tree = client.create_tree(repo, tree_items, base_tree: base_commit.tree.sha)
    new_commit = client.create_commit(repo, commit_message, new_tree.sha, [base_sha])
    client.update_ref(repo, "heads/main", new_commit.sha, false)

    begin
      existing_tag = client.ref(repo, "tags/#{version_tag}")
      existing_sha = existing_tag.object.sha
      if existing_sha == new_commit.sha
        UI.message "Tag #{version_tag} already exists at #{existing_sha}"
      else
        client.delete_ref(repo, "tags/#{version_tag}")
        client.create_ref(repo, "refs/tags/#{version_tag}", new_commit.sha)
      end
    rescue Octokit::NotFound
      client.create_ref(repo, "refs/tags/#{version_tag}", new_commit.sha)
    end

    UI.success "✅ Created signed commit #{new_commit.sha} with tag #{version_tag}"
  rescue Octokit::Error, StandardError => e
    UI.user_error!("Failed to create signed commit via GitHub API: #{e.message}")
  end
end
