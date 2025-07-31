#!/bin/zsh
set -e

# Store current working directory
pushd $(pwd) > /dev/null
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

PROJECT_FILE="Flinky.xcodeproj/project.pbxproj"
SETTINGS_PLIST="Sources/Resources/Settings.bundle/Root.plist"

# Check if required commands are available
if ! command -v plutil >/dev/null 2>&1; then
    echo "❌ Error: plutil command not found"
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "❌ Error: jq command not found"
    echo "Please install jq: brew install jq"
    exit 1
fi

# Convert project file to JSON and use jq to extract versions from main app target
# This is the cleanest and most reliable approach
VERSION_INFO=$(plutil -convert json "$PROJECT_FILE" -o - | jq -r '.objects | to_entries[] | select(.value.buildSettings.PRODUCT_BUNDLE_IDENTIFIER == "com.techprimate.Flinky") | .value.buildSettings | "\(.MARKETING_VERSION):\(.CURRENT_PROJECT_VERSION)"' | head -1)

# Parse the extracted version info
MARKETING_VERSION=$(echo "$VERSION_INFO" | cut -d: -f1)
BUILD_VERSION=$(echo "$VERSION_INFO" | cut -d: -f2)

# Fallback to defaults if not found in project file
if [[ -z "$MARKETING_VERSION" ]]; then
    echo "Warning: MARKETING_VERSION not found in project.pbxproj, using fallback"
    MARKETING_VERSION="1.0.0"
fi

if [[ -z "$BUILD_VERSION" ]]; then
    echo "Warning: CURRENT_PROJECT_VERSION not found in project.pbxproj, using fallback"
    BUILD_VERSION="1"
fi

echo "Setting version in Settings.bundle: $MARKETING_VERSION ($BUILD_VERSION)"

# Update the Settings.bundle plist file
plutil -replace PreferenceSpecifiers.0.DefaultValue -string "$MARKETING_VERSION ($BUILD_VERSION)" "$SETTINGS_PLIST"

echo "✅ Version updated successfully"

# -- End Script --

# Return to original working directory
popd > /dev/null 
