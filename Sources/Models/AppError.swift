import Foundation

/// Application-specific error types
enum AppError: LocalizedError, CustomStringConvertible {
    case dataCorruption(String)
    case networkError(String)
    case validationError(String)
    case persistenceError(PersistenceError)
    case qrCodeGenerationError(String)
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .dataCorruption(let message):
            return L10n.Error.dataCorruption(message)
        case .networkError(let message):
            return L10n.Error.network(message)
        case .validationError(let message):
            return L10n.Error.validation(message)
        case .persistenceError(let persistenceError):
            return persistenceError.errorDescription
        case .qrCodeGenerationError(let message):
            return L10n.Error.qrCode(message)
        case .unknownError(let message):
            return L10n.Error.unknown(message)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .dataCorruption:
            return L10n.Error.Recovery.dataCorruption
        case .networkError:
            return L10n.Error.Recovery.network
        case .validationError:
            return L10n.Error.Recovery.validation
        case .persistenceError(let persistenceError):
            return persistenceError.recoverySuggestion
        case .qrCodeGenerationError:
            return L10n.Error.Recovery.qrCode
        case .unknownError:
            return L10n.Error.Recovery.unknown
        }
    }
    
    /// Non-localized description for logging purposes (always in English)
    var description: String {
        switch self {
        case .dataCorruption(let message):
            return "Data corruption: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .validationError(let message):
            return "Validation error: \(message)"
        case .persistenceError(let persistenceError):
            return persistenceError.description
        case .qrCodeGenerationError(let message):
            return "QR code generation error: \(message)"
        case .unknownError(let message):
            return "Unknown error: \(message)"
        }
    }
}

extension AppError: Identifiable {
    var id: String {
        switch self {
        case .dataCorruption(let message),
                .networkError(let message),
                .validationError(let message),
                .qrCodeGenerationError(let message),
                .unknownError(let message):
            return "\(self)_\(message)"
        case .persistenceError(let persistenceError):
            return "\(self)_\(persistenceError.underlyingError)"
        }
    }
}

extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.dataCorruption(let lhsMessage), .dataCorruption(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.networkError(let lhsMessage), .networkError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.validationError(let lhsMessage), .validationError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.persistenceError(let lhsError), .persistenceError(let rhsError)):
            return lhsError == rhsError
        case (.qrCodeGenerationError(let lhsMessage), .qrCodeGenerationError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.unknownError(let lhsMessage), .unknownError(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
    

} 
