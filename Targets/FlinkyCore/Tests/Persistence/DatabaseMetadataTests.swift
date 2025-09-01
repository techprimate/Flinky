import XCTest
import SwiftData
@testable import FlinkyCore

final class DatabaseMetadataTests: XCTestCase {
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!

    override func setUp() {
        super.setUp()

        // Create in-memory model container for testing
        let schema = Schema([DatabaseMetadata.self])
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

    func testDatabaseMetadata_Initialization() {
        // When - Create a metadata entry
        let metadata = DatabaseMetadata(key: "test_key", value: "test_value")

        // Then - Should have correct initial values
        XCTAssertNotNil(metadata.id)
        XCTAssertEqual(metadata.key, "test_key")
        XCTAssertEqual(metadata.value, "test_value")
        XCTAssertNotNil(metadata.createdAt)
        XCTAssertNotNil(metadata.updatedAt)
        XCTAssertEqual(metadata.createdAt, metadata.updatedAt) // Should be equal on creation
    }

    func testDatabaseMetadata_Persistence() throws {
        // Given - A metadata entry
        let metadata = DatabaseMetadata(key: "persistence_test", value: "test_value")
        modelContext.insert(metadata)

        // When - Save and fetch
        try modelContext.save()

        let fetchDescriptor = FetchDescriptor<DatabaseMetadata>(
            predicate: #Predicate { meta in meta.key == "persistence_test" }
        )
        let fetchedMetadata = try modelContext.fetch(fetchDescriptor)

        // Then - Should persist correctly
        XCTAssertEqual(fetchedMetadata.count, 1)
        XCTAssertEqual(fetchedMetadata.first?.key, "persistence_test")
        XCTAssertEqual(fetchedMetadata.first?.value, "test_value")
    }

    func testDatabaseMetadata_SeededMarkerConstants() {
        // Then - Constants should be defined correctly
        XCTAssertEqual(DatabaseMetadata.databaseSeededKey, "database_seeded")

        // When - Create seeded marker
        let marker = DatabaseMetadata.createSeededMarker()

        // Then - Should use correct constants
        XCTAssertEqual(marker.key, DatabaseMetadata.databaseSeededKey)
        XCTAssertEqual(marker.value, "true")
    }

    func testDatabaseMetadata_SeededMarkerDetection() {
        // Given - Different types of metadata
        let seededMarker = DatabaseMetadata.createSeededMarker()
        let otherMetadata = DatabaseMetadata(key: "other", value: "true")
        let similarKey = DatabaseMetadata(key: DatabaseMetadata.databaseSeededKey, value: "false")

        // Then - Only the correct marker should be identified
        XCTAssertTrue(seededMarker.isDatabaseSeededMarker)
        XCTAssertFalse(otherMetadata.isDatabaseSeededMarker)
        XCTAssertFalse(similarKey.isDatabaseSeededMarker)
    }

    func testDatabaseMetadata_UpdateValueChangesTimestamp() {
        // Given - A metadata entry
        let metadata = DatabaseMetadata(key: "update_test", value: "original")
        let originalTimestamp = metadata.updatedAt

        // Wait to ensure timestamp difference
        // We can not mock the current time, so we must fall back to `usleep`
        usleep(100 * 1000) // 100ms

        // When - Update the value
        metadata.updateValue("updated")

        // Then - Should update value and timestamp
        XCTAssertEqual(metadata.value, "updated")
        XCTAssertGreaterThan(metadata.updatedAt, originalTimestamp)
        XCTAssertEqual(metadata.createdAt, originalTimestamp) // Created date should not change
    }
}
