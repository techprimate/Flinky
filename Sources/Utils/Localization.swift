// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum App {
    /// Flinky
    internal static let title = L10n.tr("app.title", fallback: "Flinky")
  }
  internal enum CreateLink {
    /// New Link
    internal static let title = L10n.tr("create-link.title", fallback: "New Link")
    /// Please enter a valid URL
    internal static let urlValidation = L10n.tr("create-link.url-validation", fallback: "Please enter a valid URL")
  }
  internal enum CreateList {
    /// New List
    internal static let title = L10n.tr("create-list.title", fallback: "New List")
  }
  internal enum LinkDetail {
    internal enum EditLink {
      /// Edit
      internal static let label = L10n.tr("link-detail.edit-link.label", fallback: "Edit")
      internal enum Accessibility {
        /// Edit link properties
        internal static let hint = L10n.tr("link-detail.edit-link.accessibility.hint", fallback: "Edit link properties")
        /// Edit link
        internal static let label = L10n.tr("link-detail.edit-link.accessibility.label", fallback: "Edit link")
      }
    }
    internal enum MoreMenu {
      /// More
      internal static let label = L10n.tr("link-detail.more-menu.label", fallback: "More")
      internal enum Accessibility {
        /// Find additional actions for this link
        internal static let hint = L10n.tr("link-detail.more-menu.accessibility.hint", fallback: "Find additional actions for this link")
        /// More Actions
        internal static let label = L10n.tr("link-detail.more-menu.accessibility.label", fallback: "More Actions")
      }
    }
    internal enum OpenInSafari {
      /// Open in Safari
      internal static let label = L10n.tr("link-detail.open-in-safari.label", fallback: "Open in Safari")
    }
    internal enum ShareLink {
      /// Share Link
      internal static let label = L10n.tr("link-detail.share-link.label", fallback: "Share Link")
      internal enum Accessibility {
        /// Share this link with others
        internal static let hint = L10n.tr("link-detail.share-link.accessibility.hint", fallback: "Share this link with others")
        /// Share %@
        internal static func label(_ p1: Any) -> String {
          return L10n.tr("link-detail.share-link.accessibility.label", String(describing: p1), fallback: "Share %@")
        }
      }
    }
    internal enum ShareViaNfc {
      /// Share via NFC
      internal static let label = L10n.tr("link-detail.share-via-nfc.label", fallback: "Share via NFC")
      internal enum Accessibility {
        /// Share this link using NFC
        internal static let hint = L10n.tr("link-detail.share-via-nfc.accessibility.hint", fallback: "Share this link using NFC")
        /// Share %@ via NFC
        internal static func label(_ p1: Any) -> String {
          return L10n.tr("link-detail.share-via-nfc.accessibility.label", String(describing: p1), fallback: "Share %@ via NFC")
        }
      }
    }
  }
  internal enum LinkListDetail {
    /// New Link
    internal static let newLink = L10n.tr("link-list-detail.new-link", fallback: "New Link")
    /// Add a new link to get started
    internal static let noLinksDescription = L10n.tr("link-list-detail.no-links-description", fallback: "Add a new link to get started")
    /// No links available
    internal static let noLinksTitle = L10n.tr("link-list-detail.no-links-title", fallback: "No links available")
  }
  internal enum LinkLists {
    /// My Lists
    internal static let myListsSection = L10n.tr("link-lists.my-lists-section", fallback: "My Lists")
    /// Create a new list to get started
    internal static let noListsDescription = L10n.tr("link-lists.no-lists-description", fallback: "Create a new list to get started")
    /// No lists available
    internal static let noListsTitle = L10n.tr("link-lists.no-lists-title", fallback: "No lists available")
    /// Pinned
    internal static let pinnedSection = L10n.tr("link-lists.pinned-section", fallback: "Pinned")
  }
  internal enum Search {
    /// Search links
    internal static let links = L10n.tr("search.links", fallback: "Search links")
    /// Search lists and links
    internal static let listsAndLinks = L10n.tr("search.lists-and-links", fallback: "Search lists and links")
  }
  internal enum Shared {
    internal enum Action {
      /// Delete
      internal static let delete = L10n.tr("shared.action.delete", fallback: "Delete")
      /// Edit
      internal static let edit = L10n.tr("shared.action.edit", fallback: "Edit")
      /// Pin
      internal static let pin = L10n.tr("shared.action.pin", fallback: "Pin")
      /// Share Link
      internal static let share = L10n.tr("shared.action.share", fallback: "Share Link")
      /// Unpin
      internal static let unpin = L10n.tr("shared.action.unpin", fallback: "Unpin")
      internal enum Share {
        internal enum Accessibility {
          /// Share this link with others
          internal static let hint = L10n.tr("shared.action.share.accessibility.hint", fallback: "Share this link with others")
        }
      }
    }
    internal enum Button {
      internal enum Cancel {
        /// Cancel
        internal static let label = L10n.tr("shared.button.cancel.label", fallback: "Cancel")
        internal enum Accessibility {
          /// Cancel
          internal static let label = L10n.tr("shared.button.cancel.accessibility.label", fallback: "Cancel")
        }
      }
      internal enum Delete {
        /// Delete
        internal static let label = L10n.tr("shared.button.delete.label", fallback: "Delete")
        internal enum Accessibility {
          /// Delete
          internal static let label = L10n.tr("shared.button.delete.accessibility.label", fallback: "Delete")
        }
      }
      internal enum Done {
        /// Done
        internal static let label = L10n.tr("shared.button.done.label", fallback: "Done")
        internal enum Accessibility {
          /// Done
          internal static let label = L10n.tr("shared.button.done.accessibility.label", fallback: "Done")
        }
      }
      internal enum Edit {
        /// Edit
        internal static let label = L10n.tr("shared.button.edit.label", fallback: "Edit")
        internal enum Accessibility {
          /// Edit
          internal static let label = L10n.tr("shared.button.edit.accessibility.label", fallback: "Edit")
        }
      }
      internal enum NewLink {
        internal enum Accessibility {
          /// Add new link
          internal static let label = L10n.tr("shared.button.new-link.accessibility.label", fallback: "Add new link")
        }
      }
      internal enum NewList {
        internal enum Accessibility {
          /// Create new list
          internal static let label = L10n.tr("shared.button.new-list.accessibility.label", fallback: "Create new list")
        }
      }
      internal enum Save {
        /// Save
        internal static let label = L10n.tr("shared.button.save.label", fallback: "Save")
        internal enum Accessibility {
          /// Save
          internal static let label = L10n.tr("shared.button.save.accessibility.label", fallback: "Save")
        }
      }
    }
    internal enum Color {
      /// Blue
      internal static let blue = L10n.tr("shared.color.blue", fallback: "Blue")
      /// Brown
      internal static let brown = L10n.tr("shared.color.brown", fallback: "Brown")
      /// Gray
      internal static let gray = L10n.tr("shared.color.gray", fallback: "Gray")
      /// Green
      internal static let green = L10n.tr("shared.color.green", fallback: "Green")
      /// Indigo
      internal static let indigo = L10n.tr("shared.color.indigo", fallback: "Indigo")
      /// Light Blue
      internal static let lightBlue = L10n.tr("shared.color.light-blue", fallback: "Light Blue")
      /// Mint
      internal static let mint = L10n.tr("shared.color.mint", fallback: "Mint")
      /// Orange
      internal static let orange = L10n.tr("shared.color.orange", fallback: "Orange")
      /// Pink
      internal static let pink = L10n.tr("shared.color.pink", fallback: "Pink")
      /// Purple
      internal static let purple = L10n.tr("shared.color.purple", fallback: "Purple")
      /// Red
      internal static let red = L10n.tr("shared.color.red", fallback: "Red")
      /// Yellow
      internal static let yellow = L10n.tr("shared.color.yellow", fallback: "Yellow")
    }
    internal enum ColorPicker {
      internal enum Accessibility {
        /// Color picker. Current selection: %@
        internal static func hint(_ p1: Any) -> String {
          return L10n.tr("shared.color-picker.accessibility.hint", String(describing: p1), fallback: "Color picker. Current selection: %@")
        }
      }
      internal enum Option {
        internal enum Accessibility {
          /// %@ color option
          internal static func label(_ p1: Any) -> String {
            return L10n.tr("shared.color-picker.option.accessibility.label", String(describing: p1), fallback: "%@ color option")
          }
        }
      }
      internal enum Section {
        /// Color
        internal static let title = L10n.tr("shared.color-picker.section.title", fallback: "Color")
      }
    }
    internal enum DeleteConfirmation {
      internal enum Link {
        /// Delete link "%@"?
        internal static func alertTitle(_ p1: Any) -> String {
          return L10n.tr("shared.delete-confirmation.link.alert-title", String(describing: p1), fallback: "Delete link \"%@\"?")
        }
      }
      internal enum Links {
        /// Delete selected links?
        internal static let alertTitle = L10n.tr("shared.delete-confirmation.links.alert-title", fallback: "Delete selected links?")
        /// This will delete the links "%@".
        /// This can not be undone.
        internal static func warningMessage(_ p1: Any) -> String {
          return L10n.tr("shared.delete-confirmation.links.warning-message", String(describing: p1), fallback: "This will delete the links \"%@\".\nThis can not be undone.")
        }
      }
      internal enum List {
        /// Delete list "%@"?
        internal static func alertTitle(_ p1: Any) -> String {
          return L10n.tr("shared.delete-confirmation.list.alert-title", String(describing: p1), fallback: "Delete list \"%@\"?")
        }
      }
      internal enum Lists {
        /// Delete selected lists?
        internal static let alertTitle = L10n.tr("shared.delete-confirmation.lists.alert-title", fallback: "Delete selected lists?")
        /// This will delete the lists "%@" and their links.
        /// This can not be undone.
        internal static func warningMessage(_ p1: Any) -> String {
          return L10n.tr("shared.delete-confirmation.lists.warning-message", String(describing: p1), fallback: "This will delete the lists \"%@\" and their links.\nThis can not be undone.")
        }
      }
      internal enum Warning {
        /// This can not be undone.
        internal static let cannotUndo = L10n.tr("shared.delete-confirmation.warning.cannot-undo", fallback: "This can not be undone.")
      }
    }
    internal enum EmojiPicker {
      internal enum Accessibility {
        /// Select custom emoji
        internal static let hint = L10n.tr("shared.emoji-picker.accessibility.hint", fallback: "Select custom emoji")
      }
    }
    internal enum Error {
      /// OK
      internal static let okButton = L10n.tr("shared.error.ok-button", fallback: "OK")
      /// Error
      internal static let title = L10n.tr("shared.error.title", fallback: "Error")
      internal enum DataCorruption {
        /// Data Error: %@
        internal static func description(_ p1: Any) -> String {
          return L10n.tr("shared.error.data-corruption.description", String(describing: p1), fallback: "Data Error: %@")
        }
      }
      internal enum FailedToOpenUrl {
        /// Failed to open URL: %@
        internal static func description(_ p1: Any) -> String {
          return L10n.tr("shared.error.failed-to-open-url.description", String(describing: p1), fallback: "Failed to open URL: %@")
        }
        /// Make sure the URL you entered is valid, e.g. includes https:// at the beginning
        internal static let recoverySuggestion = L10n.tr("shared.error.failed-to-open-url.recovery-suggestion", fallback: "Make sure the URL you entered is valid, e.g. includes https:// at the beginning")
      }
      internal enum Network {
        /// Network Error: %@
        internal static func description(_ p1: Any) -> String {
          return L10n.tr("shared.error.network.description", String(describing: p1), fallback: "Network Error: %@")
        }
      }
      internal enum Persistence {
        /// Save Error: %@
        internal static func description(_ p1: Any) -> String {
          return L10n.tr("shared.error.persistence.description", String(describing: p1), fallback: "Save Error: %@")
        }
      }
      internal enum QrCode {
        /// QR Code Error: %@
        internal static func description(_ p1: Any) -> String {
          return L10n.tr("shared.error.qr-code.description", String(describing: p1), fallback: "QR Code Error: %@")
        }
      }
      internal enum Recovery {
        /// Please try restarting the app. If the problem persists, contact support.
        internal static let dataCorruption = L10n.tr("shared.error.recovery.data-corruption", fallback: "Please try restarting the app. If the problem persists, contact support.")
        /// Please check your internet connection and try again.
        internal static let network = L10n.tr("shared.error.recovery.network", fallback: "Please check your internet connection and try again.")
        /// Failed to save your changes. Please try again.
        internal static let persistence = L10n.tr("shared.error.recovery.persistence", fallback: "Failed to save your changes. Please try again.")
        /// Unable to generate QR code for this link.
        internal static let qrCode = L10n.tr("shared.error.recovery.qr-code", fallback: "Unable to generate QR code for this link.")
        /// Please try again. If the problem persists, contact support.
        internal static let unknown = L10n.tr("shared.error.recovery.unknown", fallback: "Please try again. If the problem persists, contact support.")
        /// Please check your input and try again.
        internal static let validation = L10n.tr("shared.error.recovery.validation", fallback: "Please check your input and try again.")
      }
      internal enum Unknown {
        /// Error: %@
        internal static func description(_ p1: Any) -> String {
          return L10n.tr("shared.error.unknown.description", String(describing: p1), fallback: "Error: %@")
        }
      }
      internal enum Validation {
        /// Validation Error: %@
        internal static func description(_ p1: Any) -> String {
          return L10n.tr("shared.error.validation.description", String(describing: p1), fallback: "Validation Error: %@")
        }
      }
    }
    internal enum Form {
      internal enum Name {
        /// Name
        internal static let label = L10n.tr("shared.form.name.label", fallback: "Name")
        internal enum Accessibility {
          /// Enter the list name
          internal static let hint = L10n.tr("shared.form.name.accessibility.hint", fallback: "Enter the list name")
          /// Name field
          internal static let label = L10n.tr("shared.form.name.accessibility.label", fallback: "Name field")
        }
      }
      internal enum Title {
        /// Title
        internal static let label = L10n.tr("shared.form.title.label", fallback: "Title")
        internal enum Accessibility {
          /// Enter the link title
          internal static let hint = L10n.tr("shared.form.title.accessibility.hint", fallback: "Enter the link title")
          /// Title field
          internal static let label = L10n.tr("shared.form.title.accessibility.label", fallback: "Title field")
        }
      }
      internal enum Url {
        /// URL
        internal static let label = L10n.tr("shared.form.url.label", fallback: "URL")
        internal enum Accessibility {
          /// Enter the web address
          internal static let hint = L10n.tr("shared.form.url.accessibility.hint", fallback: "Enter the web address")
          /// URL field
          internal static let label = L10n.tr("shared.form.url.accessibility.label", fallback: "URL field")
        }
      }
    }
    internal enum Item {
      internal enum Link {
        internal enum Accessibility {
          /// Double tap to view link details
          internal static let hint = L10n.tr("shared.item.link.accessibility.hint", fallback: "Double tap to view link details")
          /// %@, %@
          internal static func label(_ p1: Any, _ p2: Any) -> String {
            return L10n.tr("shared.item.link.accessibility.label", String(describing: p1), String(describing: p2), fallback: "%@, %@")
          }
        }
        internal enum Delete {
          internal enum Accessibility {
            /// Delete %@
            internal static func label(_ p1: Any) -> String {
              return L10n.tr("shared.item.link.delete.accessibility.label", String(describing: p1), fallback: "Delete %@")
            }
          }
        }
        internal enum Edit {
          internal enum Accessibility {
            /// Edit %@
            internal static func label(_ p1: Any) -> String {
              return L10n.tr("shared.item.link.edit.accessibility.label", String(describing: p1), fallback: "Edit %@")
            }
          }
        }
        internal enum Share {
          internal enum Accessibility {
            /// Share %@
            internal static func label(_ p1: Any) -> String {
              return L10n.tr("shared.item.link.share.accessibility.label", String(describing: p1), fallback: "Share %@")
            }
          }
        }
      }
      internal enum List {
        internal enum Accessibility {
          /// Double tap to open list
          internal static let hint = L10n.tr("shared.item.list.accessibility.hint", fallback: "Double tap to open list")
          /// %@, %lld items
          internal static func label(_ p1: Any, _ p2: Int) -> String {
            return L10n.tr("shared.item.list.accessibility.label", String(describing: p1), p2, fallback: "%@, %lld items")
          }
        }
        internal enum Delete {
          internal enum Accessibility {
            /// Delete %@
            internal static func label(_ p1: Any) -> String {
              return L10n.tr("shared.item.list.delete.accessibility.label", String(describing: p1), fallback: "Delete %@")
            }
          }
        }
        internal enum Edit {
          internal enum Accessibility {
            /// Edit %@
            internal static func label(_ p1: Any) -> String {
              return L10n.tr("shared.item.list.edit.accessibility.label", String(describing: p1), fallback: "Edit %@")
            }
          }
        }
        internal enum Pin {
          internal enum Accessibility {
            /// Pin %@
            internal static func label(_ p1: Any) -> String {
              return L10n.tr("shared.item.list.pin.accessibility.label", String(describing: p1), fallback: "Pin %@")
            }
          }
        }
        internal enum PinnedCard {
          internal enum Accessibility {
            /// Pinned list: %@, %lld items
            internal static func label(_ p1: Any, _ p2: Int) -> String {
              return L10n.tr("shared.item.list.pinned-card.accessibility.label", String(describing: p1), p2, fallback: "Pinned list: %@, %lld items")
            }
          }
        }
        internal enum Unpin {
          internal enum Accessibility {
            /// Unpin %@
            internal static func label(_ p1: Any) -> String {
              return L10n.tr("shared.item.list.unpin.accessibility.label", String(describing: p1), fallback: "Unpin %@")
            }
          }
        }
      }
    }
    internal enum Persistence {
      internal enum Error {
        /// Failed to delete link
        internal static let deleteLinkFailed = L10n.tr("shared.persistence.error.delete-link-failed", fallback: "Failed to delete link")
        /// Failed to delete list
        internal static let deleteListFailed = L10n.tr("shared.persistence.error.delete-list-failed", fallback: "Failed to delete list")
        /// Failed to delete links
        internal static let deleteMultipleLinksFailed = L10n.tr("shared.persistence.error.delete-multiple-links-failed", fallback: "Failed to delete links")
        /// Failed to pin list
        internal static let pinListFailed = L10n.tr("shared.persistence.error.pin-list-failed", fallback: "Failed to pin list")
        /// Please try again. If the problem persists, restart the app.
        internal static let recoverySuggestion = L10n.tr("shared.persistence.error.recovery-suggestion", fallback: "Please try again. If the problem persists, restart the app.")
        /// Failed to save deletion changes
        internal static let saveChangesAfterDeletionFailed = L10n.tr("shared.persistence.error.save-changes-after-deletion-failed", fallback: "Failed to save deletion changes")
        /// Failed to save link changes
        internal static let saveLinkChangesFailed = L10n.tr("shared.persistence.error.save-link-changes-failed", fallback: "Failed to save link changes")
        /// Failed to save link
        internal static let saveLinkFailed = L10n.tr("shared.persistence.error.save-link-failed", fallback: "Failed to save link")
        /// Failed to save list changes
        internal static let saveListChangesFailed = L10n.tr("shared.persistence.error.save-list-changes-failed", fallback: "Failed to save list changes")
        /// Failed to save list
        internal static let saveListFailed = L10n.tr("shared.persistence.error.save-list-failed", fallback: "Failed to save list")
        /// Failed to unpin list
        internal static let unpinListFailed = L10n.tr("shared.persistence.error.unpin-list-failed", fallback: "Failed to unpin list")
      }
    }
    internal enum QrCode {
      internal enum Accessibility {
        /// QR code that can be scanned to open this link
        internal static let hint = L10n.tr("shared.qr-code.accessibility.hint", fallback: "QR code that can be scanned to open this link")
        /// QR code for %@
        internal static func label(_ p1: Any) -> String {
          return L10n.tr("shared.qr-code.accessibility.label", String(describing: p1), fallback: "QR code for %@")
        }
      }
      internal enum Generating {
        /// Generating QR code
        internal static let label = L10n.tr("shared.qr-code.generating.label", fallback: "Generating QR code")
        internal enum Accessibility {
          /// Generating QR code
          internal static let label = L10n.tr("shared.qr-code.generating.accessibility.label", fallback: "Generating QR code")
        }
      }
      internal enum GenerationFailed {
        /// QR code generation failed
        internal static let label = L10n.tr("shared.qr-code.generation-failed.label", fallback: "QR code generation failed")
        internal enum Accessibility {
          /// QR code generation failed
          internal static let label = L10n.tr("shared.qr-code.generation-failed.accessibility.label", fallback: "QR code generation failed")
        }
      }
      internal enum SaveToPhotos {
        /// Save to Photos
        internal static let label = L10n.tr("shared.qr-code.save-to-photos.label", fallback: "Save to Photos")
        /// QR code saved to Photos
        internal static let success = L10n.tr("shared.qr-code.save-to-photos.success", fallback: "QR code saved to Photos")
        internal enum Accessibility {
          /// Save QR code image to Photos app
          internal static let hint = L10n.tr("shared.qr-code.save-to-photos.accessibility.hint", fallback: "Save QR code image to Photos app")
          /// Save to Photos
          internal static let label = L10n.tr("shared.qr-code.save-to-photos.accessibility.label", fallback: "Save to Photos")
        }
      }
      internal enum ShareAsImage {
        /// Share as Image
        internal static let label = L10n.tr("shared.qr-code.share-as-image.label", fallback: "Share as Image")
        internal enum Accessibility {
          /// Share QR code as Image
          internal static let hint = L10n.tr("shared.qr-code.share-as-image.accessibility.hint", fallback: "Share QR code as Image")
          /// Share as Image
          internal static let label = L10n.tr("shared.qr-code.share-as-image.accessibility.label", fallback: "Share as Image")
        }
      }
    }
    internal enum SymbolPicker {
      internal enum Accessibility {
        /// Symbol picker. Current selection: %@
        internal static func hint(_ p1: Any) -> String {
          return L10n.tr("shared.symbol-picker.accessibility.hint", String(describing: p1), fallback: "Symbol picker. Current selection: %@")
        }
      }
      internal enum Option {
        internal enum Accessibility {
          /// %@ symbol option
          internal static func label(_ p1: Any) -> String {
            return L10n.tr("shared.symbol-picker.option.accessibility.label", String(describing: p1), fallback: "%@ symbol option")
          }
        }
      }
      internal enum Section {
        /// Symbol
        internal static let title = L10n.tr("shared.symbol-picker.section.title", fallback: "Symbol")
      }
    }
    internal enum Toast {
      internal enum Error {
        internal enum Accessibility {
          /// Error: %@
          internal static func label(_ p1: Any) -> String {
            return L10n.tr("shared.toast.error.accessibility.label", String(describing: p1), fallback: "Error: %@")
          }
        }
      }
      internal enum Info {
        internal enum Accessibility {
          /// Information: %@
          internal static func label(_ p1: Any) -> String {
            return L10n.tr("shared.toast.info.accessibility.label", String(describing: p1), fallback: "Information: %@")
          }
        }
      }
      internal enum Success {
        internal enum Accessibility {
          /// Success: %@
          internal static func label(_ p1: Any) -> String {
            return L10n.tr("shared.toast.success.accessibility.label", String(describing: p1), fallback: "Success: %@")
          }
        }
      }
      internal enum Warning {
        internal enum Accessibility {
          /// Warning: %@
          internal static func label(_ p1: Any) -> String {
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
 