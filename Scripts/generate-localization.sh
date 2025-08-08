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

# Ensure output directories exist
mkdir -p Targets/App/Sources/Generated
mkdir -p Targets/FlinkyCore/Sources/Generated
mkdir -p Targets/ShareExtension/Sources/Generated

# Function to generate localization for a target
generate_localization() {
    local target_name="$1"
    local xcstrings_path="$2" 
    local output_path="$3"
    local public_access_param="$4" # true|false (empty for default internal)

    local temp_json="Generated/temp-${target_name}-$$.json"
    local temp_strings="Generated/generated-${target_name}-en.strings"
    
    echo "📱 Generating localization for ${target_name}..."
    
    # Step 1: Convert xcstrings to JSON
    echo "  Step 1: Converting ${target_name} xcstrings to JSON..."
    plutil -convert json "${xcstrings_path}" -o "${temp_json}"
    
    # Step 2: Convert JSON to strings
    echo "  Step 2: Converting ${target_name} JSON to strings..."
    swiftgen json "${temp_json}" \
        --templatePath ./Templates/en-strings.stencil \
        --output "${temp_strings}"
    
    # Step 3: Convert strings to Swift
    echo "  Step 3: Converting ${target_name} strings to Swift..."
    if [[ "${public_access_param}" == "true" ]]; then
        swiftgen strings "${temp_strings}" \
            --templatePath ./Templates/l21strings.stencil \
            --output "${output_path}" \
            --param enumName=L10n \
            --param publicAccess=true
    else
        swiftgen strings "${temp_strings}" \
            --templatePath ./Templates/l21strings.stencil \
            --output "${output_path}" \
            --param enumName=L10n
    fi
    
    # Clean up temporary files
    rm -f "${temp_json}" "${temp_strings}"
    
    echo "  ✅ Generated: ${output_path}"
}

# Generate localization for App target (internal access)
generate_localization "App" \
    "Targets/App/Sources/Resources/Localizable.xcstrings" \
    "Targets/App/Sources/Generated/L10n.swift" \
    "false"

# Generate localization for FlinkyCore target (public access so other targets can import)
generate_localization "FlinkyCore" \
    "Targets/FlinkyCore/Sources/Resources/Localizable.xcstrings" \
    "Targets/FlinkyCore/Sources/Generated/L10n.swift" \
    "true"

# Generate localization for ShareExtension target (internal access)
generate_localization "ShareExtension" \
    "Targets/ShareExtension/Sources/Resources/Localizable.xcstrings" \
    "Targets/ShareExtension/Sources/Generated/L10n.swift" \
    "false"

echo "✅ Localization generation complete!"
echo "📁 Generated: Targets/App/Sources/Generated/L10n.swift"
echo "📁 Generated: Targets/FlinkyCore/Sources/Generated/L10n.swift"
echo "📁 Generated: Targets/ShareExtension/Sources/Generated/L10n.swift"

# -- End Script --

# Return to original working directory
popd > /dev/null 
