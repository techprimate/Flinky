# SwiftGen Localization Setup

This project uses SwiftGen to automatically generate Swift code from `Localizable.xcstrings` files with a hierarchical organization strategy.

## Localization Strategy

### Hierarchical Organization Pattern

We use a **view-then-component** hierarchical structure with lowercase-dash-dot notation:

```
view-name.component.property.accessibility.type
shared.component.property.accessibility.type
```

### Key Patterns

**View-Specific Keys:**

- `link-detail.edit-link.label` → `L10n.LinkDetail.EditLink.label`
- `link-detail.edit-link.accessibility.label` → `L10n.LinkDetail.EditLink.Accessibility.label`
- `create-link.title` → `L10n.CreateLink.title`
- `link-lists.no-lists-title` → `L10n.LinkLists.noListsTitle`

**Shared Components:**

- `shared.button.cancel.label` → `L10n.Shared.Button.Cancel.label`
- `shared.error.network.description` → `L10n.Shared.Error.Network.description`
- `shared.form.title.accessibility.hint` → `L10n.Shared.Form.Title.Accessibility.hint`
- `shared.action.delete` → `L10n.Shared.Action.delete`

### Organization Categories

**View-Specific Patterns:**

- `app.*` - App-level strings
- `create-link.*` - Link creation interface
- `create-list.*` - List creation interface
- `link-detail.*` - Link detail view
- `link-lists.*` - Lists overview
- `link-list-detail.*` - Individual list view
- `search.*` - Search functionality

**Shared Component Patterns:**

- `shared.button.*` - Reusable buttons (Save, Cancel, Done, Delete, Edit)
- `shared.form.*` - Form fields (Title, Name, URL)
- `shared.error.*` - Error messages and recovery
- `shared.action.*` - Context menu/swipe actions (Edit, Delete, Pin, Share)
- `shared.item.*` - List/link item accessibility
- `shared.color-picker.*` - Color selection interface
- `shared.symbol-picker.*` - Symbol selection interface
- `shared.qr-code.*` - QR code generation and display
- `shared.toast.*` - Toast notifications
- `shared.delete-confirmation.*` - Deletion confirmation dialogs
- `shared.persistence.*` - Persistence error messages

## Overview

The localization system works in three steps:

1. **Convert xcstrings to JSON**: Using `plutil` to convert the Xcode strings catalog to JSON format
2. **Convert JSON to strings**: Using SwiftGen with custom template to create `.strings` file
3. **Convert strings to Swift**: Using SwiftGen to generate structured Swift enum

## Generated Structure

The generated `L10n` enum follows the dot notation in your string keys to create nested enums:

```swift
// View-specific examples:
L10n.LinkDetail.EditLink.label                    // "Edit"
L10n.LinkDetail.EditLink.Accessibility.label      // "Edit link"
L10n.CreateLink.title                              // "New Link"

// Shared component examples:
L10n.Shared.Button.Cancel.label                   // "Cancel"
L10n.Shared.Error.Network.description             // "Network Error: %@"
L10n.Shared.Form.Title.Accessibility.hint         // "Enter the link title"
L10n.Shared.Action.delete                         // "Delete"
```

## Usage Guidelines

### When to Use View-Specific vs Shared

**Use View-Specific Keys When:**

- The string is unique to a particular view or feature
- The context matters for translation
- The string has view-specific wording

**Use Shared Keys When:**

- The string appears in multiple views
- It's a common UI element (buttons, form fields, errors)
- It's a standard action or message

### Accessibility Pattern

For accessibility, always follow this pattern:

```
component.accessibility.label    // What the element is
component.accessibility.hint     // What it does or how to use it
```

Examples:

```swift
// Button with both label and hint
L10n.LinkDetail.EditLink.Accessibility.label  // "Edit link"
L10n.LinkDetail.EditLink.Accessibility.hint   // "Edit link properties"

// Form field with both label and hint  
L10n.Shared.Form.Title.Accessibility.label    // "Title field"
L10n.Shared.Form.Title.Accessibility.hint     // "Enter the link title"
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

## Development Workflow

When adding new features:

1. **Plan your keys**: Decide if strings are view-specific or shared
2. **Follow the hierarchy**: Use the established patterns
3. **Add to Xcode**: Add strings to `Sources/Resources/Localizable.xcstrings` using Xcode's String Catalog editor
4. **Generate**: Run `make generate-localization`
5. **Use in code**: Reference the generated constants: `L10n.YourCategory.yourKey`
6. **Build and test**: Use `make build-ios` to catch any localization issues

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
- **Consistency**: Enforced naming patterns prevent duplication
- **Automatic Updates**: No manual maintenance of localization constants
- **Accessibility First**: Built-in patterns for accessibility labels and hints
- **Shared Components**: Reusable strings reduce duplication and translation costs
