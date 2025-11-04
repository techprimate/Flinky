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

# Post-process sentry-cocoa license information
SENTRY_SUBMODULE_PATH="Libraries/getsentry/sentry-cocoa"
LICENSES_PLIST="Targets/App/Sources/Resources/Settings.bundle/Licenses.plist"
SENTRY_LICENSE_PLIST="Targets/App/Sources/Resources/Settings.bundle/Licenses/sentry-cocoa.plist"

if [[ -d "$SENTRY_SUBMODULE_PATH" && -f "$LICENSES_PLIST" ]]; then
    echo "🔧 Post-processing sentry-cocoa license information..."
    
    # Get the pinned commit hash of the sentry-cocoa submodule from the parent repository
    SENTRY_COMMIT=$(git ls-tree HEAD "$SENTRY_SUBMODULE_PATH" | awk '{print substr($3,1,7)}' 2>/dev/null || echo "unknown")
    
    if [[ "$SENTRY_COMMIT" != "unknown" ]]; then
        # Find the index of the sentry-cocoa entry in Licenses.plist
        SENTRY_INDEX=$(/usr/libexec/PlistBuddy -c "Print :PreferenceSpecifiers" "$LICENSES_PLIST" 2>/dev/null | grep -n "Licenses/sentry-cocoa" | cut -d: -f1)
        
        if [[ -n "$SENTRY_INDEX" ]]; then
            # PlistBuddy uses 0-based indexing, but our grep result is 1-based, and we need to account for the Dict structure
            # The grep finds the line number, but we need the array index. Let's use a different approach:
            
            # Count the number of entries to find the right index
            ENTRY_COUNT=$(/usr/libexec/PlistBuddy -c "Print :PreferenceSpecifiers" "$LICENSES_PLIST" 2>/dev/null | grep -c "Dict {")
            
            # Find the correct index by checking each entry
            for ((i=1; i<ENTRY_COUNT; i++)); do
                FILE_VALUE=$(/usr/libexec/PlistBuddy -c "Print :PreferenceSpecifiers:$i:File" "$LICENSES_PLIST" 2>/dev/null || echo "")
                if [[ "$FILE_VALUE" == "Licenses/sentry-cocoa" ]]; then
                    if /usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:$i:Title 'Sentry ($SENTRY_COMMIT)'" "$LICENSES_PLIST" 2>/dev/null; then
                        echo "✅ Updated sentry-cocoa title to: Sentry ($SENTRY_COMMIT)"
                    else
                        echo "⚠️  Could not update sentry-cocoa title in Licenses.plist"
                    fi
                    break
                fi
            done
        else
            echo "⚠️  Could not find sentry-cocoa entry in Licenses.plist"
        fi
        
        # Fix the license type in sentry-cocoa.plist from "unknown" to "MIT"
        if [[ -f "$SENTRY_LICENSE_PLIST" ]]; then
            if /usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:0:License MIT" "$SENTRY_LICENSE_PLIST" 2>/dev/null; then
                echo "✅ Fixed sentry-cocoa license type to: MIT"
            else
                echo "⚠️  Could not update license type in sentry-cocoa.plist"
            fi
        fi
    else
        echo "⚠️  Could not determine sentry-cocoa commit hash"
    fi
fi

echo "✅ License generation complete!"
echo "📁 Generated files in: Targets/App/Sources/Resources/Settings.bundle/"
echo "   • Licenses.plist"
echo "   • Licenses.latest_result.txt"
echo "   • Licenses/ directory with individual license files"

# -- End Script --

# Return to original working directory
popd > /dev/null 
