# frozen_string_literal: true

# ============================================================================
# VERSION MANAGEMENT LANES
# ============================================================================
# Private lanes for version checking and management with App Store Connect.
# ============================================================================

# Private lane: Check App Store Connect and bump patch version if current version is already published
private_lane :_check_and_bump_version_if_needed do
  current_version = get_version_number(
    xcodeproj: "Flinky.xcodeproj",
    target: "Flinky"
  )

  UI.message "Checking App Store Connect for published version..."

  begin
    # Get the published version from App Store Connect
    # This action sets lane_context[SharedValues::LATEST_VERSION] with the version number
    app_store_build_number(
      api_key_path: File.expand_path("./api-key.json"),
      live: true
    )

    # Get the published version from lane context
    published_version = lane_context[SharedValues::LATEST_VERSION]

    unless published_version
      raise "Could not retrieve published version from App Store Connect"
    end

    UI.message "Published version on App Store Connect: #{published_version}"

    # Compare versions semantically
    if _version_already_published?(current_version, published_version)
      UI.important "Version #{current_version} is already published. Bumping patch version..."
      _bump_version(bump_type: "patch")
      _make(target: "generate")

      # Get the new version after bumping
      new_version = get_version_number(
        xcodeproj: "Flinky.xcodeproj",
        target: "Flinky"
      )
      UI.success "✅ Version bumped from #{current_version} to #{new_version}"
      next({ version: new_version, bumped: true })
    else
      UI.success "✅ Version #{current_version} is not yet published, using current version"
      next({ version: current_version, bumped: false })
    end
  rescue => e
    UI.important "⚠️ Failed to check App Store Connect: #{e.message}"
    UI.important "Falling back to current version without bumping"
    next({ version: current_version, bumped: false })
  end
end

# Private lane: Compare versions to check if current version is already published
private_lane :_version_already_published? do |current_version, published_version|
  # Parse version strings into arrays of integers
  current_parts = current_version.split(".").map(&:to_i)
  published_parts = published_version.split(".").map(&:to_i)

  # Compare major, minor, patch
  (0..2).each do |i|
    current_part = current_parts[i] || 0
    published_part = published_parts[i] || 0

    if current_part < published_part
      next false # Current version is lower, not published
    elsif current_part > published_part
      next false # Current version is higher, not published yet
    end
  end

  # Versions are equal, so current version is already published
  next true
end

# Private lane: Query TestFlight for latest build number and return next one
# Sets the build number in the project to the next available number
private_lane :_get_next_build_number do |options|
  version_number = options[:version]

  UI.message "Querying TestFlight for latest build number for version #{version_number}..."

  begin
    # Query TestFlight for the latest build number for this version
    latest_testflight_build_number(
      api_key_path: File.expand_path("./api-key.json"),
      version: version_number
    )

    # Get the latest build number from lane context
    latest_build = lane_context[SharedValues::LATEST_TESTFLIGHT_BUILD_NUMBER]

    if latest_build
      next_build = latest_build.to_i + 1
      UI.message "Latest build on TestFlight: #{latest_build}, using next: #{next_build}"
    else
      next_build = 1
      UI.message "No builds found on TestFlight for version #{version_number}, starting at 1"
    end

    # Set the build number in the project
    increment_build_number(
      xcodeproj: "Flinky.xcodeproj",
      build_number: next_build.to_s
    )

    UI.success "✅ Build number set to #{next_build}"
    next next_build.to_s
  rescue => e
    UI.important "⚠️ Could not query TestFlight: #{e.message}"
    UI.important "Incrementing from current build number as fallback"
    increment_build_number(xcodeproj: "Flinky.xcodeproj")
    build_number = get_build_number(xcodeproj: "Flinky.xcodeproj")
    next build_number
  end
end

# Private lane: Check if a specific version+build already exists on TestFlight
private_lane :_build_already_uploaded? do |options|
  version_number = options[:version]
  build_number = options[:build]

  UI.message "Checking if build #{version_number} (#{build_number}) exists on TestFlight..."

  begin
    # Query TestFlight for the latest build number for this version
    latest_testflight_build_number(
      api_key_path: File.expand_path("./api-key.json"),
      version: version_number
    )

    latest_build = lane_context[SharedValues::LATEST_TESTFLIGHT_BUILD_NUMBER]

    if latest_build && latest_build.to_i >= build_number.to_i
      UI.message "Build #{build_number} already exists (latest is #{latest_build})"
      next true
    else
      UI.message "Build #{build_number} does not exist yet (latest is #{latest_build || 'none'})"
      next false
    end
  rescue => e
    UI.important "⚠️ Could not check TestFlight: #{e.message}"
    UI.important "Assuming build does not exist, proceeding with upload"
    next false
  end
end
