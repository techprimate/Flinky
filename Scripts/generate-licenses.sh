#!/bin/zsh
set -e

# Store current working directory
pushd $(pwd) > /dev/null
# Change to script directory
cd "${0%/*}"

# -- Begin Script --

echo "🔄 Generating license files..."

# Set up PATH for Homebrew tools
if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
else
    export PATH="/usr/local/bin:$PATH"
fi

# Change to project root directory (one level up from Scripts)
cd ..

# Check if license-plist is available
if ! command -v license-plist >/dev/null 2>&1; then
    echo "❌ Error: license-plist command not found"
    echo "Please install license-plist: brew install license-plist"
    exit 1
fi

echo "📄 Running license-plist to generate dependency licenses..."

# Generate licenses using license-plist
license-plist \
    --output-path Sources/Resources/Settings.bundle \
    --prefix Licenses \
    --add-version-numbers \
    --suppress-opening-directory \
    --fail-if-missing-license

echo "✅ License generation complete!"
echo "📁 Generated files in: Sources/Resources/Settings.bundle/"
echo "   • Licenses.plist"
echo "   • Licenses.latest_result.txt"
echo "   • Licenses/ directory with individual license files"

# -- End Script --

# Return to original working directory
popd > /dev/null 