import Foundation

enum ShareExtensionError: LocalizedError, CustomStringConvertible {
    case noValidURLFound
    case notAnURLExtensionItem

    var errorDescription: String? {
        switch self {
        case .noValidURLFound:
            return L10n.ShareExtension.Error.NoUrl.description
        case .notAnURLExtensionItem:
            return L10n.ShareExtension.Error.InvalidUrl.description
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .noValidURLFound:
            return L10n.ShareExtension.Error.NoUrl.recoverySuggestion
        case .notAnURLExtensionItem:
            return L10n.ShareExtension.Error.InvalidUrl.recoverySuggestion
        }
    }

    var description: String {
        switch self {
        case .noValidURLFound:
            return "No valid URL found in shared items"
        case .notAnURLExtensionItem:
            return "Item is not a URL"
        }
    }
}
