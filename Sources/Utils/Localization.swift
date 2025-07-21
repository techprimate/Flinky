// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Accessibility {
    /// Delete %@
    internal static func deleteLink(_ p1: Any) -> String {
      return L10n.tr("accessibility.delete_link", String(describing: p1), fallback: "Delete %@")
    }
    /// Edit %@
    internal static func editLink(_ p1: Any) -> String {
      return L10n.tr("accessibility.edit_link", String(describing: p1), fallback: "Edit %@")
    }
    /// %@, %@
    internal static func linkItem(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("accessibility.link_item", String(describing: p1), String(describing: p2), fallback: "%@, %@")
    }
    /// Double tap to view link details
    internal static let linkItemHint = L10n.tr("accessibility.link_item_hint", fallback: "Double tap to view link details")
    /// Share %@
    internal static func shareLink(_ p1: Any) -> String {
      return L10n.tr("accessibility.share_link", String(describing: p1), fallback: "Share %@")
    }
  }
  internal enum Action {
    /// Delete
    internal static let delete = L10n.tr("action.delete", fallback: "Delete")
    /// Edit
    internal static let edit = L10n.tr("action.edit", fallback: "Edit")
    /// Pin
    internal static let pin = L10n.tr("action.pin", fallback: "Pin")
    /// Share Link
    internal static let share = L10n.tr("action.share", fallback: "Share Link")
    /// Share this link with others
    internal static let shareHint = L10n.tr("action.share_hint", fallback: "Share this link with others")
    /// Unpin
    internal static let unpin = L10n.tr("action.unpin", fallback: "Unpin")
  }
  internal enum App {
    /// Flinky
    internal static let title = L10n.tr("app.title", fallback: "Flinky")
  }
  internal enum CreateLink {
    /// New Link
    internal static let title = L10n.tr("create_link.title", fallback: "New Link")
    /// Please enter a valid URL
    internal static let urlValidation = L10n.tr("create_link.url_validation", fallback: "Please enter a valid URL")
  }
  internal enum CreateList {
    /// New List
    internal static let title = L10n.tr("create_list.title", fallback: "New List")
  }
  internal enum Error {
    /// Data Error: %@
    internal static func dataCorruption(_ p1: Any) -> String {
      return L10n.tr("error.data_corruption", String(describing: p1), fallback: "Data Error: %@")
    }
    /// Network Error: %@
    internal static func network(_ p1: Any) -> String {
      return L10n.tr("error.network", String(describing: p1), fallback: "Network Error: %@")
    }
    /// OK
    internal static let ok = L10n.tr("error.ok", fallback: "OK")
    /// Save Error: %@
    internal static func persistence(_ p1: Any) -> String {
      return L10n.tr("error.persistence", String(describing: p1), fallback: "Save Error: %@")
    }
    /// QR Code Error: %@
    internal static func qrCode(_ p1: Any) -> String {
      return L10n.tr("error.qr_code", String(describing: p1), fallback: "QR Code Error: %@")
    }
    /// Error
    internal static let title = L10n.tr("error.title", fallback: "Error")
    /// Error: %@
    internal static func unknown(_ p1: Any) -> String {
      return L10n.tr("error.unknown", String(describing: p1), fallback: "Error: %@")
    }
    /// Validation Error: %@
    internal static func validation(_ p1: Any) -> String {
      return L10n.tr("error.validation", String(describing: p1), fallback: "Validation Error: %@")
    }
    internal enum Recovery {
      /// Please try restarting the app. If the problem persists, contact support.
      internal static let dataCorruption = L10n.tr("error.recovery.data_corruption", fallback: "Please try restarting the app. If the problem persists, contact support.")
      /// Please check your internet connection and try again.
      internal static let network = L10n.tr("error.recovery.network", fallback: "Please check your internet connection and try again.")
      /// Failed to save your changes. Please try again.
      internal static let persistence = L10n.tr("error.recovery.persistence", fallback: "Failed to save your changes. Please try again.")
      /// Unable to generate QR code for this link.
      internal static let qrCode = L10n.tr("error.recovery.qr_code", fallback: "Unable to generate QR code for this link.")
      /// Please try again. If the problem persists, contact support.
      internal static let unknown = L10n.tr("error.recovery.unknown", fallback: "Please try again. If the problem persists, contact support.")
      /// Please check your input and try again.
      internal static let validation = L10n.tr("error.recovery.validation", fallback: "Please check your input and try again.")
    }
  }
  internal enum Form {
    /// Cancel
    internal static let cancel = L10n.tr("form.cancel", fallback: "Cancel")
    /// Delete
    internal static let delete = L10n.tr("form.delete", fallback: "Delete")
    /// Done
    internal static let done = L10n.tr("form.done", fallback: "Done")
    /// Edit
    internal static let edit = L10n.tr("form.edit", fallback: "Edit")
    /// Name
    internal static let name = L10n.tr("form.name", fallback: "Name")
    /// Save
    internal static let save = L10n.tr("form.save", fallback: "Save")
    /// Title
    internal static let title = L10n.tr("form.title", fallback: "Title")
    /// URL
    internal static let url = L10n.tr("form.url", fallback: "URL")
  }
  internal enum Links {
    /// New Link
    internal static let newLink = L10n.tr("links.new_link", fallback: "New Link")
    /// Add a new link to get started
    internal static let noLinksDescription = L10n.tr("links.no_links_description", fallback: "Add a new link to get started")
    /// No links available
    internal static let noLinksTitle = L10n.tr("links.no_links_title", fallback: "No links available")
  }
  internal enum Lists {
    /// My Lists
    internal static let myListsSection = L10n.tr("lists.my_lists_section", fallback: "My Lists")
    /// Create a new list to get started
    internal static let noListsDescription = L10n.tr("lists.no_lists_description", fallback: "Create a new list to get started")
    /// No lists available
    internal static let noListsTitle = L10n.tr("lists.no_lists_title", fallback: "No lists available")
    /// Pinned
    internal static let pinnedSection = L10n.tr("lists.pinned_section", fallback: "Pinned")
  }
  internal enum Persistence {
    internal enum Error {
      /// Failed to delete link
      internal static let deleteLinkFailed = L10n.tr("persistence.error.delete_link_failed", fallback: "Failed to delete link")
      /// Failed to delete list
      internal static let deleteListFailed = L10n.tr("persistence.error.delete_list_failed", fallback: "Failed to delete list")
      /// Failed to delete links
      internal static let deleteMultipleLinksFailed = L10n.tr("persistence.error.delete_multiple_links_failed", fallback: "Failed to delete links")
      /// Failed to pin list
      internal static let pinListFailed = L10n.tr("persistence.error.pin_list_failed", fallback: "Failed to pin list")
      /// Please try again. If the problem persists, restart the app.
      internal static let recoverySuggestion = L10n.tr("persistence.error.recovery_suggestion", fallback: "Please try again. If the problem persists, restart the app.")
      /// Failed to save deletion changes
      internal static let saveChangesAfterDeletionFailed = L10n.tr("persistence.error.save_changes_after_deletion_failed", fallback: "Failed to save deletion changes")
      /// Failed to save link changes
      internal static let saveLinkChangesFailed = L10n.tr("persistence.error.save_link_changes_failed", fallback: "Failed to save link changes")
      /// Failed to save link
      internal static let saveLinkFailed = L10n.tr("persistence.error.save_link_failed", fallback: "Failed to save link")
      /// Failed to save list changes
      internal static let saveListChangesFailed = L10n.tr("persistence.error.save_list_changes_failed", fallback: "Failed to save list changes")
      /// Failed to save list
      internal static let saveListFailed = L10n.tr("persistence.error.save_list_failed", fallback: "Failed to save list")
      /// Failed to unpin list
      internal static let unpinListFailed = L10n.tr("persistence.error.unpin_list_failed", fallback: "Failed to unpin list")
    }
  }
  internal enum QrCode {
    /// QR code that can be scanned to open this link
    internal static let accessibilityHint = L10n.tr("qr_code.accessibility_hint", fallback: "QR code that can be scanned to open this link")
    /// QR code for %@
    internal static func accessibilityLabel(_ p1: Any) -> String {
      return L10n.tr("qr_code.accessibility_label", String(describing: p1), fallback: "QR code for %@")
    }
    /// Generating QR code
    internal static let generating = L10n.tr("qr_code.generating", fallback: "Generating QR code")
    /// QR code generation failed
    internal static let generationFailed = L10n.tr("qr_code.generation_failed", fallback: "QR code generation failed")
  }
  internal enum Search {
    /// Search links
    internal static let links = L10n.tr("search.links", fallback: "Search links")
    /// Search lists and links
    internal static let listsAndLinks = L10n.tr("search.lists_and_links", fallback: "Search lists and links")
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
 