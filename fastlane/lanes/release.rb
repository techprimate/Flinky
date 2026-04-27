# frozen_string_literal: true

# ============================================================================
# RELEASE LANES
# ============================================================================
# Lanes for releasing the app to TestFlight and App Store.
# ============================================================================

desc <<~DESC
  Push a new beta build to TestFlight
  Increments version/build, builds app, uploads to TestFlight, and commits/tags changes
  Use this lane for local manual releases (commits directly to current branch)
  Options: distribute_external (default: false) - whether to distribute to external groups
DESC
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

desc <<~DESC
  Release beta: prepare version, deploy to TestFlight, then commit and tag on main
  Single CI lane used by release-beta.yml (scheduled/manual). No PR.
  Creates a signed, verified commit via the GitHub API linked to the GitHub App.
DESC
lane :beta_ci do
  setup_ci if is_ci

  # Prepare: check App Store Connect, bump patch if needed, get next build from TestFlight
  version_check_result = _check_and_bump_version_if_needed
  version_number = version_check_result[:version]
  build_number = _get_next_build_number(version: version_number)
  _make(target: "generate")

  # Deploy to TestFlight
  _setup_code_signing
  _build_app_for_store
  _validate_app
  _setup_sentry_release(version: version_number, build: build_number)
  upload_to_testflight(
    api_key_path: File.expand_path("./api-key.json"),
    app_version: version_number,
    build_number: build_number,
    distribute_external: false,
    skip_waiting_for_build_processing: false
  )
  _finalize_sentry_release(version: version_number, build: build_number)

  # Commit and tag on main via GitHub API (creates a signed, verified commit)
  _commit_and_tag_version_signed(version: version_number, build: build_number)
end

desc <<~DESC
  Publish a new build to the App Store and submit for review
  Increments version/build, builds app, uploads metadata and binary, submits for review
  Commits and tags version changes after successful upload
  Use this lane for production App Store releases
DESC
lane :publish do
  version_info = _increment_version_and_build
  version_number = version_info[:version]
  build_number = version_info[:build]

  _setup_code_signing
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

desc <<~DESC
  Release CI: Build phase
  Prepares version, builds IPA, validates, and sets up Sentry release.
  Outputs version and build number for downstream jobs.
  Used by the parallel release workflow (release.yml).
DESC
lane :publish_ci_build do
  setup_ci if is_ci

  # Prepare: check App Store Connect, bump patch if needed, get next build from TestFlight
  version_check_result = _check_and_bump_version_if_needed
  version_number = version_check_result[:version]
  build_number = _get_next_build_number(version: version_number)
  _make(target: "generate")

  # Build and validate
  _setup_code_signing
  _build_app_for_store
  _validate_app
  _setup_sentry_release(version: version_number, build: build_number)

  # Write version info for downstream jobs
  Dir.chdir("..") do
    File.write("version.txt", version_number)
    File.write("build_number.txt", build_number)
  end

  UI.success "✅ Release build complete: #{version_number} (#{build_number})"
end

desc <<~DESC
  Release CI: Upload phase
  Uploads IPA and screenshots to App Store Connect, submits for review,
  finalizes Sentry release, and commits/tags the version.
  Expects IPA at project root and screenshots in fastlane/screenshots/.
  Options:
    version: version number (required)
    build: build number (required)
    ref: git ref the release was dispatched from (optional, default "main").
         Commit+tag on main is skipped when ref != "main" to avoid creating
         version tags whose tree doesn't match what was uploaded.
DESC
lane :publish_ci_upload do |options|
  setup_ci if is_ci

  version_number = options[:version]
  build_number = options[:build]
  release_ref = options[:ref] || "main"

  UI.user_error!("version is required") unless version_number
  UI.user_error!("build is required") unless build_number

  # Upload to App Store Connect with metadata, screenshots, and submit for review
  upload_to_app_store(
    api_key_path: File.expand_path("./api-key.json"),
    ipa: File.expand_path("../Flinky.ipa"), # Explicit path to avoid relying on SharedValues

    app_version: version_number,

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

  # Commit and tag on main via GitHub API (creates a signed, verified commit).
  # Skipped for non-main dispatches: _commit_and_tag_version_signed overlays
  # VERSION_BUMP_FILES onto main's tree, which would not match the IPA that
  # was actually uploaded from a feature branch.
  if release_ref == "main"
    _commit_and_tag_version_signed(version: version_number, build: build_number)
  else
    UI.important "Skipping commit+tag: dispatched from ref '#{release_ref}', not main"
  end
end
