# frozen_string_literal: true

# ============================================================================
# SENTRY INTEGRATION LANES
# ============================================================================
# Private lanes for Sentry release management and symbol uploads.
# ============================================================================

# Private lane: Setup Sentry release (create release, upload symbols, upload build, set commits)
private_lane :_setup_sentry_release do |options|
  version_number = options[:version]
  build_number = options[:build]

  # Create Sentry release using the same format as the app
  sentry_create_release(
    auth_token: ENV["SENTRY_AUTH_TOKEN"],
    org_slug: "techprimate",
    project_slug: "flinky",

    app_identifier: "com.techprimate.Flinky",
    version: version_number
  )

  # Upload debug symbols to Sentry
  sentry_debug_files_upload(
    auth_token: ENV["SENTRY_AUTH_TOKEN"],
    org_slug: "techprimate",
    project_slug: "flinky",

    # Wait for the server to fully process uploaded files. Errors
    # can only be displayed if --wait is specified, but this will
    # significantly slow down the upload process
    wait: true
  )

  # Upload the xcarchive to Sentry for further analysis
  sentry_upload_build(
    auth_token: ENV["SENTRY_AUTH_TOKEN"],
    org_slug: "techprimate",
    project_slug: "flinky",
    xcarchive_path: "./Flinky.xcarchive"
  )

  # Associate commits with the release
  sentry_set_commits(
    auth_token: ENV["SENTRY_AUTH_TOKEN"],
    org_slug: "techprimate",
    project_slug: "flinky",

    app_identifier: "com.techprimate.Flinky",
    version: version_number,
    build: build_number,
    auto: true
  )
end

# Private lane: Finalize Sentry release after successful upload
private_lane :_finalize_sentry_release do |options|
  version_number = options[:version]
  build_number = options[:build]

  sentry_finalize_release(
    auth_token: ENV["SENTRY_AUTH_TOKEN"],
    org_slug: "techprimate",
    project_slug: "flinky",

    app_identifier: "com.techprimate.Flinky",
    version: version_number,
    build: build_number
  )
end
