# ============================================================================
# FLINKY MAKEFILE
# ============================================================================
# This Makefile provides automation for building, testing, and developing
# the Flinky app. Run 'make help' to see all available commands.
# ============================================================================

# ============================================================================
# SETUP
# ============================================================================

## Setup the project by installing dependencies, pre-commit hooks, rbenv, and bundler. Also runs the generate command.
#
# Sets up a fresh machine for development by chaining the install tasks and running generators.
# Safe to re-run if you need to reinitialize dependencies or hooks.
.PHONY: setup
setup: install-dependencies install-pre-commit install-rbenv install-bundler generate

## Install the project dependencies using Homebrew.
#
# Installs all tools declared in the Brewfile and initializes git submodules.
.PHONY: install-dependencies
install-dependencies:
	brew bundle

	git submodule update --init --recursive

## Install the pre-commit hooks.
#
# Installs repository git hooks to enforce formatting and checks before commits.
.PHONY: install-pre-commit
install-pre-commit:
	pre-commit install

## Install rbenv.
# Ensures the correct Ruby version is available for Bundler and Fastlane.
.PHONY: install-rbenv
install-rbenv:
	rbenv install --skip-existing

## Install bundler.
# Updates Bundler and installs all Ruby gems (e.g., Fastlane).
.PHONY: install-bundler
install-bundler:
	rbenv exec gem update bundler
	rbenv exec bundle install

# ============================================================================
# BUILDING
# ============================================================================

## Build all targets (iOS)
#
# Convenience target that invokes all iOS build targets.
# See build-ios for more details.
.PHONY: build
build: build-ios

## Build all iOS targets (App, Core, ShareExtension) for simulator
#
# Builds the main app, the core framework, and the share extension for the latest simulator.
# See build-ios-app, build-ios-core, and build-ios-share-extension for more details.
.PHONY: build-ios
build-ios: build-ios-app build-ios-core build-ios-share-extension

## Build App target for latest iOS Simulator (iPhone 16 Pro)
#
# Builds the main app for the latest iOS Simulator (iPhone 16 Pro).
# Outputs raw logs to raw-build-ios-app.log and pretty-prints with xcbeautify.
.PHONY: build-ios-app 
build-ios-app: 
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme App -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' build | tee raw-build-ios-app.log | xcbeautify --preserve-unbeautified

## Build FlinkyCore target for latest iOS Simulator (iPhone 16 Pro)
#
# Builds the core module for the latest iOS Simulator (iPhone 16 Pro).
# Validates changes to the core module compile successfully in isolation.
.PHONY: build-ios-core 
build-ios-core: 
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme FlinkyCore -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' build | tee raw-build-ios-core.log | xcbeautify --preserve-unbeautified

## Build ShareExtension target for latest iOS Simulator (iPhone 16 Pro)
#
# Builds the share extension for the latest iOS Simulator (iPhone 16 Pro).
# Ensures the share extension compiles and links correctly against the app.
.PHONY: build-ios-share-extension
build-ios-share-extension:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ShareExtension -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' build | tee raw-build-share-extension-ios.log | xcbeautify --preserve-unbeautified

# ============================================================================
# TESTING
# ============================================================================

## Run all iOS tests (aggregates app/core/share extension)
#
# Runs all unit tests for all primary iOS targets.
.PHONY: test-ios
test-ios: test-ios-app

## Run unit tests for App scheme on latest iOS Simulator
#
# Runs unit tests for the App scheme on the latest iOS Simulator (iPhone 16 Pro).
# Writes logs to raw-test-ios-app.log and formats output with xcbeautify.
.PHONY: test-ios-app
test-ios-app:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme App -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ios-app.log | xcbeautify --preserve-unbeautified

## Run unit tests for FlinkyCore on latest iOS Simulator
#
# Runs unit tests for the FlinkyCore scheme on the latest iOS Simulator (iPhone 16 Pro).
# Core module tests to validate shared logic and utilities.
.PHONY: test-ios-core 
test-ios-core: 
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme FlinkyCore -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ios-core.log | xcbeautify --preserve-unbeautified

