.PHONY: format lint generate generate-licenses

format:
	swiftformat Sources
	swiftlint --config .swiftlint.yml --strict --fix

lint:
	swiftlint --config .swiftlint.yml --strict

generate: generate-licenses generate-version-in-settings

generate-licenses:
	license-plist \
		--output-path Sources/Resources/Settings.bundle \
		--prefix Licenses \
		--add-version-numbers \
		--suppress-opening-directory \
		--fail-if-missing-license

generate-version-in-settings:
	$(eval MARKETING_VERSION := $(shell xcodebuild -project Flinky.xcodeproj -showBuildSettings -configuration Release | grep MARKETING_VERSION | awk '{print $$3}'))
	$(eval BUILD_VERSION := $(shell xcodebuild -project Flinky.xcodeproj -showBuildSettings -configuration Release | grep CURRENT_PROJECT_VERSION | awk '{print $$3}'))
	plutil -replace PreferenceSpecifiers.0.DefaultValue -string "$(MARKETING_VERSION) ($(BUILD_VERSION))" Sources/Resources/Settings.bundle/Root.plist