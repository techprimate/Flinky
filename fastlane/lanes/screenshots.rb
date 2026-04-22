# frozen_string_literal: true

require "fileutils"
require "json"

# ============================================================================
# SCREENSHOT LANES
# ============================================================================
# Lanes for parallel screenshot generation using build-for-testing and
# test-without-building. This avoids fastlane snapshot's per-device-family
# rebuild and enables splitting across multiple CI jobs.
#
# Usage:
#   1. build_screenshots              → builds test bundle once
#   2. run_screenshot_on_device       → runs tests on a single device (parallelizable)
#   3. collect_screenshots            → gathers results into fastlane/screenshots/
#
# CI workflow runs step 1, then step 2 in parallel jobs, then step 3.
# ============================================================================

# Screenshots output directory relative to project root
SCREENSHOTS_OUTPUT_DIR = "fastlane/screenshots"

# Default devices for App Store Connect
SCREENSHOT_DEVICES = [
  "iPhone 17 Pro Max",     # iPhone 6.9" display
  "iPhone 17 Pro",         # iPhone 6.3" display
  "iPad Pro 13-inch (M5)", # iPad 13" display
  "iPad Pro 11-inch (M5)"  # iPad 11" display
].freeze

# Default language for screenshots
SCREENSHOT_LANGUAGE = "en-US"

desc <<~DESC
  Build screenshot test bundle for testing
  Runs xcodebuild build-for-testing to compile the test bundle once.
  The output can then be used by run_screenshot_on_device for each device.
  Options:
    derived_data_path: path for build products (default: /tmp/screenshot_derived_data)
DESC
lane :build_screenshots do |options|
  derived_data_path = options[:derived_data_path] || "/tmp/screenshot_derived_data"

  UI.message "Building screenshot test bundle..."

  run_tests(
    project: "Flinky.xcodeproj",
    scheme: "ScreenshotUITests",
    configuration: "Debug",
    derived_data_path: derived_data_path,
    destination: "generic/platform=iOS Simulator",
    build_for_testing: true,
    xcargs: "SWIFT_TREAT_WARNINGS_AS_ERRORS=NO"
  )

  # Find the generated xctestrun file
  xctestrun_files = Dir.glob("#{derived_data_path}/Build/Products/*.xctestrun")
  UI.user_error!("No .xctestrun file found in #{derived_data_path}/Build/Products/") if xctestrun_files.empty?

  xctestrun_path = xctestrun_files.first
  UI.success "✅ Screenshot test bundle built successfully!"
  UI.message "xctestrun: #{xctestrun_path}"
  UI.message "Products: #{derived_data_path}/Build/Products/"

  next xctestrun_path
end

desc <<~DESC
  Run screenshot tests on a single device
  Runs test-without-building on the specified device using a pre-built test bundle.
  Handles simulator status bar override and screenshot collection.
  Options:
    device: simulator device name (required, e.g. "iPhone 17 Pro")
    derived_data_path: path to pre-built test products (default: /tmp/screenshot_derived_data)
    language: language code for screenshots (default: en-US)
DESC
lane :run_screenshot_on_device do |options|
  device = options[:device]
  UI.user_error!("device is required") unless device

  derived_data_path = options[:derived_data_path] || "/tmp/screenshot_derived_data"
  language = options[:language] || SCREENSHOT_LANGUAGE

  # Find xctestrun file
  xctestrun_files = Dir.glob("#{derived_data_path}/Build/Products/*.xctestrun")
  UI.user_error!("No .xctestrun file found. Run build_screenshots first.") if xctestrun_files.empty?
  xctestrun_path = xctestrun_files.first

  # Setup fastlane snapshot cache directory (SnapshotHelper.swift reads from here)
  cache_dir = File.expand_path("~/Library/Caches/tools.fastlane")
  screenshots_dir = "#{cache_dir}/screenshots"
  FileUtils.mkdir_p(screenshots_dir)

  File.write("#{cache_dir}/language.txt", language)
  File.write("#{cache_dir}/locale.txt", language)
  File.write("#{cache_dir}/snapshot-launch_arguments.txt", "")

  UI.message "Running screenshots on: #{device}"

  # Boot simulator and override status bar
  simulator_udid = _find_simulator_udid(device: device)
  _boot_simulator(udid: simulator_udid)
  _override_status_bar(udid: simulator_udid)

  begin
    # scan auto-discovers Flinky.xcodeproj from cwd and requires a scheme
    # to disambiguate. test_without_building + xctestrun ensures the
    # pre-built bundle is reused instead of triggering a rebuild.
    run_tests(
      project: "Flinky.xcodeproj",
      scheme: "ScreenshotUITests",
      xctestrun: xctestrun_path,
      test_without_building: true,
      destination: "platform=iOS Simulator,name=#{device}",
      only_testing: ["ScreenshotUITests/ScreenshotUITests/testScreenshots"],
      reinstall_app: true,
      output_types: "",
      fail_build: true,
      # Absorb long-press / context-menu flake (notably on iPad). Mirrors
      # the retries already configured on capture_screenshots in utilities.rb.
      number_of_retries: 3
    )
  ensure
    # Always clear status bar, even on failure
    _clear_status_bar(udid: simulator_udid)
  end

  # Verify screenshots were generated for this device
  screenshots_dir = File.expand_path("~/Library/Caches/tools.fastlane/screenshots")
  device_screenshots = Dir.glob("#{screenshots_dir}/#{device}-*.png")
  if device_screenshots.empty?
    UI.user_error!("No screenshots found for #{device} in #{screenshots_dir}")
  end

  UI.success "✅ #{device_screenshots.length} screenshots captured on #{device}"
  device_screenshots.each { |f| UI.message "   #{File.basename(f)}" }
