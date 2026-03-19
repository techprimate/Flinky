# frozen_string_literal: true

# ============================================================================
# UTILITY LANES
# ============================================================================
# Lanes for various utility tasks like generating icons, screenshots,
# managing code signing, and version bumping.
# ============================================================================

desc <<~DESC
  Generate app icon sizes from source image using fastlane-plugin-appicon
  Generates all required iOS app icon sizes from Resources/AppIcon.png
  Strips metadata to ensure git-reproducible output
DESC
lane :generate_app_icons do
  UI.message "Generating app icon sizes using fastlane-plugin-appicon"

  # Configure MiniMagick to use ImageMagick for consistent metadata handling
  require 'mini_magick'
  MiniMagick.configure { |config| config.cli = :imagemagick }

  # Use absolute paths to avoid plugin directory changes
  project_root = File.expand_path("..")
  source_image = File.join(project_root, "Resources", "AppIcon.png")
  assets_path = File.join(project_root, "Targets", "App", "Sources", "Resources", "Assets.xcassets")
  icon_output_dir = File.join(assets_path, "AppIcon.appiconset")

  UI.message "Using source image: #{File.basename(source_image)}"

  # Verify source image exists
  unless File.exist?(source_image)
    UI.user_error! "Source image not found at #{source_image}"
  end

  # Generate iOS app icons (iPhone, iPad, App Store)
  appicon(
    appicon_image_file: source_image,
    appicon_devices: [:iphone, :ipad, :ios_marketing],
    appicon_path: assets_path,
    remove_alpha: true,
    minimagick_cli: "imagemagick"
  )

  UI.message "Stripping metadata from generated icons to ensure git-reproducible output"

  # Strip metadata from all generated icon files
  Dir.glob(File.join(icon_output_dir, "*.png")).each do |icon_path|
    UI.verbose "Processing: #{File.basename(icon_path)}"

    begin
      image = MiniMagick::Image.open(icon_path)
      image.combine_options do |b|
        # Strip all existing metadata
        b << "-strip"

        # Set consistent comment
        b << "-set" << "comment" << "Generated using fastlane-plugin-appicon"

        # Exclude PNG time chunks to prevent timestamp variations
        b << "-define" << "png:exclude-chunks=tIME"

        # Set consistent timestamps to prevent git detecting changes
        timestamp = "2024-01-01T00:00:00Z"
        b << "-set" << "date:create" << timestamp
        b << "-set" << "date:modify" << timestamp
        b << "-set" << "date:timestamp" << timestamp

        # Set consistent resolution info
        b.density "72x72"
        b << "-set" << "units" << "PixelsPerInch"

        # Set consistent user time
        b << "-set" << "user:time" << "0"
      end

      # Write the processed image back
      image.write(icon_path)

    rescue => e
      UI.error "Failed to process #{icon_path}: #{e.message}"
    end
  end

  UI.success "✅ All app icon sizes generated and metadata stripped successfully!"
  UI.message "Icons generated in: Targets/App/Sources/Resources/Assets.xcassets/AppIcon.appiconset/"
  UI.message "📝 Icons are now git-reproducible (no metadata changes on regeneration)"
end

desc <<~DESC
  Generate screenshots
  Captures localized screenshots for App Store using ScreenshotUITests scheme
  Generates screenshots for iPhone and iPad devices
DESC
lane :generate_screenshots do
  UI.message "Generating screenshots"

  capture_screenshots(
    scheme: "ScreenshotUITests",
    devices: [
      "iPhone 17 Pro Max", # iPhone 6.9" display
      "iPhone 17 Pro", # iPhone 6.3" display

      "iPad Pro 13-inch (M5)", # iPad 13" display
      "iPad Pro 11-inch (M5)" # iPad 11" display
    ],
    languages: ["en-US"],

    clear_previous_screenshots: true,
    concurrent_simulators: true,
    skip_open_summary: true,

    reinstall_app: true,
    override_status_bar: true,
    localize_simulator: true,
    disable_slide_to_type: true,
    number_of_retries: 0
  )

  UI.success "✅ Screenshots generated successfully!"
  UI.message "Screenshots generated in: ScreenshotUITests/Screenshots/"
end

desc <<~DESC
  Generate screenshots for CI (single device)
  Captures screenshots on a single iPhone device for faster CI builds
  Use generate_screenshots for full multi-device App Store screenshots
