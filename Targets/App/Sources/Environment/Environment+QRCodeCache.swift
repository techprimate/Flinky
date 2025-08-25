import SwiftUI

extension EnvironmentValues {
    var qrcodeCache: QRCodeCache {
        get { self[QRCodeCacheKey.self] }
        set { self[QRCodeCacheKey.self] = newValue }
    }

    private struct QRCodeCacheKey: EnvironmentKey {
        static let defaultValue = QRCodeCache()
    }
}
