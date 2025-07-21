#!/bin/bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

PROJECT_FILE="$PROJECT_ROOT/Flinky.xcodeproj/project.pbxproj"
SETTINGS_PLIST="$PROJECT_ROOT/Sources/Resources/Settings.bundle/Root.plist"

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