## Run tests for ShareExtension target on latest iOS Simulator
#
# Runs unit tests for the ShareExtension scheme on the latest iOS Simulator (iPhone 16 Pro).
# Tests specific to the share extension behavior.
.PHONY: test-ios-share-extension
test-ios-share-extension:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ShareExtensionTests -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ios-share-extension.log | xcbeautify --preserve-unbeautified

## Run all iOS UI test suites
#
# Runs all UI tests for all primary iOS targets.
.PHONY: test-ui-ios
test-ui-ios: test-ui-ios-app

## Run primary UI tests (UITests scheme) on latest iOS Simulator
#
# Runs UI tests for the App scheme on the latest iOS Simulator (iPhone 16 Pro).
.PHONY: test-ui-ios-app
test-ui-ios-app:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme UITests -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ui-ios-app.log | xcbeautify --preserve-unbeautified

## Run screenshot UI tests (ScreenshotUITests scheme)
#
# Runs UI tests for the ScreenshotUITests scheme on the latest iOS Simulator (iPhone 16 Pro).
# Generates localized marketing screenshots via UI automation.
.PHONY: test-ui-ios-screenshot
test-ui-ios-screenshot:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ScreenshotUITests -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ui-screenshot-ios.log | xcbeautify --preserve-unbeautified

## Run UI tests for ShareExtension
#
# Runs UI tests for the ShareExtensionUITests scheme on the latest iOS Simulator (iPhone 16 Pro).
# UI tests targeting the share extension interface.
.PHONY: test-ui-ios-share-extension
test-ui-ios-share-extension:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme ShareExtensionUITests -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ui-share-extension-ios.log | xcbeautify --preserve-unbeautified

# ============================================================================
# FORMATTING
# ============================================================================

## Format Swift, Markdown, JSON and YAML files using project tools
#
# Runs all formatting tasks for all Swift, JSON, Markdown, and YAML files in the project.
.PHONY: format
format: format-swift format-json format-markdown format-yaml

## Format Swift sources and apply SwiftLint auto-fixes
#
# Runs swift-format and SwiftLint to format and autofix Swift code.
.PHONY: format-swift
format-swift:
	swift format --configuration .swift-format.json --in-place --recursive Sources
	swiftlint --config .swiftlint.yml --strict --fix

## Format all JSON files with dprint
#
# Runs dprint to format all JSON files.
.PHONY: format-json
format-json:
	dprint fmt "**/*.json"

## Format all Markdown files with dprint
#
# Runs dprint to format all Markdown files.
.PHONY: format-markdown
format-markdown:
	dprint fmt "**/*.md"

## Format all YAML files with dprint
#
# Runs dprint to format all YAML and YML files.
.PHONY: format-yaml
format-yaml:
	dprint fmt "**/*.{yaml,yml}"

## Run SwiftLint and dprint checks (no fixes)
#
# Runs SwiftLint and dprint checks without modifying files.
.PHONY: lint
lint:
	swiftlint --config .swiftlint.yml --strict
	dprint check "**/*.{md,json,yaml,yml}"

## Generate licenses, settings version, and localization assets
#
# Runs all generator scripts to update licenses, settings version, and localization assets.
.PHONY: generate
generate: generate-licenses generate-version-in-settings generate-localization

## Generate localized strings from xcstrings via script
#
# Runs the generate-localization.sh script to convert xcstrings to strings and generates Swift enums via SwiftGen templates.
.PHONY: generate-localization
generate-localization:
	./Scripts/generate-localization.sh

## Generate third-party licenses for Settings
#
# Runs the generate-licenses.sh script to generate license acknowledgements for Settings.bundle.
.PHONY: generate-licenses
generate-licenses:
	./Scripts/generate-licenses.sh

