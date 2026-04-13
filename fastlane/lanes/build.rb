# frozen_string_literal: true

# ============================================================================
# BUILD LANES
# ============================================================================
# Lanes for building the app in CI and local environments.
# ============================================================================

desc "Build the app for CI (creates development archive and uploads to Sentry App Analysis)"
lane :build_ci do
  # Configure CI keychain and set match to readonly to avoid prompts
  setup_ci if is_ci

  # Setup development code signing
  _setup_code_signing_development

  # Build and export the app as a development build
  build_app(
    project: "Flinky.xcodeproj",
    scheme: "App",
    archive_path: "./Flinky.xcarchive",
    build_path: ".",
    export_options: {
      "destination" => "export",
      "method" => "development",
      "provisioningProfiles" => {
        "com.techprimate.Flinky" => "match Development com.techprimate.Flinky",
        "com.techprimate.Flinky.ShareExtension" => "match Development com.techprimate.Flinky.ShareExtension"
      },
      "signingCertificate" => "Apple Development",
      "signingStyle" => "manual",
      "teamID" => "BZ362SQ6AB"
    }
  )

  # Upload the archive to Sentry for further analysis
  sentry_upload_build(
    auth_token: ENV["SENTRY_AUTH_TOKEN"],
    org_slug: "techprimate",
    project_slug: "flinky",
    xcarchive_path: "./Flinky.xcarchive"
  ) if is_ci
end
