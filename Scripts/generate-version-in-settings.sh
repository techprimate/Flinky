#!/bin/bash
set -e

# Store current working directory
pushd "$(pwd)" > /dev/null
# Change to script directory
cd "${0%/*}"

# -- Begin Script --

# Set up PATH for Homebrew tools (for consistency)
if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
else
    export PATH="/usr/local/bin:$PATH"
fi

# Change to project root directory (one level up from Scripts)
cd ..

PROJECT_SPEC="project.yml"
SETTINGS_PLIST="Targets/App/Sources/Resources/Settings.bundle/Root.plist"

# Check if required commands are available
if ! command -v plutil >/dev/null 2>&1; then
    echo "❌ Error: plutil command not found"
    exit 1
fi

if ! command -v yq >/dev/null 2>&1; then
    echo "❌ Error: yq command not found"
    echo "Please install yq: brew install yq"
    exit 1
fi

MARKETING_VERSION=$(yq -er '.settings.base.MARKETING_VERSION' "$PROJECT_SPEC")
BUILD_VERSION=$(yq -er '.settings.base.CURRENT_PROJECT_VERSION' "$PROJECT_SPEC")

echo "Setting version in Settings.bundle: $MARKETING_VERSION ($BUILD_VERSION)"

# Update the Settings.bundle plist file
plutil -replace PreferenceSpecifiers.0.DefaultValue -string "$MARKETING_VERSION ($BUILD_VERSION)" "$SETTINGS_PLIST"

echo "✅ Version updated successfully"

# -- End Script --

# Return to original working directory
popd > /dev/null 
