import Foundation
import SwiftData

public enum SharedModelContainerFactory {
    /// Creates a SwiftData ModelContainer stored in the shared App Group so the app and extensions use the same store.
    /// - Parameter appGroupId: The App Group identifier. Keep this in sync in both targets' entitlements.
    /// - Parameter isStoredInMemoryOnly: Set to `true` to use the in-memory storage only. Used for testing.
    /// - Returns: Configured ModelContainer
    public static func make(appGroupId: String = "group.com.techprimate.Flinky", isStoredInMemoryOnly: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            LinkListModel.self,
            LinkModel.self,
            DatabaseMetadata.self
        ])

        // iOS 18+: use groupContainer to co-locate the store in the App Group container
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly,
            allowsSave: true,
            groupContainer: .identifier(appGroupId),
            cloudKitDatabase: .none
        )

        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
