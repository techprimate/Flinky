#!/bin/bash
set -e

# Store current working directory
pushd "$(pwd)" > /dev/null
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
if [[ -n "${LICENSE_PLIST_GITHUB_TOKEN:-}" ]]; then
    echo "🔑 Using GitHub token for license downloads..."
else
    echo "⚠️  No GitHub token available, licenses may be incomplete..."
fi

# Run license-plist but don't fail the script if it has network issues
license-plist "$@" || {
    echo "⚠️  license-plist completed with warnings (likely network issues)"
}

echo "✅ License generation complete!"
echo "📁 Generated files in: Targets/App/Sources/Resources/Settings.bundle/"
echo "   • Licenses.plist"
echo "   • Licenses.latest_result.txt"
echo "   • Licenses/ directory with individual license files"

# -- End Script --

# Return to original working directory
popd > /dev/null 