## Embed app version/build into Settings.bundle
#
# Runs the generate-version-in-settings.sh script to extract MARKETING_VERSION and CURRENT_PROJECT_VERSION and writes to Settings.bundle.
.PHONY: generate-version-in-settings
generate-version-in-settings:
	./Scripts/generate-version-in-settings.sh

## Generate the App Store summary text files
#
# Runs the generate-app-store-summary.sh script to create summary snippets used for release metadata and store listings.
.PHONY: generate-app-store-summary
generate-app-store-summary:
	./Scripts/generate-app-store-summary.sh

## Generate all required app icon variants via Fastlane
#
# Runs Fastlane to render and export all icon sizes for the app.
.PHONY: generate-app-icons
generate-app-icons:
	bundle install
	bundle exec fastlane generate_app_icons

## Generate localized screenshots via Fastlane
#
# Runs Fastlane to render localized screenshots via UI automation flows.
.PHONY: generate-screenshots
generate-screenshots:
	bundle install
	bundle exec fastlane generate_screenshots

# ============================================================================
# PUBLISHING
# ============================================================================

## Build and upload a beta to TestFlight via Fastlane
#
# Runs Fastlane to build, sign, and upload a TestFlight build.
.PHONY: publish-beta-build
publish-beta-build:
	bundle install
	bundle exec fastlane beta

## Upload App Store Connect metadata (descriptions, screenshots)
#
# Runs Fastlane to upload localized descriptions, screenshots, and other metadata without building binaries.
.PHONY: upload-metadata
upload-metadata:
	bundle install
	bundle exec fastlane upload_metadata

# ============================================================================
# HELP & DOCUMENTATION
# ============================================================================

## Show this help message with all available commands
#
# Displays a formatted list of all available make targets with descriptions.
# Commands are organized by topic for easy navigation.
.PHONY: help
help:
	@if [ -n "$(name)" ]; then \
		$(MAKE) --no-print-directory help-target name="$(name)"; \
	else \
		echo "=============================================="; \
		echo "🚀 FLINKY DEVELOPMENT COMMANDS"; \
		echo "=============================================="; \
		echo ""; \
		awk 'BEGIN { summary = ""; n = 0; maxlen = 0 } \
		/^## / { summary = substr($$0, 4); delete details; detailsCount = 0; next } \
		/^\.PHONY: / && summary != "" { \
			for (i = 2; i <= NF; i++) { \
				targets[n] = $$i; \
				summaries[n] = summary; \
				if (length($$i) > maxlen) maxlen = length($$i); \
				n++; \
			} \
			summary = ""; next \
		} \
		END { \
			for (i = 0; i < n; i++) { \
				printf "\033[36m%-*s\033[0m %s\n", maxlen, targets[i], summaries[i]; \
			} \
		}' $(MAKEFILE_LIST); \
		echo ""; \
		echo "💡 Use 'make <command>' to run any command above."; \
		echo "📖 For detailed help on a command, run: make help-<command>  (e.g., make help-build-ios)"; \
		echo "📖 Or: make help name=<command>      (e.g., make help name=build-ios)"; \
		echo ""; \
	fi
 
