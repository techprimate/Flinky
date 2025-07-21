#!/bin/bash

# Generate Localization.swift from Localizable.xcstrings
# This script performs a three-step process:
# 1. Convert xcstrings to JSON format
# 2. Convert JSON to strings format using SwiftGen
# 3. Convert strings to Swift enum

set -e

echo "🔄 Generating localization files..."

# Step 1: Convert xcstrings to JSON
echo "Step 1: Converting xcstrings to JSON..."
plutil -convert json Sources/Resources/Localizable.xcstrings -o Generated/temp.json

# Step 2: Convert JSON to strings
echo "Step 2: Converting JSON to strings..."
swiftgen json Generated/temp.json \
    --templatePath ./Templates/en-strings.stencil \
    --output Generated/generated-en.strings

# Step 3: Convert strings to Swift
echo "Step 3: Converting strings to Swift..."
swiftgen strings Generated/generated-en.strings \
    --templatePath ./Templates/l21strings.stencil \
    --output Sources/Utils/Localization.swift \
    --param enumName=L10n

# Clean up temporary files
rm Generated/temp.json

echo "✅ Localization generation complete!"
echo "📁 Generated: Sources/Utils/Localization.swift" 