.PHONY: format lint generate generate-licenses generate-localization generate-app-store-summary generate-app-icons generate-screenshots publish-beta-build

.PHONY: build-ios
build-ios: build-ios-app build-ios-core build-ios-share-extension

.PHONY: build-ios-app
build-ios-app: 
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme App -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' build | tee raw-build-ios-app.log | xcbeautify --preserve-unbeautified

.PHONY: build-ios-core
build-ios-core: 
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme FlinkyCore -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' build | tee raw-build-ios-core.log | xcbeautify --preserve-unbeautified

.PHONY: build-ios-share-extension
build-ios-share-extension:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ShareExtension -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' build | tee raw-build-share-extension-ios.log | xcbeautify --preserve-unbeautified

.PHONY: test-ios
test-ios: test-ios-app

.PHONY: test-ios-app
test-ios-app:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme App -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ios-app.log | xcbeautify --preserve-unbeautified

.PHONY: test-ios-core
test-ios-core: 
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme FlinkyCore -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ios-core.log | xcbeautify --preserve-unbeautified

.PHONY: test-ios-share-extension
test-ios-share-extension:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ShareExtensionTests -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ios-share-extension.log | xcbeautify --preserve-unbeautified

.PHONY: test-ui-ios
test-ui-ios: test-ui-ios-app

.PHONY: test-ui-ios-app
test-ui-ios-app:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme UITests -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ui-ios-app.log | xcbeautify --preserve-unbeautified

.PHONY: test-ui-ios-screenshot
test-ui-ios-screenshot:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ScreenshotUITests -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ui-screenshot-ios.log | xcbeautify --preserve-unbeautified

.PHONY: test-ui-ios-share-extension
test-ui-ios-share-extension:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ShareExtensionUITests -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ui-share-extension-ios.log | xcbeautify --preserve-unbeautified

.PHONY: format
format: format-swift format-json format-markdown format-yaml

.PHONY: format-swift
format-swift:
	swift format --configuration .swift-format.json --in-place --recursive Sources
	swiftlint --config .swiftlint.yml --strict --fix

.PHONY: format-json
format-json:
	dprint fmt "**/*.json"

.PHONY: format-markdown
format-markdown:
	dprint fmt "**/*.md"

.PHONY: format-yaml
format-yaml:
	dprint fmt "**/*.{yaml,yml}"

.PHONY: lint
lint:
	swiftlint --config .swiftlint.yml --strict
	dprint check "**/*.{md,json,yaml,yml}"

.PHONY: generate generate-licenses generate-version-in-settings generate-localization
generate: generate-licenses generate-version-in-settings generate-localization

generate-localization:
	./Scripts/generate-localization.sh

.PHONY: generate-licenses
generate-licenses:
	./Scripts/generate-licenses.sh

.PHONY: generate-version-in-settings
generate-version-in-settings:
	./Scripts/generate-version-in-settings.sh

.PHONY: generate-app-store-summary
generate-app-store-summary:
	./Scripts/generate-app-store-summary.sh

.PHONY: generate-app-icons
generate-app-icons:
	bundle install
	bundle exec fastlane generate_app_icons

.PHONY: generate-screenshots
generate-screenshots:
	bundle install
	bundle exec fastlane generate_screenshots

.PHONY: publish-beta-build
publish-beta-build:
	bundle install
	bundle exec fastlane beta

.PHONY: upload-metadata
upload-metadata:
	bundle install
	bundle exec fastlane upload_metadata
