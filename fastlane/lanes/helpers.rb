# frozen_string_literal: true

# ============================================================================
# PRIVATE HELPER LANES
# ============================================================================
# These lanes are internal helpers used by other lanes.
# They are not exposed in `fastlane lanes`.
# ============================================================================

# Private lane: Bump version number in project.pbxproj
private_lane :_bump_version do |options|
  bump_type = options[:bump_type] # "major", "minor", or "patch"

  # Get current version
  old_version = get_version_number(
    xcodeproj: "Flinky.xcodeproj",
    target: "Flinky"
  )

  # Parse version into components
  version_parts = old_version.split(".").map(&:to_i)
  major = version_parts[0] || 0
  minor = version_parts[1] || 0
  patch = version_parts[2] || 0

  # Increment the appropriate part
  case bump_type
  when "major"
    major += 1
    minor = 0
    patch = 0
  when "minor"
    minor += 1
    patch = 0
  when "patch"
    patch += 1
  else
    UI.user_error!("Invalid bump_type: #{bump_type}. Must be 'major', 'minor', or 'patch'")
  end

  new_version = "#{major}.#{minor}.#{patch}"

  # Update all MARKETING_VERSION entries in project.pbxproj
  project_file = File.expand_path("../Flinky.xcodeproj/project.pbxproj")
  project_content = File.read(project_file)

  # Replace all MARKETING_VERSION entries
  updated_content = project_content.gsub(
    /MARKETING_VERSION = #{Regexp.escape(old_version)};/,
    "MARKETING_VERSION = #{new_version};"
  )

  # Write the updated content back
  File.write(project_file, updated_content)

  UI.success "✅ Version bumped from #{old_version} to #{new_version}"
end

# Private lane: Setup code signing for App Store Connect
private_lane :_setup_code_signing do
  sync_code_signing(
    type: "appstore",
    readonly: true,
    app_identifier: "com.techprimate.Flinky",
    git_private_key: ENV["MATCH_GIT_PRIVATE_KEY"]
  )
  sync_code_signing(
    type: "appstore",
    readonly: true,
    app_identifier: "com.techprimate.Flinky.ShareExtension",
    git_private_key: ENV["MATCH_GIT_PRIVATE_KEY"]
  )
end

# Private lane: Increment version and build number, return both values
private_lane :_increment_version_and_build do
  version_number = get_version_number(
    xcodeproj: "Flinky.xcodeproj",
    target: "Flinky"
  )

  increment_build_number(xcodeproj: "Flinky.xcodeproj")
  build_number = get_build_number(xcodeproj: "Flinky.xcodeproj")

  next({ version: version_number, build: build_number })
end

# Private lane: Build the app for App Store distribution
private_lane :_build_app_for_store do
  build_app(
    project: "Flinky.xcodeproj",
    scheme: "App",

    archive_path: "./Flinky.xcarchive",
    build_path: ".",
    export_options: {
      "destination" => "export",
      "method" => "app-store-connect",
      "provisioningProfiles" => {
        "com.techprimate.Flinky" => "match AppStore com.techprimate.Flinky",
        "com.techprimate.Flinky.ShareExtension" => "match AppStore com.techprimate.Flinky.ShareExtension"
      },
      "signingCertificate" => "Apple Distribution",
      "signingStyle" => "manual",
      "teamID" => "BZ362SQ6AB"
    }
  )
end

# Private lane: Validate the app before upload
private_lane :_validate_app do
  deliver(
    # API Key file must be located at fastlane/api-key.json
    api_key_path: File.expand_path("./api-key.json"),
    verify_only: true
  )
end

# Private lane: Run a make target
private_lane :_make do |options|
  UI.message "Running make target #{options[:target]}"
  target = options[:target]
  UI.user_error!("target is required") unless target
  Dir.chdir("..") do
    sh("make", target)
  end
  UI.success "✅ Make target #{target} run successfully!"
end