DESC
lane :generate_screenshots_ci do
  UI.message "Generating screenshots for CI (single device)"

  capture_screenshots(
    scheme: "ScreenshotUITests",
    devices: [
      "iPhone 17 Pro" # iPhone 6.3" display
    ],
    languages: ["en-US"],
    configuration: "Debug", # Use Debug to reduce build time (~5-6 min faster than Release)

    clear_previous_screenshots: true,
    concurrent_simulators: false,
    skip_open_summary: true,

    reinstall_app: true,
    override_status_bar: true,
    localize_simulator: true,
    disable_slide_to_type: true,
    number_of_retries: 0
  )

  UI.success "✅ CI screenshots generated successfully!"
  UI.message "Screenshots generated in: fastlane/screenshots/"
end

desc <<~DESC
  Upload screenshots to Sentry
  Uploads generated screenshots to Sentry for visual regression testing
  Requires screenshots to be generated first using generate_screenshots
DESC
lane :upload_screenshots_to_sentry do
  UI.message "Uploading screenshots to Sentry"

  screenshots_path = File.expand_path("./screenshots")

  unless Dir.exist?(screenshots_path)
    UI.user_error! "Screenshots directory not found at #{screenshots_path}. Run generate_screenshots first."
  end

  sentry_upload_snapshots(
    auth_token: ENV["SENTRY_AUTH_TOKEN"],
    org_slug: "techprimate",
    project_slug: "flinky",
    path: screenshots_path,
    app_id: "com.techprimate.Flinky"
  )

  UI.success "✅ Screenshots uploaded to Sentry successfully!"
end

desc <<~DESC
  Generate and upload screenshots to Sentry
  Captures localized screenshots and uploads them to Sentry for visual regression testing
  Combines generate_screenshots and upload_screenshots_to_sentry lanes
DESC
lane :generate_and_upload_screenshots do
  generate_screenshots
  upload_screenshots_to_sentry
end

desc <<~DESC
  Generate and upload screenshots to Sentry (CI optimized)
  Fast single-device screenshot generation for CI builds
  Combines generate_screenshots_ci and upload_screenshots_to_sentry lanes
DESC
lane :generate_and_upload_screenshots_ci do
  generate_screenshots_ci
  upload_screenshots_to_sentry
end

desc <<~DESC
  Upload metadata to App Store Connect
  Uploads app descriptions, screenshots, and other metadata without building/uploading binary
  Useful for updating store listing without creating a new build
DESC
lane :upload_metadata do
  UI.message "Uploading metadata to App Store Connect"
  upload_to_app_store(
    api_key_path: File.expand_path("./api-key.json"),

    skip_binary_upload: true,
    overwrite_screenshots: true,

    run_precheck_before_submit: false,
    precheck_include_in_app_purchases: false,

    languages: ["en-US"],
    metadata_path: File.expand_path("./metadata"),
    screenshots_path: File.expand_path("./screenshots"),

    force: true, # Skip the preview HTML

    app_review_information: {
      email_address: ENV["APP_REVIEW_EMAIL_ADDRESS"],
      phone_number: ENV["APP_REVIEW_PHONE_NUMBER"]
    }
  )
end

desc <<~DESC
  Setup code signing certificates and provisioning profiles
  Syncs development and App Store certificates/profiles for app and share extension
  Uses match to manage certificates and profiles
DESC
lane :setup_code_signing do
  UI.message "Syncing code signing..."
  sync_code_signing(
    type: "development",
    app_identifier: "com.techprimate.Flinky"
  )
  sync_code_signing(
    type: "appstore",
    app_identifier: "com.techprimate.Flinky"
  )
  sync_code_signing(
    type: "development",
    app_identifier: "com.techprimate.Flinky.ShareExtension"
  )
  sync_code_signing(
    type: "appstore",
    app_identifier: "com.techprimate.Flinky.ShareExtension"
  )
  UI.success "✅ Code signing synced successfully!"
end

desc <<~DESC
  Bump the major version number (e.g., 1.1.2 -> 2.0.0)
  Increments major version and resets minor/patch to 0
  Regenerates version files after bumping
  Use for breaking changes or major feature releases
DESC
lane :bump_version_major do
  _bump_version(bump_type: "major")
  _make(target: "generate")
end

desc <<~DESC
  Bump the minor version number (e.g., 1.1.2 -> 1.2.0)
  Increments minor version and resets patch to 0
  Regenerates version files after bumping
  Use for new features or significant improvements
DESC
lane :bump_version_minor do
  _bump_version(bump_type: "minor")
  _make(target: "generate")
end

desc <<~DESC
  Bump the patch version number (e.g., 1.1.2 -> 1.1.3)
  Increments patch version number
  Regenerates version files after bumping
  Use for bug fixes and minor updates
DESC
lane :bump_version_patch do
  _bump_version(bump_type: "patch")
  _make(target: "generate")
end