end

desc <<~DESC
  Collect screenshots from cache into fastlane/screenshots directory
  Gathers screenshots generated by run_screenshot_on_device into the
  fastlane/screenshots/en-US/ directory structure expected by deliver.
  Options:
    language: language code (default: en-US)
    output_dir: output directory (default: fastlane/screenshots)
DESC
lane :collect_screenshots do |options|
  language = options[:language] || SCREENSHOT_LANGUAGE
  output_dir = options[:output_dir] || SCREENSHOTS_OUTPUT_DIR

  cache_dir = File.expand_path("~/Library/Caches/tools.fastlane/screenshots")
  lang_dir = File.expand_path("../#{output_dir}/#{language}")

  # Clear previous screenshots
  FileUtils.rm_rf(lang_dir) if Dir.exist?(lang_dir)
  FileUtils.mkdir_p(lang_dir)

  screenshots = Dir.glob("#{cache_dir}/*.png")
  if screenshots.empty?
    UI.user_error!("No screenshots found in #{cache_dir}. Run run_screenshot_on_device first.")
  end

  screenshots.each do |file|
    FileUtils.cp(file, lang_dir)
    UI.message "   ✅ #{File.basename(file)}"
  end

  expected = SCREENSHOT_DEVICES.length * 4 # 4 screenshots per device
  if screenshots.length == expected
    UI.success "✅ All #{screenshots.length} screenshots collected!"
  else
    UI.important "⚠️  Collected #{screenshots.length} screenshots (expected #{expected})"
  end
end

desc <<~DESC
  Generate all screenshots using a single build
  Builds the test bundle once, then runs tests on all devices sequentially.
  For local use — CI uses parallel jobs instead.
  Options:
    derived_data_path: path for build products (default: /tmp/screenshot_derived_data)
DESC
lane :generate_screenshots_parallel do |options|
  derived_data_path = options[:derived_data_path] || "/tmp/screenshot_derived_data"

  # Build once
  build_screenshots(derived_data_path: derived_data_path)

  # Clear screenshot cache
  cache_dir = File.expand_path("~/Library/Caches/tools.fastlane/screenshots")
  FileUtils.rm_rf(cache_dir)
  FileUtils.mkdir_p(cache_dir)

  # Run on all devices
  SCREENSHOT_DEVICES.each do |device|
    run_screenshot_on_device(
      device: device,
      derived_data_path: derived_data_path
    )
  end

  # Collect results
  collect_screenshots
end

# Private lane: Find simulator UDID by device name
private_lane :_find_simulator_udid do |options|
  device = options[:device]

  devices_json = sh("xcrun simctl list devices available -j", log: false).strip
  devices = JSON.parse(devices_json)["devices"].values.flatten
  match = devices.find { |d| d["name"] == device && d["isAvailable"] }
  UI.user_error!("Simulator not found: #{device}") unless match

  next match["udid"]
end

# Private lane: Boot a simulator by UDID and block until it is fully booted.
# `simctl boot` returns as soon as the boot process is kicked off, not when
# the device is ready. `bootstatus -b` blocks until the simulator reaches the
# home screen. Without this, subsequent `simctl status_bar override` calls
# race the boot and silently no-op, leaking the real clock into screenshots.
private_lane :_boot_simulator do |options|
  udid = options[:udid]
  UI.message "Booting simulator: #{udid}"
  sh("xcrun simctl boot #{udid} 2>/dev/null || true", log: false)
  sh("xcrun simctl bootstatus #{udid} -b 2>/dev/null", log: false)
end

# Private lane: Override simulator status bar for clean screenshots
private_lane :_override_status_bar do |options|
  udid = options[:udid]
  UI.message "Overriding status bar..."
  sh(
    "xcrun", "simctl", "status_bar", udid, "override",
    "--time", "09:41",
    "--dataNetwork", "wifi",
    "--wifiMode", "active",
    "--wifiBars", "3",
    "--cellularMode", "active",
    "--operatorName", "",
    "--cellularBars", "4",
    "--batteryState", "charged",
    "--batteryLevel", "100"
  )
end

# Private lane: Clear simulator status bar override
private_lane :_clear_status_bar do |options|
  udid = options[:udid]
  UI.message "Clearing status bar override..."
  sh("xcrun simctl status_bar #{udid} clear 2>/dev/null || true", log: false)
end
