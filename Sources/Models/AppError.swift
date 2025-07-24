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
        case .dataCorruption(let message):
            return L10n.Shared.Error.DataCorruption.description(message)
        case .networkError(let message):
            return L10n.Shared.Error.Network.description(message)
        case .validationError(let message):
            return L10n.Shared.Error.Validation.description(message)
        case .persistenceError(let persistenceError):
            return persistenceError.errorDescription
        case .qrCodeGenerationError(let message):
            return L10n.Shared.Error.QrCode.description(message)
        case .failedToGenerateQRCode(let reason):
            return L10n.Shared.Error.QrCode.description(reason.localizedDescription)
        case .failedToOpenURL(let url):
            return L10n.Shared.Error.FailedToOpenUrl.description(url.absoluteString)
        case .nfcError(let message):
            return L10n.Shared.Error.Nfc.description(message)
        case .unknownError(let message):
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
        case .persistenceError(let persistenceError):
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
        case .failedToGenerateQRCode(let reason):
            return "Failed to generate QR code: \(reason.localizedDescription)"
        case .failedToOpenURL(let url):
            return "Failed to open url: \(url)"
        case .nfcError(let message):
            return "NFC error: \(message)"
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
                .nfcError(let message),
                .unknownError(let message):
            return "\(self)_\(message)"
        case .persistenceError(let persistenceError):
            return "\(self)_\(persistenceError.underlyingError)"
        case .failedToGenerateQRCode(let reason):
            return "\(self)_\(reason.localizedDescription)"
        case .failedToOpenURL(let url):
            return "\(self)_\(url)"
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
        case (.failedToGenerateQRCode(let lhsReason), .failedToGenerateQRCode(let rhsReason)):
            return lhsReason.localizedDescription == rhsReason.localizedDescription
        case (.failedToOpenURL(let lhsURL), .failedToOpenURL(let rhsURL)):
            return lhsURL == rhsURL
        case (.nfcError(let lhsMessage), .nfcError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.unknownError(let lhsMessage), .unknownError(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
    

} 
