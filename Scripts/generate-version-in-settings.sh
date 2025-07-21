#!/bin/bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

PROJECT_FILE="$PROJECT_ROOT/Flinky.xcodeproj/project.pbxproj"
SETTINGS_PLIST="$PROJECT_ROOT/Sources/Resources/Settings.bundle/Root.plist"

# Function to extract version from project.pbxproj
extract_version() {
    local key="$1"
    # Look for the key in the project file and extract its value
    grep -m 1 "$key" "$PROJECT_FILE" | sed -E 's/.*'"$key"' = ([^;]+);.*/\1/' | tr -d '"'
}

# Extract versions directly from project.pbxproj (much faster than xcodebuild)
MARKETING_VERSION=$(extract_version "MARKETING_VERSION")
BUILD_VERSION=$(extract_version "CURRENT_PROJECT_VERSION")

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