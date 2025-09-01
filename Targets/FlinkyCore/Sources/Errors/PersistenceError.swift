import Foundation

/// Specific persistence error types with associated data
public enum PersistenceError: LocalizedError, CustomStringConvertible {
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

    public var errorDescription: String? {
        switch self {
        case .saveLinkFailed:
            return L10n.Shared.Persistence.Error.saveLinkFailed
        case .saveListFailed:
            return L10n.Shared.Persistence.Error.saveListFailed
        case .deleteLinkFailed:
            return L10n.Shared.Persistence.Error.deleteLinkFailed
        case .deleteMultipleLinksFailed:
            return L10n.Shared.Persistence.Error.deleteMultipleLinksFailed
        case .deleteListFailed:
            return L10n.Shared.Persistence.Error.deleteListFailed
        case .saveChangesAfterDeletionFailed:
            return L10n.Shared.Persistence.Error.saveChangesAfterDeletionFailed
        case .pinListFailed:
            return L10n.Shared.Persistence.Error.pinListFailed
        case .unpinListFailed:
            return L10n.Shared.Persistence.Error.unpinListFailed
        case .saveLinkChangesFailed:
            return L10n.Shared.Persistence.Error.saveLinkChangesFailed
        case .saveListChangesFailed:
            return L10n.Shared.Persistence.Error.saveListChangesFailed
        }
    }

    public var recoverySuggestion: String? {
        return L10n.Shared.Persistence.Error.recoverySuggestion
    }

    var underlyingError: String {
        switch self {
        case let .saveLinkFailed(error),
            let .saveListFailed(error),
            let .deleteLinkFailed(error),
            let .deleteMultipleLinksFailed(error),
            let .deleteListFailed(error),
            let .saveChangesAfterDeletionFailed(error),
            let .pinListFailed(error),
            let .unpinListFailed(error),
            let .saveLinkChangesFailed(error),
            let .saveListChangesFailed(error):
            return error
        }
    }

    /// Non-localized description for logging purposes (always in English)
    public var description: String {
        switch self {
        case let .saveLinkFailed(error):
            return "Save link failed: \(error)"
        case let .saveListFailed(error):
            return "Save list failed: \(error)"
        case let .deleteLinkFailed(error):
            return "Delete link failed: \(error)"
        case let .deleteMultipleLinksFailed(error):
            return "Delete multiple links failed: \(error)"
        case let .deleteListFailed(error):
            return "Delete list failed: \(error)"
        case let .saveChangesAfterDeletionFailed(error):
            return "Save changes after deletion failed: \(error)"
        case let .pinListFailed(error):
            return "Pin list failed: \(error)"
        case let .unpinListFailed(error):
            return "Unpin list failed: \(error)"
        case let .saveLinkChangesFailed(error):
            return "Save link changes failed: \(error)"
        case let .saveListChangesFailed(error):
            return "Save list changes failed: \(error)"
        }
    }
}

extension PersistenceError: Equatable {
    public static func == (lhs: PersistenceError, rhs: PersistenceError) -> Bool {  // swiftlint:disable:this cyclomatic_complexity
        switch (lhs, rhs) {
        case let (.saveLinkFailed(lhsError), .saveLinkFailed(rhsError)):
            return lhsError == rhsError
        case let (.saveListFailed(lhsError), .saveListFailed(rhsError)):
            return lhsError == rhsError
        case let (.deleteLinkFailed(lhsError), .deleteLinkFailed(rhsError)):
            return lhsError == rhsError
        case let (.deleteMultipleLinksFailed(lhsError), .deleteMultipleLinksFailed(rhsError)):
            return lhsError == rhsError
        case let (.deleteListFailed(lhsError), .deleteListFailed(rhsError)):
            return lhsError == rhsError
        case let (.saveChangesAfterDeletionFailed(lhsError), .saveChangesAfterDeletionFailed(rhsError)):
            return lhsError == rhsError
        case let (.pinListFailed(lhsError), .pinListFailed(rhsError)):
            return lhsError == rhsError
        case let (.unpinListFailed(lhsError), .unpinListFailed(rhsError)):
            return lhsError == rhsError
        case let (.saveLinkChangesFailed(lhsError), .saveLinkChangesFailed(rhsError)):
            return lhsError == rhsError
        case let (.saveListChangesFailed(lhsError), .saveListChangesFailed(rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
