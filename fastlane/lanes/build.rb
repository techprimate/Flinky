# frozen_string_literal: true

# ============================================================================
# BUILD LANES
# ============================================================================
# Lanes for building the app in CI and local environments.
# ============================================================================

desc "Build the app for CI (creates archive for App Store distribution)"
lane :build_ci do
  # Configure CI keychain and set match to readonly to avoid prompts
  setup_ci if is_ci

  # Setup code signing
  _setup_code_signing

  # Build and export the app to an archive
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

  # Upload the archive to Sentry for further analysis
  sentry_upload_build(
    auth_token: ENV["SENTRY_AUTH_TOKEN"],
    org_slug: "techprimate",
    project_slug: "flinky",
    xcarchive_path: "./Flinky.xcarchive"
  ) if is_ci
end
