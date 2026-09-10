# frozen_string_literal: true

# ============================================================================
# PRIVATE HELPER LANES
# ============================================================================
# These lanes are internal helpers used by other lanes.
# They are not exposed in `fastlane lanes`.
# ============================================================================

PROJECT_SPEC_PATH = File.expand_path("../project.yml").freeze

# Private lane: Read version information from the XcodeGen project specification
private_lane :_read_version_info do
  version_number = sh(
    "yq", "-er", ".settings.base.MARKETING_VERSION", PROJECT_SPEC_PATH,
    log: false
  ).strip
  build_number = sh(
    "yq", "-er", ".settings.base.CURRENT_PROJECT_VERSION", PROJECT_SPEC_PATH,
    log: false
  ).strip

  unless version_number.match?(/\A\d+(\.\d+)*\z/)
    UI.user_error!("Invalid MARKETING_VERSION in project.yml: #{version_number}")
  end
  unless build_number.match?(/\A\d+\z/)
    UI.user_error!("Invalid CURRENT_PROJECT_VERSION in project.yml: #{build_number}")
  end

  next({ version: version_number, build: build_number })
end

# Private lane: Write version information to the XcodeGen project specification
private_lane :_write_version_info do |options|
  version_number = options[:version].to_s
  build_number = options[:build].to_s

  unless version_number.match?(/\A\d+(\.\d+)*\z/)
    UI.user_error!("version is required and must be numeric (e.g. 1.2.3)")
  end
  unless build_number.match?(/\A\d+\z/)
    UI.user_error!("build is required and must be numeric")
  end

  expression = ".settings.base.MARKETING_VERSION = \"#{version_number}\" | " \
               ".settings.base.CURRENT_PROJECT_VERSION = #{build_number}"
  sh("yq", "-i", expression, PROJECT_SPEC_PATH)

  next({ version: version_number, build: build_number })
end

# Private lane: Bump version number in project.yml
private_lane :_bump_version do |options|
  bump_type = options[:bump_type] # "major", "minor", or "patch"
  version_info = _read_version_info
  old_version = version_info[:version]

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
  _write_version_info(version: new_version, build: version_info[:build])

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

# Private lane: Setup code signing for Development builds
private_lane :_setup_code_signing_development do
  sync_code_signing(
    type: "development",
    readonly: true,
    app_identifier: "com.techprimate.Flinky",
    git_private_key: ENV["MATCH_GIT_PRIVATE_KEY"]
  )
  sync_code_signing(
    type: "development",
    readonly: true,
    app_identifier: "com.techprimate.Flinky.ShareExtension",
    git_private_key: ENV["MATCH_GIT_PRIVATE_KEY"]
  )
end

# Private lane: Increment build number in project.yml, return version information
private_lane :_increment_version_and_build do
  version_info = _read_version_info
  build_number = version_info[:build].to_i + 1

  _write_version_info(version: version_info[:version], build: build_number)
end

# Private lane: Build the app for App Store distribution
private_lane :_build_app_for_store do
  build_app(
    project: "Flinky.xcodeproj",
    scheme: "App",
    output_name: "Flinky", # Explicit name to avoid relying on PRODUCT_NAME

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