.PHONY: help-% help-target
help-%:
	@target="$*"; \
	awk -v T="$$target" 'BEGIN { summary = ""; detailsCount = 0; printed = 0; lookingForDeps = 0 } \
	/^## / { summary = substr($$0, 4); delete details; detailsCount = 0; next } \
	/^#($$| )/ { \
		if (summary != "") { \
			line = $$0; \
			if (substr(line,1,2)=="# ") detailLine = substr(line,3); else detailLine = ""; \
			details[detailsCount++] = detailLine; \
		} \
		if (lookingForDeps && $$0 !~ /^#/) { lookingForDeps = 0 } \
		next \
	} \
	/^\.PHONY: / && summary != "" { \
		for (i = 2; i <= NF; i++) { \
			if ($$i == T) { \
				found = 1; \
				lookingForDeps = 1; \
				break \
			} \
		} \
		if (!found) { summary = ""; detailsCount = 0; delete details } \
		next \
	} \
	lookingForDeps && /^[A-Za-z0-9_.-]+[ \t]*:/ && $$0 !~ /^\.PHONY:/ && $$0 !~ /^\t/ && index($$0,"=")==0 { \
		raw = $$0; \
		split(raw, parts, ":"); \
		tn = parts[1]; \
		if (tn == T) { \
			depStr = substr(raw, index(raw, ":")+1); \
			gsub(/^[ \t]+|[ \t]+$$/, "", depStr); \
			firstDep = depStr; \
			split(depStr, depParts, /[ \t]+/); \
			if (length(depParts[1]) > 0) firstDep = depParts[1]; \
			lookingForDeps = 0; \
		} \
		next \
	} \
	found && !lookingForDeps { \
		printf "%s\n", summary; \
		for (j = 0; j < detailsCount; j++) { \
			if (length(details[j]) > 0) printf "%s\n", details[j]; else print ""; \
		} \
		print ""; \
		printf "Usage:\n"; \
		if (length(firstDep) > 0) { \
			printf "  make %s\n", firstDep; \
		} else { \
			printf "  make %s\n", T; \
		} \
		printed = 1; \
		found = 0; summary = ""; detailsCount = 0; delete details; firstDep = ""; \
		next \
	} \
	END { if (!printed) { printf "No detailed help found for target: %s\n", T } }' $(MAKEFILE_LIST)

help-target:
	@[ -n "$(name)" ] || { echo "Usage: make help name=<target>"; exit 1; }; \
	awk -v T="$(name)" 'BEGIN { summary = ""; detailsCount = 0; printed = 0; lookingForDeps = 0 } \
	/^## / { summary = substr($$0, 4); delete details; detailsCount = 0; next } \
	/^#($$| )/ { \
		if (summary != "") { \
			line = $$0; \
			if (substr(line,1,2)=="# ") detailLine = substr(line,3); else detailLine = ""; \
			details[detailsCount++] = detailLine; \
		} \
		if (lookingForDeps && $$0 !~ /^#/) { lookingForDeps = 0 } \
		next \
	} \
	/^\.PHONY: / && summary != "" { \
		for (i = 2; i <= NF; i++) { \
			if ($$i == T) { \
				found = 1; \
				lookingForDeps = 1; \
				break \
			} \
		} \
		if (!found) { summary = ""; detailsCount = 0; delete details } \
		next \
	} \
	lookingForDeps && /^[A-Za-z0-9_.-]+[ \t]*:/ && $$0 !~ /^\.PHONY:/ && $$0 !~ /^\t/ && index($$0,"=")==0 { \
		raw = $$0; \
		split(raw, parts, ":"); \
		tn = parts[1]; \
		if (tn == T) { \
			depStr = substr(raw, index(raw, ":")+1); \
			gsub(/^[ \t]+|[ \t]+$$/, "", depStr); \
			firstDep = depStr; \
			split(depStr, depParts, /[ \t]+/); \
			if (length(depParts[1]) > 0) firstDep = depParts[1]; \
			lookingForDeps = 0; \
		} \
		next \
	} \
	found && !lookingForDeps { \
		printf "%s\n\n", summary; \
		for (j = 0; j < detailsCount; j++) { \
			if (length(details[j]) > 0) printf "%s\n", details[j]; else print ""; \
		} \
		print ""; \
		printf "Usage:\n"; \
		if (length(firstDep) > 0) { \
			printf "  make %s\n", firstDep; \
		} else { \
			printf "  make %s\n", T; \
		} \
		printed = 1; \
		found = 0; summary = ""; detailsCount = 0; delete details; firstDep = ""; \
		next \
	} \
	END { if (!printed) { printf "No detailed help found for target: %s\n", T } }' $(MAKEFILE_LIST)
