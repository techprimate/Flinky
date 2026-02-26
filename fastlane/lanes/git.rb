# frozen_string_literal: true

# ============================================================================
# GIT LANES
# ============================================================================
# Private lanes for Git commit and tagging operations.
# ============================================================================

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
