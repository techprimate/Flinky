# Agent Instructions

## Build System

Use **Makefile** for all build, test, and generation tasks:

| Command                      | Description                          |
| ---------------------------- | ------------------------------------ |
| `make build`                 | Build all iOS targets                |
| `make build-ios-app`         | Build App target                     |
| `make build-ios-core`        | Build FlinkyCore target              |
| `make test-ios-app`          | Run unit tests                       |
| `make generate-localization` | Regenerate L10n.swift from xcstrings |
| `make generate`              | Run all generators                   |

## Localization

1. Add strings to `Targets/*/Sources/Resources/Localizable.xcstrings`
2. Run `make generate-localization` to regenerate `L10n.swift`
3. Use generated `L10n.*` accessors in code

## New Model Properties (SwiftData)

When adding properties to `@Model` classes:

- Add property with optional type or default value
- Update both initializers (main + convenience)
- Default parameter value in initializer signature

## New Enums (FlinkyCore)

Follow `ListColor.swift` pattern:

```swift
public enum Example: String, CaseIterable, Identifiable, Codable {
    case option1
    case option2

    public var id: RawValue { rawValue }
    public static var `default`: Self { .option1 }
    public var name: String { /* use L10n.* */ }
}
```

## New Test Files

Test files must be added to Xcode project manually. Create in:

- `Targets/FlinkyCoreTests/Sources/Models/` for model tests

## Commit Attribution

AI commits MUST NOT include any for of LLM attribution:

```
Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

## PR Creation

Use `/create-pr` skill after committing changes.
