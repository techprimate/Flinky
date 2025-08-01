import Foundation
import SwiftData

/// Model for storing database metadata and configuration information
@Model
final class DatabaseMetadata {
    /// Unique identifier for the metadata entry
    var id: UUID

    /// The key for this metadata entry
    var key: String

    /// The value for this metadata entry
    var value: String

    /// Date when this metadata was created
    var createdAt: Date

    /// Date when this metadata was last updated
    var updatedAt: Date

    // MARK: - Initialization

    /// Initializes a new instance of `DatabaseMetadata`.
    ///
    /// - Parameters:
    ///   - key: The key for this metadata entry
    ///   - value: The value for this metadata entry
    init(createdAt: Date = Date(), updatedAt: Date = Date(), key: String, value: String) {
        self.id = UUID()
        self.key = key
        self.value = value
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // MARK: - Instance Methods

    /// Updates the value and timestamp of this metadata entry
    ///
    /// - Parameter newValue: The new value to set
    func updateValue(_ newValue: String) {
        self.value = newValue
        self.updatedAt = Date()
    }
}

// MARK: - Database Seeding Support
extension DatabaseMetadata {
    /// Standard key for tracking if the database has been seeded
    static let databaseSeededKey = "database_seeded"

    /// Standard value indicating the database has been seeded
    private static let seededValue = "true"

    /// Creates a metadata entry marking the database as seeded
    /// - Returns: A new DatabaseMetadata instance configured as a seeded marker
    static func createSeededMarker() -> DatabaseMetadata {
        return DatabaseMetadata(key: databaseSeededKey, value: seededValue)
    }

    /// Checks if this metadata entry indicates the database has been seeded
    /// - Returns: True if this is a valid database seeded marker
    var isDatabaseSeededMarker: Bool {
        return key == Self.databaseSeededKey && value == Self.seededValue
    }
}
