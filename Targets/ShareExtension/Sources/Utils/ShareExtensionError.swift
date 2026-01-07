import Foundation

enum ShareExtensionError: LocalizedError {
    case noValidURL

    var errorDescription: String? {
        switch self {
        case .noValidURL:
            return "No valid URL found in shared items"
        }
    }
}
