import XCTest
import SwiftData
@testable import Flinky

final class DataSeedingServiceTests: XCTestCase {
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!

    override func setUp() {
        super.setUp()

        // Create in-memory model container for testing
        let schema = Schema([
            LinkListModel.self,
            LinkModel.self,
            DatabaseMetadata.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Could not create test ModelContainer: \(error)")
        }
    }

    override func tearDown() {
        // Clean up
        modelContainer = nil
        modelContext = nil
        super.tearDown()
    }

    func testSeedDataIfNeeded_FirstTime_CreatesDataAndMetadata() throws {
        // When - Seed data for the first time
        DataSeedingService.seedDataIfNeeded(modelContext: modelContext)

        // Then - Verify data was created
        let listDescriptor = FetchDescriptor<LinkListModel>()
        let lists = try modelContext.fetch(listDescriptor)

        XCTAssertEqual(lists.count, 2) // "My Links" and "Favorites"

        // Check "My Links" list
        let myLinksList = lists.first { $0.name == "My Links" }
        XCTAssertNotNil(myLinksList)
        XCTAssertEqual(myLinksList?.links.count, 3)
        XCTAssertFalse(myLinksList?.isPinned ?? true)

        // Check "Favorites" list
        let favoritesList = lists.first { $0.name == "Favorites" }
        XCTAssertNotNil(favoritesList)
        XCTAssertEqual(favoritesList?.links.count, 1)
        XCTAssertTrue(favoritesList?.isPinned ?? false)
        XCTAssertEqual(favoritesList?.color, .yellow)
        XCTAssertEqual(favoritesList?.symbol, .communication(.star))

        // Verify metadata was created
        let metadataDescriptor = FetchDescriptor<DatabaseMetadata>()
        let metadata = try modelContext.fetch(metadataDescriptor)

        XCTAssertEqual(metadata.count, 1)
        XCTAssertTrue(metadata.first?.isDatabaseSeededMarker ?? false)
    }

    func testSeedDataIfNeeded_SecondTime_DoesNotCreateDuplicateData() throws {
        // Given - Database already seeded
        DataSeedingService.seedDataIfNeeded(modelContext: modelContext)

        // When - Try to seed again
        DataSeedingService.seedDataIfNeeded(modelContext: modelContext)

        // Then - Should not create duplicate data
        let listDescriptor = FetchDescriptor<LinkListModel>()
        let lists = try modelContext.fetch(listDescriptor)

        XCTAssertEqual(lists.count, 2) // Still just "My Links" and "Favorites"

        // Should still have only one metadata entry
        let metadataDescriptor = FetchDescriptor<DatabaseMetadata>()
        let metadata = try modelContext.fetch(metadataDescriptor)

        XCTAssertEqual(metadata.count, 1)
    }

    func testSeedInitialData_CreatesCorrectData() throws {
        // When - Seed initial data directly
        DataSeedingService.seedInitialData(modelContext: modelContext)

        // Then - Verify data was created
        let fetchDescriptor = FetchDescriptor<LinkListModel>()
        let lists = try modelContext.fetch(fetchDescriptor)

        XCTAssertEqual(lists.count, 2) // "My Links" and "Favorites"

        // Check "My Links" list
        let myLinksList = lists.first { $0.name == "My Links" }
        XCTAssertNotNil(myLinksList)
        XCTAssertEqual(myLinksList?.links.count, 3)
        XCTAssertFalse(myLinksList?.isPinned ?? true)

        // Check "Favorites" list
        let favoritesList = lists.first { $0.name == "Favorites" }
        XCTAssertNotNil(favoritesList)
        XCTAssertEqual(favoritesList?.links.count, 1)
        XCTAssertTrue(favoritesList?.isPinned ?? false)
        XCTAssertEqual(favoritesList?.color, .yellow)
        XCTAssertEqual(favoritesList?.symbol, .communication(.star))
    }

    func testMyLinksListContent() throws {
        // When - Seed data
        DataSeedingService.seedInitialData(modelContext: modelContext)

        // Then - Verify "My Links" has correct example links
        let fetchDescriptor = FetchDescriptor<LinkListModel>(
            predicate: #Predicate { list in list.name == "My Links" }
        )
        let myLinksList = try modelContext.fetch(fetchDescriptor).first

        XCTAssertNotNil(myLinksList)
        XCTAssertEqual(myLinksList?.links.count, 3)

        let linkNames = myLinksList?.links.map { $0.name }.sorted() ?? []
        XCTAssertEqual(linkNames, ["Apple", "GitHub", "Wikipedia"])

        // Check specific links
        if let appleLink = myLinksList?.links.first(where: { $0.name == "Apple" }) {
            XCTAssertEqual(appleLink.url.absoluteString, "https://apple.com")
            XCTAssertEqual(appleLink.color, .gray)
        } else {
            XCTFail("Apple link not found")
        }

        if let wikipediaLink = myLinksList?.links.first(where: { $0.name == "Wikipedia" }) {
            XCTAssertEqual(wikipediaLink.url.absoluteString, "https://wikipedia.org")
            XCTAssertEqual(wikipediaLink.color, .blue)
        } else {
            XCTFail("Wikipedia link not found")
        }

        if let githubLink = myLinksList?.links.first(where: { $0.name == "GitHub" }) {
            XCTAssertEqual(githubLink.url.absoluteString, "https://github.com")
            XCTAssertEqual(githubLink.color, .purple)
        } else {
            XCTFail("GitHub link not found")
        }
    }

    func testFavoritesListContent() throws {
        // When - Seed data
        DataSeedingService.seedInitialData(modelContext: modelContext)

        // Then - Verify "Favorites" has correct content
        let fetchDescriptor = FetchDescriptor<LinkListModel>(
            predicate: #Predicate { list in list.name == "Favorites" }
        )
        let favoritesList = try modelContext.fetch(fetchDescriptor).first

        XCTAssertNotNil(favoritesList)
        XCTAssertEqual(favoritesList?.links.count, 1)
        XCTAssertEqual(favoritesList?.color, .yellow)
        XCTAssertEqual(favoritesList?.symbol, .communication(.star))
        XCTAssertTrue(favoritesList?.isPinned ?? false)

        // Check the Swift.org link
        if let swiftLink = favoritesList?.links.first {
            XCTAssertEqual(swiftLink.name, "Swift.org")
            XCTAssertEqual(swiftLink.url.absoluteString, "https://swift.org")
            XCTAssertEqual(swiftLink.color, .orange)
            XCTAssertEqual(swiftLink.symbol, .communication(.star))
        } else {
            XCTFail("Swift.org link not found in Favorites")
        }
    }
}

// MARK: - DatabaseMetadata Tests
extension DataSeedingServiceTests {
    func testDatabaseMetadata_CreateSeededMarker() {
        // When - Create a seeded marker
        let marker = DatabaseMetadata.createSeededMarker()

        // Then - Should have correct properties
        XCTAssertEqual(marker.key, DatabaseMetadata.databaseSeededKey)
        XCTAssertEqual(marker.value, "true")
        XCTAssertTrue(marker.isDatabaseSeededMarker)
    }

    func testDatabaseMetadata_UpdateValue() {
        // Given - A metadata entry
        let metadata = DatabaseMetadata(key: "test_key", value: "old_value")
        let originalUpdatedAt = metadata.updatedAt

        // Wait a tiny bit to ensure timestamp difference
        usleep(1000) // 1ms

        // When - Update the value
        metadata.updateValue("new_value")

        // Then - Should have updated value and timestamp
        XCTAssertEqual(metadata.value, "new_value")
        XCTAssertGreaterThan(metadata.updatedAt, originalUpdatedAt)
    }

    func testDatabaseMetadata_IsDatabaseSeededMarker() {
        // Given - Various metadata entries
        let seededMarker = DatabaseMetadata.createSeededMarker()
        let otherMarker = DatabaseMetadata(key: "other_key", value: "true")
        let wrongValue = DatabaseMetadata(key: DatabaseMetadata.databaseSeededKey, value: "false")

        // Then - Only the correct one should be identified as seeded marker
        XCTAssertTrue(seededMarker.isDatabaseSeededMarker)
        XCTAssertFalse(otherMarker.isDatabaseSeededMarker)
        XCTAssertFalse(wrongValue.isDatabaseSeededMarker)
    }
}
