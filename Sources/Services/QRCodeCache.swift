import Foundation
import UIKit
import os.log

class QRCodeCache: NSObject {
    private static let logger = Logger.forType(QRCodeCache.self)

    private let storage = NSCache<NSString, UIImage>()

    // Cache configuration
    private let maxCacheSize: Int = 100 // Maximum number of cached QR codes
    private let maxMemoryUsage: Int = 50 * 1024 * 1024 // 50MB maximum memory usage
    
    override init() {
        super.init()
        configureCache()
        setupMemoryWarningObserver()
    }
    
    private func configureCache() {
        storage.countLimit = maxCacheSize
        storage.totalCostLimit = maxMemoryUsage
        
        // Set delegate to handle eviction
        storage.delegate = self
        
        Self.logger.info("QR Code cache configured with max size: \(self.maxCacheSize), max memory: \(self.maxMemoryUsage) bytes")
    }
    
    private func setupMemoryWarningObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    @objc private func handleMemoryWarning() {
        Self.logger.warning("Received memory warning, clearing QR code cache")
        clearCache()
    }
    
    func image(forContent content: String) -> UIImage? {
        let key = NSString(string: content)
        let image = storage.object(forKey: key)
        
        if image != nil {
            Self.logger.debug("QR code cache hit for content")
        } else {
            Self.logger.debug("QR code cache miss for content")
        }
        
        return image
    }

    func setImage(_ image: UIImage, forContent content: String) {
        let key = NSString(string: content)
        
        // Calculate approximate memory cost
        let cost = estimateImageMemoryUsage(image)
        
        storage.setObject(image, forKey: key, cost: cost)
        Self.logger.debug("Cached QR code with estimated cost: \(cost) bytes")
    }
    
    private func estimateImageMemoryUsage(_ image: UIImage) -> Int {
        guard let cgImage = image.cgImage else { return 0 }
        let bytesPerPixel = 4 // RGBA
        return cgImage.width * cgImage.height * bytesPerPixel
    }
    
    func clearCache() {
        storage.removeAllObjects()
        Self.logger.info("QR code cache cleared")
    }
    
    var cacheInfo: (count: Int, totalCost: Int) {
        return (storage.countLimit, storage.totalCostLimit)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - NSCacheDelegate
extension QRCodeCache: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        Self.logger.debug("QR code cache evicting object due to memory pressure")
    }
}
