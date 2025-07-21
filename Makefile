.PHONY: format lint generate generate-licenses

format:
	swiftformat Sources
	swiftlint --config .swiftlint.yml --strict --fix

lint:
	swiftlint --config .swiftlint.yml --strict

generate: generate-licenses

generate-licenses:
	license-plist \
		--output-path Sources/Resources/Settings.bundle \
		--prefix Licenses \
		--add-version-numbers \
		--suppress-opening-directory \
		--fail-if-missing-license
