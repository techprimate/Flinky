.PHONY: build-ios test-ios format lint generate generate-licenses generate-localization generate-app-store-summary generate-app-icons generate-screenshots publish-beta-build

build-ios:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme Flinky -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build | tee raw-build-ios.log | xcbeautify

test-ios:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme Flinky -destination 'platform=iOS Simulator,name=iPhone 16 Pro' test | tee raw-test-ios.log | xcbeautify

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
