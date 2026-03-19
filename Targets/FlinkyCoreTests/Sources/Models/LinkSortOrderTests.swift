import XCTest
@testable import FlinkyCore

final class LinkSortOrderTests: XCTestCase {

    // MARK: - Raw Values

    func testRawValues() {
        XCTAssertEqual(LinkSortOrder.nameAscending.rawValue, "nameAscending")
        XCTAssertEqual(LinkSortOrder.nameDescending.rawValue, "nameDescending")
        XCTAssertEqual(LinkSortOrder.createdAtNewest.rawValue, "createdAtNewest")
        XCTAssertEqual(LinkSortOrder.createdAtOldest.rawValue, "createdAtOldest")
        XCTAssertEqual(LinkSortOrder.updatedAtNewest.rawValue, "updatedAtNewest")
        XCTAssertEqual(LinkSortOrder.updatedAtOldest.rawValue, "updatedAtOldest")
    }

    func testAllCasesCount() {
        XCTAssertEqual(LinkSortOrder.allCases.count, 6)
    }

    func testDefaultSortOrder() {
        XCTAssertEqual(LinkSortOrder.default, .nameAscending)
    }

    func testIdentifiable() {
        for sortOrder in LinkSortOrder.allCases {
            XCTAssertEqual(sortOrder.id, sortOrder.rawValue)
        }
    }

    // MARK: - Codable

    func testEncodable() throws {
        let encoder = JSONEncoder()
        for sortOrder in LinkSortOrder.allCases {
            let data = try encoder.encode(sortOrder)
            let string = String(data: data, encoding: .utf8)
            XCTAssertEqual(string, "\"\(sortOrder.rawValue)\"")
        }
    }

    func testDecodable() throws {
        let decoder = JSONDecoder()
        for sortOrder in LinkSortOrder.allCases {
            let json = "\"\(sortOrder.rawValue)\""
            let data = json.data(using: .utf8)!
            let decoded = try decoder.decode(LinkSortOrder.self, from: data)
            XCTAssertEqual(decoded, sortOrder)
        }
    }

    // MARK: - Sorting Behavior

    func testSortByNameAscending() {
        // Given
        let links = createTestLinks()

        // When
        let sorted = LinkSortOrder.nameAscending.sorted(links)

        // Then
        XCTAssertEqual(sorted.map(\.name), ["Alpha", "Beta", "Gamma"])
    }

    func testSortByNameDescending() {
        // Given
        let links = createTestLinks()

        // When
        let sorted = LinkSortOrder.nameDescending.sorted(links)

        // Then
        XCTAssertEqual(sorted.map(\.name), ["Gamma", "Beta", "Alpha"])
    }

    func testSortByNameCaseInsensitive() {
        // Given
        let link1 = LinkModel(name: "apple", url: URL(string: "https://a.com")!)
        let link2 = LinkModel(name: "Banana", url: URL(string: "https://b.com")!)
        let link3 = LinkModel(name: "CHERRY", url: URL(string: "https://c.com")!)
        let links = [link2, link3, link1]

        // When
        let sorted = LinkSortOrder.nameAscending.sorted(links)

        // Then
        XCTAssertEqual(sorted.map(\.name), ["apple", "Banana", "CHERRY"])
    }

    func testSortByCreatedAtNewest() {
        // Given
        let links = createTestLinksWithDates()

        // When
        let sorted = LinkSortOrder.createdAtNewest.sorted(links)

        // Then
        XCTAssertEqual(sorted.map(\.name), ["Gamma", "Beta", "Alpha"])
    }

    func testSortByCreatedAtOldest() {
        // Given
        let links = createTestLinksWithDates()

        // When
        let sorted = LinkSortOrder.createdAtOldest.sorted(links)

        // Then
        XCTAssertEqual(sorted.map(\.name), ["Alpha", "Beta", "Gamma"])
    }

