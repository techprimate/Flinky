.PHONY: build-ios build-core-ios build-share-extension-ios test-ios test-core-ios test-ui-ios format lint generate generate-licenses generate-localization generate-app-store-summary generate-app-icons generate-screenshots publish-beta-build

# Builds the app target with all other targets as dependencies
build-ios: 
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme App -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build | tee raw-build-ios.log | xcbeautify

# Builds the core target
build-core-ios: 
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme FlinkyCore -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build | tee raw-build-ios-core.log | xcbeautify

# Builds the ShareExtension target
build-share-extension-ios:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ShareExtension -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build | tee raw-build-share-extension-ios.log | xcbeautify

# Tests the app target including all other targets as dependencies
test-ios:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme App -destination 'platform=iOS Simulator,name=iPhone 16 Pro' test | tee raw-test-ios.log | xcbeautify

# Tests the core target
test-core-ios: 
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme FlinkyCore -destination 'platform=iOS Simulator,name=iPhone 16 Pro' test | tee raw-test-ios-core.log | xcbeautify

# Tests the UI tests target
test-ui-ios:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ScreenshotUITests -destination 'platform=iOS Simulator,name=iPhone 16 Pro' test | tee raw-test-ui-ios.log | xcbeautify

format: format-swift format-json format-markdown format-yaml

format-swift:
	swift format --configuration .swift-format.json --in-place --recursive Sources
	swiftlint --config .swiftlint.yml --strict --fix

format-json:
	dprint fmt "**/*.json"

format-markdown:
	dprint fmt "**/*.md"

format-yaml:
	dprint fmt "**/*.{yaml,yml}"

lint:
	swiftlint --config .swiftlint.yml --strict
	dprint check "**/*.{md,json,yaml,yml}"

generate: generate-licenses generate-version-in-settings generate-localization

generate-localization:
	./Scripts/generate-localization.sh

generate-licenses:
	./Scripts/generate-licenses.sh

generate-version-in-settings:
	./Scripts/generate-version-in-settings.sh

generate-app-store-summary:
	./Scripts/generate-app-store-summary.sh

generate-app-icons:
	bundle install
	bundle exec fastlane generate_app_icons

generate-screenshots:
	bundle install
	bundle exec fastlane generate_screenshots

publish-beta-build:
	bundle install
	bundle exec fastlane beta

upload-metadata:
	bundle install
	bundle exec fastlane upload_metadata
