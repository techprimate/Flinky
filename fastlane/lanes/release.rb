# frozen_string_literal: true

# ============================================================================
# RELEASE LANES
# ============================================================================
# Lanes for releasing the app to TestFlight and App Store.
# ============================================================================

desc "Push a new beta build to TestFlight"
desc "Increments version/build, builds app, uploads to TestFlight, and commits/tags changes"
desc "Use this lane for local manual releases (commits directly to current branch)"
desc "Options: distribute_external (default: false) - whether to distribute to external groups"
lane :beta do |options|
  # Configure CI keychain and set match to readonly to avoid prompts
  setup_ci if is_ci

  version_info = _increment_version_and_build
  version_number = version_info[:version]
  build_number = version_info[:build]

  _setup_code_signing
  _build_app_for_store
  _validate_app
  _setup_sentry_release(version: version_number, build: build_number)

  # Upload to TestFlight
  upload_to_testflight(
    # API Key file must be located at fastlane/api-key.json
    api_key_path: File.expand_path("./api-key.json"),
    app_version: version_number,
    build_number: build_number,

    distribute_external: options[:distribute_external] || false,
    groups: ["Friends At Sentry", "Friends Of Phil"],
    beta_app_description: "Thanks for testing Flinky!

Please focus on testing these core features:
• Creating and editing links - try various URL types (websites, deep links, etc.)
• Organizing links into lists with custom colors and symbols
• Link sharing via QR codes, AirDrop, and standard sharing
• Search functionality across your links and lists
• Link management actions (edit, delete, pin, move between lists)

Pay special attention to:
• App performance and responsiveness
• Any crashes or unexpected behavior
• UI/UX issues or confusing interactions
• Accessibility with VoiceOver if possible

In case you notice any issues, please use the \"Send Feedback\" button in the app, or take a screenshot, tap on the share button and select \"Share Beta Feedback\".

Your feedback helps us improve Flinky for everyone. Thank you!"
  )

  _finalize_sentry_release(version: version_number, build: build_number)
  _commit_and_tag_version(version: version_number, build: build_number)
end

desc "Prepare release: bump version and create release branch with PR"
desc "Checks App Store Connect for published version and bumps patch if needed"
desc "Queries TestFlight for latest build number and sets next build number"
desc "Used by prepare-release.yml workflow (scheduled/manual trigger)"
desc "The PR will trigger deploy-beta.yml workflow when the release branch is pushed"
lane :prepare_release do
  # Check App Store Connect and bump version if needed
  version_check_result = _check_and_bump_version_if_needed
  version_number = version_check_result[:version]

  # Query TestFlight for latest build number and set next one
  build_number = _get_next_build_number(version: version_number)

  # Generate version files
  _make(target: "generate")

  # Create PR with version changes
  _create_version_pr(version: version_number, build: build_number)
end

desc "Deploy beta build to TestFlight (triggered by release branch push)"
desc "Builds app, validates, uploads to TestFlight (internal only), and sets up Sentry release"
desc "Used by deploy-beta.yml workflow (triggered by pushes to release/** branches)"
desc "Idempotent: checks if build already exists on TestFlight and skips if already uploaded"
desc "Safe to re-run on failures - will skip upload if previous run succeeded"
lane :deploy_beta do
  # Configure CI keychain and set match to readonly to avoid prompts
  setup_ci if is_ci

  # Get version and build from project (already set in prepare_release)
  version_number = get_version_number(
    xcodeproj: "Flinky.xcodeproj",
    target: "Flinky"
  )
  build_number = get_build_number(xcodeproj: "Flinky.xcodeproj")

  # Check if this build is already uploaded to TestFlight
  if _build_already_uploaded?(version: version_number, build: build_number)
    UI.success "✅ Build #{version_number} (#{build_number}) already exists on TestFlight"
    UI.success "Skipping upload - previous run succeeded. Nothing to do."
    next
  end

  UI.message "Build #{version_number} (#{build_number}) not yet uploaded, proceeding with deployment..."

  _setup_code_signing
  _build_app_for_store
  _validate_app
  _setup_sentry_release(version: version_number, build: build_number)

  # Upload to TestFlight (internal build only, no external distribution)
  upload_to_testflight(
    # API Key file must be located at fastlane/api-key.json
    api_key_path: File.expand_path("./api-key.json"),
    app_version: version_number,
    build_number: build_number,

    distribute_external: false,
    skip_waiting_for_build_processing: false
  )

  _finalize_sentry_release(version: version_number, build: build_number)
end

desc "Publish a new build to the App Store and submit for review"
desc "Increments version/build, builds app, uploads metadata and binary, submits for review"
desc "Commits and tags version changes after successful upload"
desc "Use this lane for production App Store releases"
lane :publish do
  version_info = _increment_version_and_build
  version_number = version_info[:version]
  build_number = version_info[:build]

  _build_app_for_store
  _validate_app
  _setup_sentry_release(version: version_number, build: build_number)

  # Upload metadata and binary to App Store Connect, then submit for review
  upload_to_app_store(
    api_key_path: File.expand_path("./api-key.json"),

    skip_binary_upload: false,
    overwrite_screenshots: true,
    submit_for_review: true,

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

  _finalize_sentry_release(version: version_number, build: build_number)
  _commit_and_tag_version(version: version_number, build: build_number)
end
