import XCTest
import SwiftData
@testable import FlinkyCore

@MainActor
final class LinkModelTests: XCTestCase {

    func testLinkModelInitialization() throws {
        // Given
        let id = UUID()
        let createdAt = Date()
        let updatedAt = Date()
        let name = "Test Link"
        let url = URL(string: "https://example.com")!
        let color = ListColor.blue
        let symbol = ListSymbol.object(.archiveBox)

        // When
        let link = LinkModel(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            name: name,
            color: color,
            symbol: symbol,
            url: url
        )

        // Then
        XCTAssertEqual(link.id, id)
        XCTAssertEqual(link.createdAt, createdAt)
        XCTAssertEqual(link.updatedAt, updatedAt)
        XCTAssertEqual(link.name, name)
        XCTAssertEqual(link.url, url)
        XCTAssertEqual(link.color, color)
        XCTAssertEqual(link.symbol, symbol)
    }

    func testLinkModelConvenienceInitializer() throws {
        // Given
        let name = "Test Link"
        let url = URL(string: "https://example.com")!
        let color = ListColor.red
        let symbol = ListSymbol.communication(.star)

        // When
        let link = LinkModel(name: name, url: url, color: color, symbol: symbol)

        // Then
        XCTAssertEqual(link.name, name)
        XCTAssertEqual(link.url, url)
        XCTAssertEqual(link.color, color)
        XCTAssertEqual(link.symbol, symbol)
        XCTAssertNotNil(link.id)
        XCTAssertNotNil(link.createdAt)
        XCTAssertNotNil(link.updatedAt)
    }

    func testLinkModelConvenienceInitializerWithDefaults() throws {
        // Given
        let name = "Test Link"
        let url = URL(string: "https://example.com")!

        // When
        let link = LinkModel(name: name, url: url)

        // Then
        XCTAssertEqual(link.name, name)
        XCTAssertEqual(link.url, url)
        XCTAssertNil(link.color)
        XCTAssertNil(link.symbol)
        XCTAssertNotNil(link.id)
        XCTAssertNotNil(link.createdAt)
        XCTAssertNotNil(link.updatedAt)
    }
}
