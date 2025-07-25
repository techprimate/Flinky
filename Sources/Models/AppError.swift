import Foundation

/// Application-specific error types
enum AppError: LocalizedError, CustomStringConvertible {
    case dataCorruption(String)
    case networkError(String)
    case validationError(String)
    case persistenceError(PersistenceError)
    case qrCodeGenerationError(String)
    case failedToGenerateQRCode(reason: Error)
    case failedToOpenURL(URL)
    case nfcError(String)
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case let .dataCorruption(message):
            return L10n.Shared.Error.DataCorruption.description(message)
        case let .networkError(message):
            return L10n.Shared.Error.Network.description(message)
        case let .validationError(message):
            return L10n.Shared.Error.Validation.description(message)
        case let .persistenceError(persistenceError):
            return persistenceError.errorDescription
        case let .qrCodeGenerationError(message):
            return L10n.Shared.Error.QrCode.description(message)
        case let .failedToGenerateQRCode(reason):
            return L10n.Shared.Error.QrCode.description(reason.localizedDescription)
        case let .failedToOpenURL(url):
            return L10n.Shared.Error.FailedToOpenUrl.description(url.absoluteString)
        case let .nfcError(message):
            return L10n.Shared.Error.Nfc.description(message)
        case let .unknownError(message):
            return L10n.Shared.Error.Unknown.description(message)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .dataCorruption:
            return L10n.Shared.Error.Recovery.dataCorruption
        case .networkError:
            return L10n.Shared.Error.Recovery.network
        case .validationError:
            return L10n.Shared.Error.Recovery.validation
        case let .persistenceError(persistenceError):
            return persistenceError.recoverySuggestion
        case .qrCodeGenerationError, .failedToGenerateQRCode:
            return L10n.Shared.Error.Recovery.qrCode
        case .failedToOpenURL:
            return L10n.Shared.Error.FailedToOpenUrl.recoverySuggestion
        case .nfcError:
            return L10n.Shared.Error.Recovery.nfc
        case .unknownError:
            return L10n.Shared.Error.Recovery.unknown
        }
    }

    /// Non-localized description for logging purposes (always in English)
    var description: String {
        switch self {
        case let .dataCorruption(message):
            return "Data corruption: \(message)"
        case let .networkError(message):
            return "Network error: \(message)"
        case let .validationError(message):
            return "Validation error: \(message)"
        case let .persistenceError(persistenceError):
            return persistenceError.description
        case let .qrCodeGenerationError(message):
            return "QR code generation error: \(message)"
        case let .failedToGenerateQRCode(reason):
            return "Failed to generate QR code: \(reason.localizedDescription)"
        case let .failedToOpenURL(url):
            return "Failed to open url: \(url)"
        case let .nfcError(message):
            return "NFC error: \(message)"
        case let .unknownError(message):
            return "Unknown error: \(message)"
        }
    }
}

extension AppError: Identifiable {
    var id: String {
        switch self {
        case let .dataCorruption(message),
             let .networkError(message),
             let .validationError(message),
             let .qrCodeGenerationError(message),
             let .nfcError(message),
             let .unknownError(message):
            return "\(self)_\(message)"
        case let .persistenceError(persistenceError):
            return "\(self)_\(persistenceError.underlyingError)"
        case let .failedToGenerateQRCode(reason):
            return "\(self)_\(reason.localizedDescription)"
        case let .failedToOpenURL(url):
            return "\(self)_\(url)"
        }
    }
}

extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case let (.dataCorruption(lhsMessage), .dataCorruption(rhsMessage)):
            return lhsMessage == rhsMessage
        case let (.networkError(lhsMessage), .networkError(rhsMessage)):
            return lhsMessage == rhsMessage
        case let (.validationError(lhsMessage), .validationError(rhsMessage)):
            return lhsMessage == rhsMessage
        case let (.persistenceError(lhsError), .persistenceError(rhsError)):
            return lhsError == rhsError
        case let (.qrCodeGenerationError(lhsMessage), .qrCodeGenerationError(rhsMessage)):
            return lhsMessage == rhsMessage
        case let (.failedToGenerateQRCode(lhsReason), .failedToGenerateQRCode(rhsReason)):
            return lhsReason.localizedDescription == rhsReason.localizedDescription
        case let (.failedToOpenURL(lhsURL), .failedToOpenURL(rhsURL)):
            return lhsURL == rhsURL
        case let (.nfcError(lhsMessage), .nfcError(rhsMessage)):
            return lhsMessage == rhsMessage
        case let (.unknownError(lhsMessage), .unknownError(rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