    func testSortByUpdatedAtNewest() {
        // Given
        let links = createTestLinksWithDifferentUpdateDates()

        // When
        let sorted = LinkSortOrder.updatedAtNewest.sorted(links)

        // Then
        XCTAssertEqual(sorted.map(\.name), ["Alpha", "Gamma", "Beta"])
    }

    func testSortByUpdatedAtOldest() {
        // Given
        let links = createTestLinksWithDifferentUpdateDates()

        // When
        let sorted = LinkSortOrder.updatedAtOldest.sorted(links)

        // Then
        XCTAssertEqual(sorted.map(\.name), ["Beta", "Gamma", "Alpha"])
    }

    func testSortEmptyArray() {
        // Given
        let links: [LinkModel] = []

        // When/Then
        for sortOrder in LinkSortOrder.allCases {
            let sorted = sortOrder.sorted(links)
            XCTAssertTrue(sorted.isEmpty)
        }
    }

    func testSortSingleElement() {
        // Given
        let link = LinkModel(name: "Solo", url: URL(string: "https://solo.com")!)
        let links = [link]

        // When/Then
        for sortOrder in LinkSortOrder.allCases {
            let sorted = sortOrder.sorted(links)
            XCTAssertEqual(sorted.count, 1)
            XCTAssertEqual(sorted.first?.name, "Solo")
        }
    }

    // MARK: - Helpers

    private func createTestLinks() -> [LinkModel] {
        let link1 = LinkModel(name: "Beta", url: URL(string: "https://beta.com")!)
        let link2 = LinkModel(name: "Alpha", url: URL(string: "https://alpha.com")!)
        let link3 = LinkModel(name: "Gamma", url: URL(string: "https://gamma.com")!)
        return [link1, link2, link3]
    }

    private func createTestLinksWithDates() -> [LinkModel] {
        let now = Date()
        let oneHourAgo = now.addingTimeInterval(-3600)
        let twoHoursAgo = now.addingTimeInterval(-7200)

        let link1 = LinkModel(
            id: UUID(),
            createdAt: twoHoursAgo,
            updatedAt: twoHoursAgo,
            name: "Alpha",
            color: nil,
            symbol: nil,
            url: URL(string: "https://alpha.com")!
        )
        let link2 = LinkModel(
            id: UUID(),
            createdAt: oneHourAgo,
            updatedAt: oneHourAgo,
            name: "Beta",
            color: nil,
            symbol: nil,
            url: URL(string: "https://beta.com")!
        )
        let link3 = LinkModel(
            id: UUID(),
            createdAt: now,
            updatedAt: now,
            name: "Gamma",
            color: nil,
            symbol: nil,
            url: URL(string: "https://gamma.com")!
        )
        return [link1, link2, link3]
    }

    private func createTestLinksWithDifferentUpdateDates() -> [LinkModel] {
        let now = Date()
        let oneHourAgo = now.addingTimeInterval(-3600)
        let twoHoursAgo = now.addingTimeInterval(-7200)
        let threeHoursAgo = now.addingTimeInterval(-10800)

        // Alpha: created 3 hours ago, updated now (most recent update)
        let link1 = LinkModel(
            id: UUID(),
            createdAt: threeHoursAgo,
            updatedAt: now,
            name: "Alpha",
            color: nil,
            symbol: nil,
            url: URL(string: "https://alpha.com")!
        )
        // Beta: created 2 hours ago, updated 2 hours ago (oldest update)
        let link2 = LinkModel(
            id: UUID(),
            createdAt: twoHoursAgo,
            updatedAt: twoHoursAgo,
            name: "Beta",
            color: nil,
            symbol: nil,
            url: URL(string: "https://beta.com")!
        )
        // Gamma: created 1 hour ago, updated 1 hour ago (middle update)
        let link3 = LinkModel(
            id: UUID(),
            createdAt: oneHourAgo,
            updatedAt: oneHourAgo,
            name: "Gamma",
            color: nil,
            symbol: nil,
            url: URL(string: "https://gamma.com")!
        )
        return [link1, link2, link3]
    }
}
