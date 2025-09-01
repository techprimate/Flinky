// swiftlint:disable all
// swift-format-ignore-file
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
    internal enum ShareExtension {
        internal enum DefaultList {
            /// My Links
            internal static let name = L10n.tr("share-extension.default-list.name", fallback: "My Links")
        }
        internal enum Error {
            /// Invalid URL shared
            internal static let invalidUrl = L10n.tr("share-extension.error.invalid-url", fallback: "Invalid URL shared")
            /// No URL found in shared content
            internal static let noUrl = L10n.tr("share-extension.error.no-url", fallback: "No URL found in shared content")
            /// Failed to save link
            internal static let saveFailed = L10n.tr("share-extension.error.save-failed", fallback: "Failed to save link")
        }
        internal enum ListPicker {
            /// List
            internal static let title = L10n.tr("share-extension.list-picker.title", fallback: "List")
            internal enum Accessibility {
                /// Choose which list to save the link to
                internal static let hint = L10n.tr("share-extension.list-picker.accessibility.hint", fallback: "Choose which list to save the link to")
                /// Select list
                internal static let label = L10n.tr("share-extension.list-picker.accessibility.label", fallback: "Select list")
            }
        }
        internal enum Name {
            /// Name
            internal static let title = L10n.tr("share-extension.name.title", fallback: "Name")
        }
        internal enum Nav {
            /// Add to Flinky
            internal static let title = L10n.tr("share-extension.nav.title", fallback: "Add to Flinky")
        }
        internal enum Placeholder {
            /// Add link to %@
            internal static func addToList(_ p1: Any) -> String {
                return L10n.tr("share-extension.placeholder.add-to-list", String(describing: p1), fallback: "Add link to %@")
            }
            /// Loading…
            internal static let loading = L10n.tr("share-extension.placeholder.loading", fallback: "Loading…")
        }
        internal enum Success {
            /// Link saved successfully
            internal static let linkSaved = L10n.tr("share-extension.success.link-saved", fallback: "Link saved successfully")
        }
        internal enum Url {
            internal enum Accessibility {
                /// Read-only URL to be saved
                internal static let hint = L10n.tr("share-extension.url.accessibility.hint", fallback: "Read-only URL to be saved")
                /// URL
                internal static let label = L10n.tr("share-extension.url.accessibility.label", fallback: "URL")
            }
        }
    }
    internal enum Shared {
        internal enum Button {
            /// Cancel
            internal static let cancel = L10n.tr("shared.button.cancel", fallback: "Cancel")
        }
    }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: nil)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }()
}
// swiftlint:enable convenience_type
// swiftlint:enable all
