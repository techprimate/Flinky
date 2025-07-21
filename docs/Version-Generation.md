# Version Generation Script

This document describes the `Scripts/generate-version-in-settings.sh` script that automatically updates the version information in the app's Settings.bundle.

## Purpose

The script extracts version information from the Xcode project file and updates the Settings.bundle to display the current app version in the iOS Settings app.

## How It Works

### Input Sources
- **Marketing Version**: `MARKETING_VERSION` from `project.pbxproj` (e.g., "1.0.0")
- **Build Version**: `CURRENT_PROJECT_VERSION` from `project.pbxproj` (e.g., "2")

### Output
- Updates `Sources/Resources/Settings.bundle/Root.plist`
- Sets `PreferenceSpecifiers.0.DefaultValue` to format: `"1.0.0 (2)"`

### Technical Implementation

The script uses a modern approach combining `plutil` and `jq` for reliable parsing:

```bash
# Convert Xcode project to JSON and extract versions using jq
VERSION_INFO=$(plutil -convert json "$PROJECT_FILE" -o - | \
  jq -r '.objects | to_entries[] | 
         select(.value.buildSettings.PRODUCT_BUNDLE_IDENTIFIER == "com.techprimate.Flinky") | 
         .value.buildSettings | 
         "\(.MARKETING_VERSION):\(.CURRENT_PROJECT_VERSION)"' | head -1)
```

## Usage

### Via Makefile (Recommended)
```bash
make generate-version-in-settings
```

### Direct Execution
```bash
./Scripts/generate-version-in-settings.sh
```

### As Part of Build Process
```bash
make generate  # Includes version generation along with other tasks
```

## Performance

| Method | Time | Description |
|--------|------|-------------|
| **Current Script** | ~0.06s | `plutil` + `jq` parsing |
| **Previous xcodebuild** | ~3.0s | Full Xcode project analysis |
| **Improvement** | **50x faster** | Direct file parsing |

## Evolution

### Version 1: xcodebuild (Slow)
```bash
# Original Makefile approach - SLOW
MARKETING_VERSION := $(shell xcodebuild -project Flinky.xcodeproj -showBuildSettings -configuration Release | grep MARKETING_VERSION | awk '{print $$3}')
```
- **Problem**: 2-3 seconds per version extraction
- **Cause**: Full Xcode project loading and build settings analysis

### Version 2: AWK Parsing (Fast but Complex)
```bash
# Complex AWK parsing of raw project.pbxproj
awk -v key="$key" '
  /buildSettings = {/ { in_build_settings = 1; block_content = "" }
  # ... 20+ lines of complex parsing logic
' "$PROJECT_FILE"
```
- **Problem**: Complex, hard to maintain, error-prone
- **Issue**: Had to manually parse Xcode's property list format

### Version 3: plutil + jq (Fast and Clean) ✅
```bash
# Clean JSON parsing with proper tools
plutil -convert json "$PROJECT_FILE" -o - | jq -r '...'
```
- **Benefits**: Reliable, maintainable, fast
- **Tools**: Standard macOS/Xcode developer tools

## Target Selection

The script specifically targets the **main app** build configurations by filtering on:
```
PRODUCT_BUNDLE_IDENTIFIER == "com.techprimate.Flinky"
```

This ensures it doesn't pick up versions from:
- Test targets (`com.techprimate.Flinky.Tests`)
- Extension targets
- Other embedded targets

## Error Handling

The script includes fallback values if version extraction fails:
- **Marketing Version Fallback**: `"1.0.0"`
- **Build Version Fallback**: `"1"`

Warnings are logged when fallbacks are used:
```
Warning: MARKETING_VERSION not found in project.pbxproj, using fallback
```

## Dependencies

### Required Tools
- `plutil` - Built into macOS, used for property list conversion
- `jq` - JSON processor, typically installed via Homebrew
- `cut` - Standard Unix text processing tool

### Installation (if missing)
```bash
# Install jq if not available
brew install jq
```

## Integration Points

### Makefile Targets
- `generate-version-in-settings` - Standalone version generation
- `generate` - Combined generation (includes licenses, localization, versions)

### Build Process
This script is typically run during:
1. **Development builds** - Manual `make generate`
2. **CI/CD pipelines** - Automated version sync
3. **Release preparation** - Ensure Settings.bundle is current

## Troubleshooting

### Common Issues

**Script shows fallback warnings**
- Check if `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` are set in Xcode project
- Verify bundle identifier matches `com.techprimate.Flinky`

**jq command not found**
```bash
brew install jq
```

**Wrong version extracted**
- Multiple targets might have same bundle identifier
- Script uses `head -1` to take first match - ensure main app config comes first

### Debugging

View raw version extraction:
```bash
plutil -convert json Flinky.xcodeproj/project.pbxproj -o - | \
  jq '.objects | to_entries[] | 
      select(.value.buildSettings.PRODUCT_BUNDLE_IDENTIFIER == "com.techprimate.Flinky") | 
      .value.buildSettings | 
      {MARKETING_VERSION, CURRENT_PROJECT_VERSION}'
```

## Future Improvements

- **Version validation**: Ensure semantic versioning format
- **Multiple bundle ID support**: Handle different app variants
- **Xcode Cloud integration**: Automatic version bumping
- **Git tag synchronization**: Sync with repository tags 