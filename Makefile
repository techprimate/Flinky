.PHONY: format lint generate generate-licenses generate-localization

format:
	swiftformat Sources
	swiftlint --config .swiftlint.yml --strict --fix

lint:
	swiftlint --config .swiftlint.yml --strict

generate: generate-licenses generate-version-in-settings generate-localization

generate-localization:
	./Scripts/generate-localization.sh

generate-licenses:
	license-plist \
		--output-path Sources/Resources/Settings.bundle \
		--prefix Licenses \
		--add-version-numbers \
		--suppress-opening-directory \
		--fail-if-missing-license

generate-version-in-settings:
	./Scripts/generate-version-in-settings.sh