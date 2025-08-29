// swiftlint:disable all
// swift-format-ignore-file
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
    public enum Shared {
        public enum Button {
            /// Cancel
            public static let cancel = L10n.tr("shared.button.cancel", fallback: "Cancel")
        }
        public enum Color {
            /// Blue
            public static let blue = L10n.tr("shared.color.blue", fallback: "Blue")
            /// Brown
            public static let brown = L10n.tr("shared.color.brown", fallback: "Brown")
            /// Gray
            public static let gray = L10n.tr("shared.color.gray", fallback: "Gray")
            /// Green
            public static let green = L10n.tr("shared.color.green", fallback: "Green")
            /// Indigo
            public static let indigo = L10n.tr("shared.color.indigo", fallback: "Indigo")
            /// Light Blue
            public static let lightBlue = L10n.tr("shared.color.light-blue", fallback: "Light Blue")
            /// Mint
            public static let mint = L10n.tr("shared.color.mint", fallback: "Mint")
            /// Orange
            public static let orange = L10n.tr("shared.color.orange", fallback: "Orange")
            /// Pink
            public static let pink = L10n.tr("shared.color.pink", fallback: "Pink")
            /// Purple
            public static let purple = L10n.tr("shared.color.purple", fallback: "Purple")
            /// Red
            public static let red = L10n.tr("shared.color.red", fallback: "Red")
            /// Yellow
            public static let yellow = L10n.tr("shared.color.yellow", fallback: "Yellow")
        }
        public enum Error {
            /// OK
            public static let okButton = L10n.tr("shared.error.ok-button", fallback: "OK")
            /// Error
            public static let title = L10n.tr("shared.error.title", fallback: "Error")
            public enum DataCorruption {
                /// Data Error: %@
                public static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.data-corruption.description", String(describing: p1), fallback: "Data Error: %@")
                }
            }
            public enum FailedToOpenUrl {
                /// Failed to open URL: %@
                public static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.failed-to-open-url.description", String(describing: p1), fallback: "Failed to open URL: %@")
                }
                /// Make sure the URL you entered is valid, e.g. includes https:// at the beginning
                public static let recoverySuggestion = L10n.tr("shared.error.failed-to-open-url.recovery-suggestion", fallback: "Make sure the URL you entered is valid, e.g. includes https:// at the beginning")
            }
            public enum Network {
                /// Network Error: %@
                public static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.network.description", String(describing: p1), fallback: "Network Error: %@")
                }
            }
            public enum Nfc {
                /// NFC Error: %@
                public static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.nfc.description", String(describing: p1), fallback: "NFC Error: %@")
                }
            }
            public enum Persistence {
                /// Save Error: %@
                public static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.persistence.description", String(describing: p1), fallback: "Save Error: %@")
                }
            }
            public enum QrCode {
                /// QR Code Error: %@
                public static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.qr-code.description", String(describing: p1), fallback: "QR Code Error: %@")
                }
            }
            public enum Recovery {
                /// Please try restarting the app. If the problem persists, contact support.
                public static let dataCorruption = L10n.tr("shared.error.recovery.data-corruption", fallback: "Please try restarting the app. If the problem persists, contact support.")
                /// Please check your internet connection and try again.
                public static let network = L10n.tr("shared.error.recovery.network", fallback: "Please check your internet connection and try again.")
                /// Make sure NFC is enabled on both devices and the other device is ready to receive.
                public static let nfc = L10n.tr("shared.error.recovery.nfc", fallback: "Make sure NFC is enabled on both devices and the other device is ready to receive.")
                /// Failed to save your changes. Please try again.
                public static let persistence = L10n.tr("shared.error.recovery.persistence", fallback: "Failed to save your changes. Please try again.")
                /// Unable to generate QR code for this link.
                public static let qrCode = L10n.tr("shared.error.recovery.qr-code", fallback: "Unable to generate QR code for this link.")
                /// Please try again. If the problem persists, contact support.
                public static let unknown = L10n.tr("shared.error.recovery.unknown", fallback: "Please try again. If the problem persists, contact support.")
                /// Please check your input and try again.
                public static let validation = L10n.tr("shared.error.recovery.validation", fallback: "Please check your input and try again.")
            }
            public enum Unknown {
                /// Error: %@
                public static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.unknown.description", String(describing: p1), fallback: "Error: %@")
                }
            }
            public enum Validation {
                /// Validation Error: %@
                public static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.validation.description", String(describing: p1), fallback: "Validation Error: %@")
                }
            }
        }
        public enum Persistence {
            public enum Error {
                /// Failed to delete link
                public static let deleteLinkFailed = L10n.tr("shared.persistence.error.delete-link-failed", fallback: "Failed to delete link")
                /// Failed to delete list
                public static let deleteListFailed = L10n.tr("shared.persistence.error.delete-list-failed", fallback: "Failed to delete list")
                /// Failed to delete links
                public static let deleteMultipleLinksFailed = L10n.tr("shared.persistence.error.delete-multiple-links-failed", fallback: "Failed to delete links")
                /// Failed to pin list
                public static let pinListFailed = L10n.tr("shared.persistence.error.pin-list-failed", fallback: "Failed to pin list")
                /// Please try again. If the problem persists, restart the app.
                public static let recoverySuggestion = L10n.tr("shared.persistence.error.recovery-suggestion", fallback: "Please try again. If the problem persists, restart the app.")
                /// Failed to save deletion changes
                public static let saveChangesAfterDeletionFailed = L10n.tr("shared.persistence.error.save-changes-after-deletion-failed", fallback: "Failed to save deletion changes")
                /// Failed to save link changes
                public static let saveLinkChangesFailed = L10n.tr("shared.persistence.error.save-link-changes-failed", fallback: "Failed to save link changes")
                /// Failed to save link
                public static let saveLinkFailed = L10n.tr("shared.persistence.error.save-link-failed", fallback: "Failed to save link")
                /// Failed to save list changes
                public static let saveListChangesFailed = L10n.tr("shared.persistence.error.save-list-changes-failed", fallback: "Failed to save list changes")
                /// Failed to save list
                public static let saveListFailed = L10n.tr("shared.persistence.error.save-list-failed", fallback: "Failed to save list")
                /// Failed to unpin list
                public static let unpinListFailed = L10n.tr("shared.persistence.error.unpin-list-failed", fallback: "Failed to unpin list")
            }
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
