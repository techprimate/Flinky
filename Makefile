.PHONY: build-ios format lint generate generate-licenses generate-localization

build-ios:
	xcrun xcodebuild -project Flinky.xcodeproj -scheme Flinky -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build | xcbeautify

format:
	swiftformat Sources
	swiftlint --config .swiftlint.yml --strict --fix

lint:
	swiftlint --config .swiftlint.yml --strict

generate: generate-licenses generate-version-in-settings generate-localization

generate-localization:
	./Scripts/generate-localization.sh

generate-licenses:
	./Scripts/generate-licenses.sh

generate-version-in-settings:
	./Scripts/generate-version-in-settings.sh