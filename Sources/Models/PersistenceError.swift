import Foundation

/// Specific persistence error types with associated data
enum PersistenceError: LocalizedError, CustomStringConvertible {
    case saveLinkFailed(underlyingError: String)
    case saveListFailed(underlyingError: String)
    case deleteLinkFailed(underlyingError: String)
    case deleteMultipleLinksFailed(underlyingError: String)
    case deleteListFailed(underlyingError: String)
    case saveChangesAfterDeletionFailed(underlyingError: String)
    case pinListFailed(underlyingError: String)
    case unpinListFailed(underlyingError: String)
    case saveLinkChangesFailed(underlyingError: String)
    case saveListChangesFailed(underlyingError: String)

    var errorDescription: String? {
        switch self {
        case .saveLinkFailed:
            return L10n.Persistence.Error.saveLinkFailed
        case .saveListFailed:
            return L10n.Persistence.Error.saveListFailed
        case .deleteLinkFailed:
            return L10n.Persistence.Error.deleteLinkFailed
        case .deleteMultipleLinksFailed:
            return L10n.Persistence.Error.deleteMultipleLinksFailed
        case .deleteListFailed:
            return L10n.Persistence.Error.deleteListFailed
        case .saveChangesAfterDeletionFailed:
            return L10n.Persistence.Error.saveChangesAfterDeletionFailed
        case .pinListFailed:
            return L10n.Persistence.Error.pinListFailed
        case .unpinListFailed:
            return L10n.Persistence.Error.unpinListFailed
        case .saveLinkChangesFailed:
            return L10n.Persistence.Error.saveLinkChangesFailed
        case .saveListChangesFailed:
            return L10n.Persistence.Error.saveListChangesFailed
        }
    }

    var recoverySuggestion: String? {
        return L10n.Persistence.Error.recoverySuggestion
    }

    var underlyingError: String {
        switch self {
        case .saveLinkFailed(let error),
                .saveListFailed(let error),
                .deleteLinkFailed(let error),
                .deleteMultipleLinksFailed(let error),
                .deleteListFailed(let error),
                .saveChangesAfterDeletionFailed(let error),
                .pinListFailed(let error),
                .unpinListFailed(let error),
                .saveLinkChangesFailed(let error),
                .saveListChangesFailed(let error):
            return error
        }
    }
    
    /// Non-localized description for logging purposes (always in English)
    var description: String {
        switch self {
        case .saveLinkFailed(let error):
            return "Save link failed: \(error)"
        case .saveListFailed(let error):
            return "Save list failed: \(error)"
        case .deleteLinkFailed(let error):
            return "Delete link failed: \(error)"
        case .deleteMultipleLinksFailed(let error):
            return "Delete multiple links failed: \(error)"
        case .deleteListFailed(let error):
            return "Delete list failed: \(error)"
        case .saveChangesAfterDeletionFailed(let error):
            return "Save changes after deletion failed: \(error)"
        case .pinListFailed(let error):
            return "Pin list failed: \(error)"
        case .unpinListFailed(let error):
            return "Unpin list failed: \(error)"
        case .saveLinkChangesFailed(let error):
            return "Save link changes failed: \(error)"
        case .saveListChangesFailed(let error):
            return "Save list changes failed: \(error)"
        }
    }
}

extension PersistenceError: Equatable {
    static func == (lhs: PersistenceError, rhs: PersistenceError) -> Bool {
        switch (lhs, rhs) {
        case (.saveLinkFailed(let lhsError), .saveLinkFailed(let rhsError)):
            return lhsError == rhsError
        case (.saveListFailed(let lhsError), .saveListFailed(let rhsError)):
            return lhsError == rhsError
        case (.deleteLinkFailed(let lhsError), .deleteLinkFailed(let rhsError)):
            return lhsError == rhsError
        case (.deleteMultipleLinksFailed(let lhsError), .deleteMultipleLinksFailed(let rhsError)):
            return lhsError == rhsError
        case (.deleteListFailed(let lhsError), .deleteListFailed(let rhsError)):
            return lhsError == rhsError
        case (.saveChangesAfterDeletionFailed(let lhsError), .saveChangesAfterDeletionFailed(let rhsError)):
            return lhsError == rhsError
        case (.pinListFailed(let lhsError), .pinListFailed(let rhsError)):
            return lhsError == rhsError
        case (.unpinListFailed(let lhsError), .unpinListFailed(let rhsError)):
            return lhsError == rhsError
        case (.saveLinkChangesFailed(let lhsError), .saveLinkChangesFailed(let rhsError)):
            return lhsError == rhsError
        case (.saveListChangesFailed(let lhsError), .saveListChangesFailed(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
