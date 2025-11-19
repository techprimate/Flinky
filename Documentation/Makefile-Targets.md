# Makefile Targets Guide

This guide explains how to add and document Makefile targets so they show up in `make help` and stay consistent across the project.

## Principles

- Each user-facing target must have a short description line immediately above it using `##`.
- Further detailed descriptions can be added between the `##` summary and `.PHONY:` declaration using `#`.
- Every target that users can invoke should be declared `.PHONY`.
- Keep names concise and action-oriented (build, test, format, generate, publish).
- Group related targets under the existing sections: Setup, Building, Testing, Formatting, Generating, Publishing.

## Anatomy of a target

```make
## Build App target for latest iOS Simulator (iPhone 16 Pro)
.PHONY: build-ios-app
build-ios-app:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme App -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' build | tee raw-build-ios-app.log | xcbeautify --preserve-unbeautified
```

- The `##` line is the description consumed by `make help`.
- The `.PHONY:` line declares the target as phony.
- The recipe lines must start with a tab.

## Multi-target descriptions

You can apply one description to multiple targets by listing them on the `.PHONY:` line. Each will appear in `make help` with the same description:

```make
## Format Swift, Markdown, JSON and YAML files using project tools
.PHONY: format format-swift format-json format-markdown format-yaml
```

Or, if you need different descriptions, declare each target in its own block with its own `##` line.

## Ensure your target appears in `make help`

`make help` parses the Makefile by looking for:

1. A description line starting with `##`
2. Optional detail lines starting with `#` right below the summary (rendered indented)
3. The following `.PHONY:` line to extract target names

That means:

- Put the `##` description immediately above the `.PHONY:` line.
- Avoid blank lines between the `##` line and `.PHONY:` if possible.
- Include all user-facing targets in `.PHONY:` lines.

You can verify your additions with:

```bash
make help
```

The help output dynamically aligns columns regardless of target name length.

## Style guidelines

- Prefer imperative verbs: build-, test-, format-, generate-, publish-.
- Keep descriptions short (one sentence).
- Use consistent simulator destination strings for iOS build/test targets.
- Log to `raw-*.log` and pipe through `xcbeautify` for Xcode output.
- When shell options improve reliability, include them (e.g., `set -o pipefail`).

## Common pitfalls

- Missing `##` line: the target won’t show up in `make help`.
- Missing `.PHONY:`: the target can be shadowed by a file of the same name.
- Spaces instead of a tab at the start of a recipe line cause make errors.
- Description too far above or separated from `.PHONY:`: the parser won’t match it.
- Duplicating the same target name in multiple `.PHONY:` lines: only the last one is used.

## Examples

Setup with dependencies broken into subtasks:

```make
## Setup the project by installing dependencies, pre-commit hooks, rbenv, and bundler. Also runs the generate command.
#
# This command sets up everything needed to develop the project.
.PHONY: setup
setup: install-dependencies install-pre-commit install-rbenv install-bundler generate

## Install the project dependencies using Homebrew.
.PHONY: install-dependencies
install-dependencies:
	brew bundle
	git submodule update --init --recursive
```

Generate tasks:

```make
## Generate licenses, settings version, and localization assets
.PHONY: generate
generate: generate-licenses generate-version-in-settings generate-localization

## Generate localized strings from xcstrings via script
.PHONY: generate-localization
generate-localization:
	./Scripts/generate-localization.sh
```

Testing:

```make
## Run unit tests for App scheme on latest iOS Simulator
.PHONY: test-ios-app
test-ios-app:
	set -o pipefail && NSUnbufferedIO=YES xcrun xcodebuild -project Flinky.xcodeproj -scheme App -destination 'platform=iOS Simulator,OS=latest,name=iPhone 16 Pro' test | tee raw-test-ios-app.log | xcbeautify --preserve-unbeautified
```

Multi-line example (details appear in `make help`, shown under the target without indentation):

```make
## Lint the migration directory
#
# Lints the migration directory to ensure that the migrations are valid.
# This is useful to catch any issues with the migrations before applying them.
.PHONY: migrate-lint
migrate-lint:
	atlas migrate lint \
		--dir="file://ent/migrate/migrations" \
		--latest=10 \
		--dev-url="docker://postgres/17/dev?search_path=public"
```

## Review checklist

- Did I add a `##` description above each new `.PHONY:` target?
- Does the description clearly explain the action?
- Do recipe lines start with tabs?
- Do the target and section names match the project’s conventions?
- Does `make help` display the new targets aligned and categorized?

If all answers are “yes”, your target is ready. 🎯
