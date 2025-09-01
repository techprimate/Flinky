#!/bin/bash
set -e

# Store current working directory
pushd "$(pwd)" > /dev/null
# Change to script directory
cd "${0%/*}"

# -- Begin Script --

echo "🔄 Generating Xcode project..."

# Set up PATH for Homebrew tools
if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
else
    export PATH="/usr/local/bin:$PATH"
fi

# Change to project root
cd ..

# Check if xcodegen is available
if ! command -v xcodegen &> /dev/null; then
    echo "❌ Error: xcodegen is not installed or not in PATH"
    echo "Please install xcodegen using: brew install xcodegen"
    exit 1
fi

# Generate the Xcode project
echo "📝 Running xcodegen..."
xcodegen generate

echo "✅ Xcode project generated successfully"

# -- End Script --

# Return to original working directory
popd > /dev/null 
