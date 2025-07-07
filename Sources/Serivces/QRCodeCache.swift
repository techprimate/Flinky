import Foundation
import UIKit

class QRCodeCache {
    private let storage = NSCache<NSString, UIImage>()

    func image(forContent content: String) -> UIImage? {
        return storage.object(forKey: NSString(string: content))
    }

    func setImage(_ image: UIImage, forContent content: String) {
        storage.setObject(image, forKey: NSString(string: content))
    }
}
