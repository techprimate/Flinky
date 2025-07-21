# SwiftGen Localization Setup

This project uses SwiftGen to automatically generate Swift code from `Localizable.xcstrings` files.

## Overview

The localization system works in three steps:

1. **Convert xcstrings to JSON**: Using `plutil` to convert the Xcode strings catalog to JSON format
2. **Convert JSON to strings**: Using SwiftGen with custom template to create `.strings` file
3. **Convert strings to Swift**: Using SwiftGen to generate structured Swift enum

## Generated Structure

The generated `L10n` enum follows the dot notation in your string keys to create nested enums:

```swift
// String key: "app.title" -> L10n.App.title
// String key: "error.network" -> L10n.Error.network  
// String key: "accessibility.link_item" -> L10n.Accessibility.linkItem
// String key: "search.lists_and_links" -> L10n.Search.listsAndLinks
```

## Usage

### Manual Generation

Run the generation script manually:

```bash
./Scripts/generate-localization.sh
```

### Automatic Generation

The generation is included in the main `make generate` command:

```bash
make generate                    # Generates licenses, version info, AND localization
make generate-localization      # Generates only localization
```

## Files Structure

```
├── Scripts/
│   └── generate-localization.sh       # Main generation script
├── Templates/
│   ├── en-strings.stencil             # Template: xcstrings JSON → strings
│   └── l21strings.stencil             # Template: strings → Swift enum
├── Generated/                         # Temporary files (gitignored)
│   └── generated-en.strings           # Intermediate strings file
├── Sources/Resources/
│   └── Localizable.xcstrings          # Source strings catalog
└── Sources/Utils/
    └── Localization.swift             # Generated Swift code
```

## Adding New Strings

1. Add strings to `Sources/Resources/Localizable.xcstrings` using Xcode's String Catalog editor
2. Run `make generate-localization` or `./Scripts/generate-localization.sh`
3. Use the generated constants in your code: `L10n.YourCategory.yourKey`

## Template Details

### en-strings.stencil
- Converts xcstrings JSON format to traditional `.strings` format
- Filters out keys that don't make valid Swift identifiers
- Handles both regular strings and plural variations

### l21strings.stencil  
- Creates nested Swift enums based on dot notation in keys
- Generates functions for parameterized strings
- Includes fallback values for safety
- Follows SwiftGen best practices for localization

## Benefits

- **Type Safety**: Compile-time checking of localization keys
- **Auto-completion**: IDE support for all localized strings
- **Structured Organization**: Nested enums mirror your string key hierarchy
- **Automatic Updates**: No manual maintenance of localization constants
- **Consistency**: Single source of truth in Xcode's String Catalog 