# frozen_string_literal: true

# ============================================================================
# GIT & GITHUB LANES
# ============================================================================
# Private lanes for Git operations and GitHub API interactions.
# ============================================================================

# Private lane: Create PR for version bump (for CI use with protected branches)
private_lane :_create_version_pr do |options|
  version_number = options[:version]
  build_number = options[:build]

  # Ensure we have GitHub token
  github_token = ENV["GITHUB_TOKEN"] || ENV["GITHUB_APP_TOKEN"]
  unless github_token
    UI.user_error!("GITHUB_TOKEN or GITHUB_APP_TOKEN environment variable is required")
  end

  # Create release branch name
  branch_name = "release/v#{version_number}+#{build_number}"

  UI.message "Creating release branch: #{branch_name}"

  # Ensure we're on main and up to date
  sh("git", "checkout", "main")
  sh("git", "pull", "origin", "main")

  # Create and checkout new branch
  sh("git", "checkout", "-b", branch_name)

  # Stage version changes (project.pbxproj and Root.plist are updated by build scripts)
  git_add(path: ["Flinky.xcodeproj/project.pbxproj", "Targets/App/Sources/Resources/Settings.bundle/Root.plist"])

  # Create commit with structured message
  commit_message = <<~MSG
    chore: Bump version to #{version_number} (#{build_number})

    action=bump,version=#{version_number},build=#{build_number}
  MSG

  git_commit(
    path: ["Flinky.xcodeproj/project.pbxproj", "Targets/App/Sources/Resources/Settings.bundle/Root.plist"],
    message: commit_message.strip
  )

  # Push branch to remote
  sh("git", "push", "-u", "origin", branch_name)

  # Create PR
  UI.message "Creating pull request..."

  pr_body = <<~BODY
    ## Version Bump

    - **Version**: #{version_number}
    - **Build**: #{build_number}
    - **Tag**: `v#{version_number}+#{build_number}` (will be created after merge)

    This PR bumps the version and build number for the beta release.

    Once this PR is created, pushing to the release branch will trigger the deployment workflow to build and upload to TestFlight.

    This PR will be automatically merged once the deployment workflow passes (enforced by branch protection rules).
  BODY

  pr_result = create_pull_request(
    api_token: github_token,
    repo: "techprimate/Flinky",
    title: "chore: Bump version to #{version_number} (#{build_number})",
    body: pr_body.strip,
    head: branch_name,
    base: "main"
  )

  pr_url = pr_result[:html_url]
  pr_number = pr_result[:number]

  UI.success "✅ Pull request created: #{pr_url}"

  # Enable auto-merge using custom action
  enable_pr_auto_merge(
    pr_number: pr_number,
    pr_url: pr_url,
    repo: "techprimate/Flinky",
    merge_method: "SQUASH"
  )

  next({ pr_url: pr_url, pr_number: pr_number, branch: branch_name })
end

# Private lane: Commit version changes and create git tag
private_lane :_commit_and_tag_version do |options|
  version_number = options[:version]
  build_number = options[:build]

  # Create version tag
  version_tag = "v#{version_number}+#{build_number}"

  # Commit the version changes (project.pbxproj and Root.plist are updated by build scripts)
  git_add(path: ["Flinky.xcodeproj/project.pbxproj", "Targets/App/Sources/Resources/Settings.bundle/Root.plist"])
  git_commit(
    path: ["Flinky.xcodeproj/project.pbxproj", "Targets/App/Sources/Resources/Settings.bundle/Root.plist"],
    message: "chore: Bump version to #{version_number} (#{build_number})"
  )

  # Create git tag for this version
  add_git_tag(tag: version_tag)

  # Push the commit and tag to remote
  push_to_git_remote(
    remote: 'origin',
    tags: true
  )
end
