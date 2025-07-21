import XCTest
import UIKit
@testable import Flinky

final class QRCodeCacheTests: XCTestCase {
    
    var cache: QRCodeCache!

    override func setUpWithError() throws {
        cache = QRCodeCache()
    }

    override func tearDownWithError() throws {
        cache.clearCache()
        cache = nil
    }

    func testCacheImageAndRetrieve() throws {
        // Given
        let content = "https://example.com"
        let testImage = UIImage(systemName: "star")!
        
        // Initially should be nil
        XCTAssertNil(cache.image(forContent: content))
        
        // When
        cache.setImage(testImage, forContent: content)
        
        // Then
        let retrievedImage = cache.image(forContent: content)
        XCTAssertNotNil(retrievedImage)
        XCTAssertEqual(retrievedImage, testImage)
    }
    
    func testCacheImageDifferentContent() throws {
        // Given
        let content1 = "https://example.com"
        let content2 = "https://different.com"
        let testImage1 = UIImage(systemName: "star")!
        let testImage2 = UIImage(systemName: "heart")!
        
        // When
        cache.setImage(testImage1, forContent: content1)
        cache.setImage(testImage2, forContent: content2)
        
        // Then
        XCTAssertEqual(cache.image(forContent: content1), testImage1)
        XCTAssertEqual(cache.image(forContent: content2), testImage2)
        XCTAssertNotEqual(cache.image(forContent: content1), testImage2)
    }
    
    func testClearCache() throws {
        // Given
        let content = "https://example.com"
        let testImage = UIImage(systemName: "star")!
        cache.setImage(testImage, forContent: content)
        
        // Verify it's cached
        XCTAssertNotNil(cache.image(forContent: content))
        
        // When
        cache.clearCache()
        
        // Then
        XCTAssertNil(cache.image(forContent: content))
    }
    
    func testCacheConfiguration() throws {
        // Test that cache info returns expected values
        let info = cache.cacheInfo
        XCTAssertEqual(info.count, 100) // maxCacheSize
        XCTAssertEqual(info.totalCost, 50 * 1024 * 1024) // maxMemoryUsage
    }
    
    func testImageMemoryEstimation() throws {
        // This is testing the private method indirectly through caching behavior
        // Given a known image size
        let size = CGSize(width: 100, height: 100)
        let testImage = createTestImage(size: size)
        let content = "test"
        
        // When
        cache.setImage(testImage, forContent: content)
        
        // Then - should be cached without issues (no crash)
        XCTAssertNotNil(cache.image(forContent: content))
    }
    
    private func createTestImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
} 