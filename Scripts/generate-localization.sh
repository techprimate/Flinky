#!/bin/bash
set -e

# Store current working directory
pushd "$(pwd)" > /dev/null
# Change to script directory
cd "${0%/*}"

# -- Begin Script --

echo "🔄 Generating localization files..."

# Set up PATH for Homebrew tools
if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
else
    export PATH="/usr/local/bin:$PATH"
fi

# Verify the utilities are available
if ! command -v plutil >/dev/null 2>&1; then
    echo "❌ Error: plutil command not found"
    exit 1
fi
if ! command -v swiftgen >/dev/null 2>&1; then
    echo "❌ Error: swiftgen command not found"
    exit 1
fi

# Change to project root directory (one level up from Scripts)
cd ..

# Create a unique temporary file to avoid race conditions
TEMP_JSON="Generated/temp_$$.json"

# Step 1: Convert xcstrings to JSON
echo "Step 1: Converting xcstrings to JSON..."
plutil -convert json Sources/Resources/Localizable.xcstrings -o "$TEMP_JSON"

# Step 2: Convert JSON to strings
echo "Step 2: Converting JSON to strings..."
swiftgen json "$TEMP_JSON" \
    --templatePath ./Templates/en-strings.stencil \
    --output Generated/generated-en.strings

# Step 3: Convert strings to Swift
echo "Step 3: Converting strings to Swift..."
swiftgen strings Generated/generated-en.strings \
    --templatePath ./Templates/l21strings.stencil \
    --output Sources/Utils/Localization.swift \
    --param enumName=L10n

# Clean up temporary files
echo "Cleaning up temporary files..."
if [ -f "$TEMP_JSON" ]; then
    rm "$TEMP_JSON"
fi

echo "✅ Localization generation complete!"
echo "📁 Generated: Sources/Utils/Localization.swift"

# -- End Script --

# Return to original working directory
popd > /dev/null 
