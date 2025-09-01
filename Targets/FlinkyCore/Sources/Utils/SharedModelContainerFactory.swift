import Foundation
import SwiftData

public enum SharedModelContainerFactory {
    /// Creates a SwiftData ModelContainer stored in the shared App Group so the app and extensions use the same store.
    /// - Parameter appGroupId: The App Group identifier. Keep this in sync in both targets' entitlements.
    /// - Returns: Configured ModelContainer
    public static func make(appGroupId: String = "group.com.techprimate.Flinky") throws -> ModelContainer {
        let schema = Schema([
            LinkListModel.self,
            LinkModel.self,
            DatabaseMetadata.self
        ])

        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) else {
            throw NSError(domain: "Flinky", code: 1, userInfo: [NSLocalizedDescriptionKey: "App Group container URL not found for \(appGroupId)"])
        }

        // iOS 18+: use groupContainer to co-locate the store in the App Group container
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true,
            groupContainer: .identifier(appGroupId),
            cloudKitDatabase: .none
        )

        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
