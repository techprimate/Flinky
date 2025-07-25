// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum L10n {
    enum App {
        /// Flinky
        static let title = L10n.tr("app.title", fallback: "Flinky")
    }

    enum CreateLink {
        /// New Link
        static let title = L10n.tr("create-link.title", fallback: "New Link")
        /// Please enter a valid URL
        static let urlValidation = L10n.tr("create-link.url-validation", fallback: "Please enter a valid URL")
    }

    enum CreateLinkListPicker {
        /// Choose List
        static let title = L10n.tr("create-link-list-picker.title", fallback: "Choose List")
        enum Item {
            enum Accessibility {
                /// Select this list for your link
                static let hint = L10n.tr("create-link-list-picker.item.accessibility.hint", fallback: "Select this list for your link")
                /// %@
                static func label(_ p1: Any) -> String {
                    return L10n.tr("create-link-list-picker.item.accessibility.label", String(describing: p1), fallback: "%@")
                }
            }
        }
    }

    enum CreateList {
        /// New List
        static let title = L10n.tr("create-list.title", fallback: "New List")
    }

    enum LinkDetail {
        enum EditLink {
            /// Edit
            static let label = L10n.tr("link-detail.edit-link.label", fallback: "Edit")
            enum Accessibility {
                /// Edit link properties
                static let hint = L10n.tr("link-detail.edit-link.accessibility.hint", fallback: "Edit link properties")
                /// Edit link
                static let label = L10n.tr("link-detail.edit-link.accessibility.label", fallback: "Edit link")
            }
        }

        enum MoreMenu {
            /// More
            static let label = L10n.tr("link-detail.more-menu.label", fallback: "More")
            enum Accessibility {
                /// Find additional actions for this link
                static let hint = L10n.tr("link-detail.more-menu.accessibility.hint", fallback: "Find additional actions for this link")
                /// More Actions
                static let label = L10n.tr("link-detail.more-menu.accessibility.label", fallback: "More Actions")
            }
        }

        enum OpenInSafari {
            /// Open in Safari
            static let label = L10n.tr("link-detail.open-in-safari.label", fallback: "Open in Safari")
        }

        enum ShareLink {
            /// Share Link
            static let label = L10n.tr("link-detail.share-link.label", fallback: "Share Link")
            enum Accessibility {
                /// Share this link with others
                static let hint = L10n.tr("link-detail.share-link.accessibility.hint", fallback: "Share this link with others")
                /// Share %@
                static func label(_ p1: Any) -> String {
                    return L10n.tr("link-detail.share-link.accessibility.label", String(describing: p1), fallback: "Share %@")
                }
            }
        }

        enum ShareViaNfc {
            /// Share via NFC
            static let label = L10n.tr("link-detail.share-via-nfc.label", fallback: "Share via NFC")
            enum Accessibility {
                /// Share this link using NFC
                static let hint = L10n.tr("link-detail.share-via-nfc.accessibility.hint", fallback: "Share this link using NFC")
                /// Share %@ via NFC
                static func label(_ p1: Any) -> String {
                    return L10n.tr("link-detail.share-via-nfc.accessibility.label", String(describing: p1), fallback: "Share %@ via NFC")
                }
            }
        }
    }

    enum LinkDetailNfcSharing {
        /// Share via NFC
        static let title = L10n.tr("link-detail-nfc-sharing.title", fallback: "Share via NFC")
        enum Device {
            /// Other Device
            static let other = L10n.tr("link-detail-nfc-sharing.device.other", fallback: "Other Device")
            /// Your Device
            static let yours = L10n.tr("link-detail-nfc-sharing.device.yours", fallback: "Your Device")
        }

        enum Error {
            /// Failed to share with device
            static let message = L10n.tr("link-detail-nfc-sharing.error.message", fallback: "Failed to share with device")
            /// Error
            static let title = L10n.tr("link-detail-nfc-sharing.error.title", fallback: "Error")
        }

        enum Instructions {
            /// Make sure the other device has NFC enabled and is ready to receive links
            static let message = L10n.tr("link-detail-nfc-sharing.instructions.message", fallback: "Make sure the other device has NFC enabled and is ready to receive links")
            /// Instructions:
            static let title = L10n.tr("link-detail-nfc-sharing.instructions.title", fallback: "Instructions:")
        }

        enum LinkPreview {
            /// Link to share:
            static let title = L10n.tr("link-detail-nfc-sharing.link-preview.title", fallback: "Link to share:")
        }

        enum NfcSession {
            /// Bring your device close to another NFC-capable device to share the link
            static let alertMessage = L10n.tr("link-detail-nfc-sharing.nfc-session.alert-message", fallback: "Bring your device close to another NFC-capable device to share the link")
        }

        enum Ready {
            /// Hold your device near another NFC-capable device to share the link
            static let message = L10n.tr("link-detail-nfc-sharing.ready.message", fallback: "Hold your device near another NFC-capable device to share the link")
            /// Ready to Share
            static let title = L10n.tr("link-detail-nfc-sharing.ready.title", fallback: "Ready to Share")
        }

        enum Retry {
            /// Try Again
            static let label = L10n.tr("link-detail-nfc-sharing.retry.label", fallback: "Try Again")
        }

        enum Scanning {
            /// Bring your device close to another NFC-capable device
            static let message = L10n.tr("link-detail-nfc-sharing.scanning.message", fallback: "Bring your device close to another NFC-capable device")
            /// Searching for nearby devices...
            static let progress = L10n.tr("link-detail-nfc-sharing.scanning.progress", fallback: "Searching for nearby devices...")
            /// Scanning...
            static let title = L10n.tr("link-detail-nfc-sharing.scanning.title", fallback: "Scanning...")
        }

        enum Success {
            /// Link successfully shared with device
            static let message = L10n.tr("link-detail-nfc-sharing.success.message", fallback: "Link successfully shared with device")
            /// Success!
            static let title = L10n.tr("link-detail-nfc-sharing.success.title", fallback: "Success!")
        }

        enum Troubleshooting {
            /// • Ensure both devices have NFC enabled
            /// • Make sure the other device is ready to receive
            /// • Try moving devices closer together
            static let message = L10n.tr("link-detail-nfc-sharing.troubleshooting.message", fallback: "• Ensure both devices have NFC enabled\n• Make sure the other device is ready to receive\n• Try moving devices closer together")
            /// Troubleshooting:
            static let title = L10n.tr("link-detail-nfc-sharing.troubleshooting.title", fallback: "Troubleshooting:")
        }
    }

    enum LinkListDetail {
        /// New Link
        static let newLink = L10n.tr("link-list-detail.new-link", fallback: "New Link")
        /// Add a new link to get started
        static let noLinksDescription = L10n.tr("link-list-detail.no-links-description", fallback: "Add a new link to get started")
        /// No links available
        static let noLinksTitle = L10n.tr("link-list-detail.no-links-title", fallback: "No links available")
        enum MoreMenu {
            /// More
            static let label = L10n.tr("link-list-detail.more-menu.label", fallback: "More")
            enum Accessibility {
                /// Show additional actions for this list
                static let hint = L10n.tr("link-list-detail.more-menu.accessibility.hint", fallback: "Show additional actions for this list")
                /// More Actions
                static let label = L10n.tr("link-list-detail.more-menu.accessibility.label", fallback: "More Actions")
            }

            enum DeleteList {
                /// Delete List
                static let label = L10n.tr("link-list-detail.more-menu.delete-list.label", fallback: "Delete List")
                enum Accessibility {
                    /// Delete this list and all its links
                    static let hint = L10n.tr("link-list-detail.more-menu.delete-list.accessibility.hint", fallback: "Delete this list and all its links")
                    /// Delete List
                    static let label = L10n.tr("link-list-detail.more-menu.delete-list.accessibility.label", fallback: "Delete List")
                }
            }

            enum EditList {
                /// Edit List
                static let label = L10n.tr("link-list-detail.more-menu.edit-list.label", fallback: "Edit List")
                enum Accessibility {
                    /// Edit list properties
                    static let hint = L10n.tr("link-list-detail.more-menu.edit-list.accessibility.hint", fallback: "Edit list properties")
                    /// Edit List
                    static let label = L10n.tr("link-list-detail.more-menu.edit-list.accessibility.label", fallback: "Edit List")
                }
            }
        }
    }

    enum LinkLists {
        /// My Lists
        static let myListsSection = L10n.tr("link-lists.my-lists-section", fallback: "My Lists")
        /// Create a new list to get started
        static let noListsDescription = L10n.tr("link-lists.no-lists-description", fallback: "Create a new list to get started")
        /// No lists available
        static let noListsTitle = L10n.tr("link-lists.no-lists-title", fallback: "No lists available")
        /// Pinned
        static let pinnedSection = L10n.tr("link-lists.pinned-section", fallback: "Pinned")
        enum CreateLink {
            /// Create Link
            static let title = L10n.tr("link-lists.create-link.title", fallback: "Create Link")
            enum Accessibility {
                /// Create a new link
                static let hint = L10n.tr("link-lists.create-link.accessibility.hint", fallback: "Create a new link")
                /// Create Link
                static let label = L10n.tr("link-lists.create-link.accessibility.label", fallback: "Create Link")
            }
        }

        enum CreateList {
            /// Create List
            static let title = L10n.tr("link-lists.create-list.title", fallback: "Create List")
            enum Accessibility {
                /// Create a new list
                static let hint = L10n.tr("link-lists.create-list.accessibility.hint", fallback: "Create a new list")
                /// Create List
                static let label = L10n.tr("link-lists.create-list.accessibility.label", fallback: "Create List")
            }
        }
    }

    enum Search {
        /// Search links
        static let links = L10n.tr("search.links", fallback: "Search links")
        /// Search lists and links
        static let listsAndLinks = L10n.tr("search.lists-and-links", fallback: "Search lists and links")
    }

    enum Shared {
        enum Action {
            /// Delete
            static let delete = L10n.tr("shared.action.delete", fallback: "Delete")
            /// Edit
            static let edit = L10n.tr("shared.action.edit", fallback: "Edit")
            /// Pin
            static let pin = L10n.tr("shared.action.pin", fallback: "Pin")
            /// Share Link
            static let share = L10n.tr("shared.action.share", fallback: "Share Link")
            /// Unpin
            static let unpin = L10n.tr("shared.action.unpin", fallback: "Unpin")
            enum Share {
                enum Accessibility {
                    /// Share this link with others
                    static let hint = L10n.tr("shared.action.share.accessibility.hint", fallback: "Share this link with others")
                }
            }
        }

        enum Button {
            enum Cancel {
                /// Cancel
                static let label = L10n.tr("shared.button.cancel.label", fallback: "Cancel")
                enum Accessibility {
                    /// Discard changes
                    static let hint = L10n.tr("shared.button.cancel.accessibility.hint", fallback: "Discard changes")
                    /// Cancel
                    static let label = L10n.tr("shared.button.cancel.accessibility.label", fallback: "Cancel")
                }
            }

            enum Delete {
                /// Delete
                static let label = L10n.tr("shared.button.delete.label", fallback: "Delete")
                enum Accessibility {
                    /// Delete
                    static let label = L10n.tr("shared.button.delete.accessibility.label", fallback: "Delete")
                }
            }

            enum Done {
                /// Done
                static let label = L10n.tr("shared.button.done.label", fallback: "Done")
                enum Accessibility {
                    /// Done
                    static let label = L10n.tr("shared.button.done.accessibility.label", fallback: "Done")
                }
            }

            enum Edit {
                /// Edit
                static let label = L10n.tr("shared.button.edit.label", fallback: "Edit")
                enum Accessibility {
                    /// Edit
                    static let label = L10n.tr("shared.button.edit.accessibility.label", fallback: "Edit")
                }
            }

            enum NewLink {
                enum Accessibility {
                    /// Create a new link in this list
                    static let hint = L10n.tr("shared.button.new-link.accessibility.hint", fallback: "Create a new link in this list")
                    /// Add new link
                    static let label = L10n.tr("shared.button.new-link.accessibility.label", fallback: "Add new link")
                }
            }

            enum NewList {
                enum Accessibility {
                    /// Create new list
                    static let label = L10n.tr("shared.button.new-list.accessibility.label", fallback: "Create new list")
                }
            }

            enum Save {
                /// Save
                static let label = L10n.tr("shared.button.save.label", fallback: "Save")
                enum Accessibility {
                    /// Save changes
                    static let hint = L10n.tr("shared.button.save.accessibility.hint", fallback: "Save changes")
                    /// Save
                    static let label = L10n.tr("shared.button.save.accessibility.label", fallback: "Save")
                }
            }
        }

        enum Color {
            /// Blue
            static let blue = L10n.tr("shared.color.blue", fallback: "Blue")
            /// Brown
            static let brown = L10n.tr("shared.color.brown", fallback: "Brown")
            /// Gray
            static let gray = L10n.tr("shared.color.gray", fallback: "Gray")
            /// Green
            static let green = L10n.tr("shared.color.green", fallback: "Green")
            /// Indigo
            static let indigo = L10n.tr("shared.color.indigo", fallback: "Indigo")
            /// Light Blue
            static let lightBlue = L10n.tr("shared.color.light-blue", fallback: "Light Blue")
            /// Mint
            static let mint = L10n.tr("shared.color.mint", fallback: "Mint")
            /// Orange
            static let orange = L10n.tr("shared.color.orange", fallback: "Orange")
            /// Pink
            static let pink = L10n.tr("shared.color.pink", fallback: "Pink")
            /// Purple
            static let purple = L10n.tr("shared.color.purple", fallback: "Purple")
            /// Red
            static let red = L10n.tr("shared.color.red", fallback: "Red")
            /// Yellow
            static let yellow = L10n.tr("shared.color.yellow", fallback: "Yellow")
        }

        enum ColorPicker {
            enum Accessibility {
                /// Color picker. Current selection: %@
                static func hint(_ p1: Any) -> String {
                    return L10n.tr("shared.color-picker.accessibility.hint", String(describing: p1), fallback: "Color picker. Current selection: %@")
                }
            }

            enum Option {
                enum Accessibility {
                    /// %@ color option
                    static func label(_ p1: Any) -> String {
                        return L10n.tr("shared.color-picker.option.accessibility.label", String(describing: p1), fallback: "%@ color option")
                    }
                }
            }

            enum Section {
                /// Color
                static let title = L10n.tr("shared.color-picker.section.title", fallback: "Color")
            }
        }

        enum DeleteConfirmation {
            enum Link {
                /// Delete link "%@"?
                static func alertTitle(_ p1: Any) -> String {
                    return L10n.tr("shared.delete-confirmation.link.alert-title", String(describing: p1), fallback: "Delete link \"%@\"?")
                }
            }

            enum Links {
                /// Delete selected links?
                static let alertTitle = L10n.tr("shared.delete-confirmation.links.alert-title", fallback: "Delete selected links?")
                /// This will delete the links "%@".
                /// This can not be undone.
                static func warningMessage(_ p1: Any) -> String {
                    return L10n.tr("shared.delete-confirmation.links.warning-message", String(describing: p1), fallback: "This will delete the links \"%@\".\nThis can not be undone.")
                }
            }

            enum List {
                /// Delete list "%@"?
                static func alertTitle(_ p1: Any) -> String {
                    return L10n.tr("shared.delete-confirmation.list.alert-title", String(describing: p1), fallback: "Delete list \"%@\"?")
                }
            }

            enum Lists {
                /// Delete selected lists?
                static let alertTitle = L10n.tr("shared.delete-confirmation.lists.alert-title", fallback: "Delete selected lists?")
                /// This will delete the lists "%@" and their links.
                /// This can not be undone.
                static func warningMessage(_ p1: Any) -> String {
                    return L10n.tr("shared.delete-confirmation.lists.warning-message", String(describing: p1), fallback: "This will delete the lists \"%@\" and their links.\nThis can not be undone.")
                }
            }

            enum Warning {
                /// This can not be undone.
                static let cannotUndo = L10n.tr("shared.delete-confirmation.warning.cannot-undo", fallback: "This can not be undone.")
            }
        }

        enum EmojiPicker {
            enum Accessibility {
                /// Select custom emoji
                static let hint = L10n.tr("shared.emoji-picker.accessibility.hint", fallback: "Select custom emoji")
            }
        }

        enum Error {
            /// OK
            static let okButton = L10n.tr("shared.error.ok-button", fallback: "OK")
            /// Error
            static let title = L10n.tr("shared.error.title", fallback: "Error")
            enum DataCorruption {
                /// Data Error: %@
                static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.data-corruption.description", String(describing: p1), fallback: "Data Error: %@")
                }
            }

            enum FailedToOpenUrl {
                /// Failed to open URL: %@
                static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.failed-to-open-url.description", String(describing: p1), fallback: "Failed to open URL: %@")
                }

                /// Make sure the URL you entered is valid, e.g. includes https:// at the beginning
                static let recoverySuggestion = L10n.tr("shared.error.failed-to-open-url.recovery-suggestion", fallback: "Make sure the URL you entered is valid, e.g. includes https:// at the beginning")
            }

            enum Network {
                /// Network Error: %@
                static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.network.description", String(describing: p1), fallback: "Network Error: %@")
                }
            }

            enum Nfc {
                /// NFC Error: %@
                static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.nfc.description", String(describing: p1), fallback: "NFC Error: %@")
                }
            }

            enum Persistence {
                /// Save Error: %@
                static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.persistence.description", String(describing: p1), fallback: "Save Error: %@")
                }
            }

            enum QrCode {
                /// QR Code Error: %@
                static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.qr-code.description", String(describing: p1), fallback: "QR Code Error: %@")
                }
            }

            enum Recovery {
                /// Please try restarting the app. If the problem persists, contact support.
                static let dataCorruption = L10n.tr("shared.error.recovery.data-corruption", fallback: "Please try restarting the app. If the problem persists, contact support.")
                /// Please check your internet connection and try again.
                static let network = L10n.tr("shared.error.recovery.network", fallback: "Please check your internet connection and try again.")
                /// Make sure NFC is enabled on both devices and the other device is ready to receive.
                static let nfc = L10n.tr("shared.error.recovery.nfc", fallback: "Make sure NFC is enabled on both devices and the other device is ready to receive.")
                /// Failed to save your changes. Please try again.
                static let persistence = L10n.tr("shared.error.recovery.persistence", fallback: "Failed to save your changes. Please try again.")
                /// Unable to generate QR code for this link.
                static let qrCode = L10n.tr("shared.error.recovery.qr-code", fallback: "Unable to generate QR code for this link.")
                /// Please try again. If the problem persists, contact support.
                static let unknown = L10n.tr("shared.error.recovery.unknown", fallback: "Please try again. If the problem persists, contact support.")
                /// Please check your input and try again.
                static let validation = L10n.tr("shared.error.recovery.validation", fallback: "Please check your input and try again.")
            }

            enum Unknown {
                /// Error: %@
                static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.unknown.description", String(describing: p1), fallback: "Error: %@")
                }
            }

            enum Validation {
                /// Validation Error: %@
                static func description(_ p1: Any) -> String {
                    return L10n.tr("shared.error.validation.description", String(describing: p1), fallback: "Validation Error: %@")
                }
            }
        }

        enum Form {
            enum Name {
                /// Name
                static let label = L10n.tr("shared.form.name.label", fallback: "Name")
                enum Accessibility {
                    /// Enter the list name
                    static let hint = L10n.tr("shared.form.name.accessibility.hint", fallback: "Enter the list name")
                    /// Name field
                    static let label = L10n.tr("shared.form.name.accessibility.label", fallback: "Name field")
                }
            }

            enum Title {
                /// Title
                static let label = L10n.tr("shared.form.title.label", fallback: "Title")
                enum Accessibility {
                    /// Enter the link title
                    static let hint = L10n.tr("shared.form.title.accessibility.hint", fallback: "Enter the link title")
                    /// Title field
                    static let label = L10n.tr("shared.form.title.accessibility.label", fallback: "Title field")
                }
            }

            enum Url {
                /// URL
                static let label = L10n.tr("shared.form.url.label", fallback: "URL")
                enum Accessibility {
                    /// Enter the web address
                    static let hint = L10n.tr("shared.form.url.accessibility.hint", fallback: "Enter the web address")
                    /// URL field
                    static let label = L10n.tr("shared.form.url.accessibility.label", fallback: "URL field")
                }
            }
        }

        enum Item {
            enum Link {
                enum Accessibility {
                    /// Double tap to view link details
                    static let hint = L10n.tr("shared.item.link.accessibility.hint", fallback: "Double tap to view link details")
                    /// %@, %@
                    static func label(_ p1: Any, _ p2: Any) -> String {
                        return L10n.tr("shared.item.link.accessibility.label", String(describing: p1), String(describing: p2), fallback: "%@, %@")
                    }
                }

                enum Delete {
                    enum Accessibility {
                        /// Delete %@
                        static func label(_ p1: Any) -> String {
                            return L10n.tr("shared.item.link.delete.accessibility.label", String(describing: p1), fallback: "Delete %@")
                        }
                    }
                }

                enum Edit {
                    enum Accessibility {
                        /// Edit %@
                        static func label(_ p1: Any) -> String {
                            return L10n.tr("shared.item.link.edit.accessibility.label", String(describing: p1), fallback: "Edit %@")
                        }
                    }
                }

                enum Share {
                    enum Accessibility {
                        /// Share %@
                        static func label(_ p1: Any) -> String {
                            return L10n.tr("shared.item.link.share.accessibility.label", String(describing: p1), fallback: "Share %@")
                        }
                    }
                }
            }

            enum List {
                enum Accessibility {
                    /// Double tap to open list
                    static let hint = L10n.tr("shared.item.list.accessibility.hint", fallback: "Double tap to open list")
                    /// %@, %lld items
                    static func label(_ p1: Any, _ p2: Int) -> String {
                        return L10n.tr("shared.item.list.accessibility.label", String(describing: p1), p2, fallback: "%@, %lld items")
                    }
                }

                enum Delete {
                    enum Accessibility {
                        /// Delete %@
                        static func label(_ p1: Any) -> String {
                            return L10n.tr("shared.item.list.delete.accessibility.label", String(describing: p1), fallback: "Delete %@")
                        }
                    }
                }

                enum Edit {
                    enum Accessibility {
                        /// Edit %@
                        static func label(_ p1: Any) -> String {
                            return L10n.tr("shared.item.list.edit.accessibility.label", String(describing: p1), fallback: "Edit %@")
                        }
                    }
                }

                enum Pin {
                    enum Accessibility {
                        /// Pin %@
                        static func label(_ p1: Any) -> String {
                            return L10n.tr("shared.item.list.pin.accessibility.label", String(describing: p1), fallback: "Pin %@")
                        }
                    }
                }

                enum PinnedCard {
                    enum Accessibility {
                        /// Pinned list: %@, %lld items
                        static func label(_ p1: Any, _ p2: Int) -> String {
                            return L10n.tr("shared.item.list.pinned-card.accessibility.label", String(describing: p1), p2, fallback: "Pinned list: %@, %lld items")
                        }
                    }
                }

                enum Unpin {
                    enum Accessibility {
                        /// Unpin %@
                        static func label(_ p1: Any) -> String {
                            return L10n.tr("shared.item.list.unpin.accessibility.label", String(describing: p1), fallback: "Unpin %@")
                        }
                    }
                }
            }
        }

        enum Persistence {
            enum Error {
                /// Failed to delete link
                static let deleteLinkFailed = L10n.tr("shared.persistence.error.delete-link-failed", fallback: "Failed to delete link")
                /// Failed to delete list
                static let deleteListFailed = L10n.tr("shared.persistence.error.delete-list-failed", fallback: "Failed to delete list")
                /// Failed to delete links
                static let deleteMultipleLinksFailed = L10n.tr("shared.persistence.error.delete-multiple-links-failed", fallback: "Failed to delete links")
                /// Failed to pin list
                static let pinListFailed = L10n.tr("shared.persistence.error.pin-list-failed", fallback: "Failed to pin list")
                /// Please try again. If the problem persists, restart the app.
                static let recoverySuggestion = L10n.tr("shared.persistence.error.recovery-suggestion", fallback: "Please try again. If the problem persists, restart the app.")
                /// Failed to save deletion changes
                static let saveChangesAfterDeletionFailed = L10n.tr("shared.persistence.error.save-changes-after-deletion-failed", fallback: "Failed to save deletion changes")
                /// Failed to save link changes
                static let saveLinkChangesFailed = L10n.tr("shared.persistence.error.save-link-changes-failed", fallback: "Failed to save link changes")
                /// Failed to save link
                static let saveLinkFailed = L10n.tr("shared.persistence.error.save-link-failed", fallback: "Failed to save link")
                /// Failed to save list changes
                static let saveListChangesFailed = L10n.tr("shared.persistence.error.save-list-changes-failed", fallback: "Failed to save list changes")
                /// Failed to save list
                static let saveListFailed = L10n.tr("shared.persistence.error.save-list-failed", fallback: "Failed to save list")
                /// Failed to unpin list
                static let unpinListFailed = L10n.tr("shared.persistence.error.unpin-list-failed", fallback: "Failed to unpin list")
            }
        }

        enum QrCode {
            enum Accessibility {
                /// QR code that can be scanned to open this link
                static let hint = L10n.tr("shared.qr-code.accessibility.hint", fallback: "QR code that can be scanned to open this link")
                /// QR code for %@
                static func label(_ p1: Any) -> String {
                    return L10n.tr("shared.qr-code.accessibility.label", String(describing: p1), fallback: "QR code for %@")
                }
            }

            enum Generating {
                /// Generating QR code
                static let label = L10n.tr("shared.qr-code.generating.label", fallback: "Generating QR code")
                enum Accessibility {
                    /// Generating QR code
                    static let label = L10n.tr("shared.qr-code.generating.accessibility.label", fallback: "Generating QR code")
                }
            }

            enum GenerationFailed {
                /// QR code generation failed
                static let label = L10n.tr("shared.qr-code.generation-failed.label", fallback: "QR code generation failed")
                enum Accessibility {
                    /// QR code generation failed
                    static let label = L10n.tr("shared.qr-code.generation-failed.accessibility.label", fallback: "QR code generation failed")
                }
            }

            enum SaveToPhotos {
                /// Save to Photos
                static let label = L10n.tr("shared.qr-code.save-to-photos.label", fallback: "Save to Photos")
                /// QR code saved to Photos
                static let success = L10n.tr("shared.qr-code.save-to-photos.success", fallback: "QR code saved to Photos")
                enum Accessibility {
                    /// Save QR code image to Photos app
                    static let hint = L10n.tr("shared.qr-code.save-to-photos.accessibility.hint", fallback: "Save QR code image to Photos app")
                    /// Save to Photos
                    static let label = L10n.tr("shared.qr-code.save-to-photos.accessibility.label", fallback: "Save to Photos")
                }
            }

            enum ShareAsImage {
                /// Share as Image
                static let label = L10n.tr("shared.qr-code.share-as-image.label", fallback: "Share as Image")
                enum Accessibility {
                    /// Share QR code as Image
                    static let hint = L10n.tr("shared.qr-code.share-as-image.accessibility.hint", fallback: "Share QR code as Image")
                    /// Share as Image
                    static let label = L10n.tr("shared.qr-code.share-as-image.accessibility.label", fallback: "Share as Image")
                }
            }
        }

        enum SymbolPicker {
            enum Accessibility {
                /// Symbol picker. Current selection: %@
                static func hint(_ p1: Any) -> String {
                    return L10n.tr("shared.symbol-picker.accessibility.hint", String(describing: p1), fallback: "Symbol picker. Current selection: %@")
                }
            }

            enum Option {
                enum Accessibility {
                    /// %@ symbol option
                    static func label(_ p1: Any) -> String {
                        return L10n.tr("shared.symbol-picker.option.accessibility.label", String(describing: p1), fallback: "%@ symbol option")
                    }
                }
            }

            enum Section {
                /// Symbol
                static let title = L10n.tr("shared.symbol-picker.section.title", fallback: "Symbol")
            }
        }

        enum Toast {
            enum Error {
                enum Accessibility {
                    /// Error: %@
                    static func label(_ p1: Any) -> String {
                        return L10n.tr("shared.toast.error.accessibility.label", String(describing: p1), fallback: "Error: %@")
                    }
                }
            }

            enum Info {
                enum Accessibility {
                    /// Information: %@
                    static func label(_ p1: Any) -> String {
                        return L10n.tr("shared.toast.info.accessibility.label", String(describing: p1), fallback: "Information: %@")
                    }
                }
            }

            enum Success {
                enum Accessibility {
                    /// Success: %@
                    static func label(_ p1: Any) -> String {
                        return L10n.tr("shared.toast.success.accessibility.label", String(describing: p1), fallback: "Success: %@")
                    }
                }
            }

            enum Warning {
                enum Accessibility {
                    /// Warning: %@
                    static func label(_ p1: Any) -> String {
                        return L10n.tr("shared.toast.warning.accessibility.label", String(describing: p1), fallback: "Warning: %@")
                    }
                }
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
