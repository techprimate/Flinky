import SwiftUI
import SwiftData

@main
struct FlinkyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LinkListModel.self,
            LinkModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainContainerView()
        }
        .modelContainer(sharedModelContainer)
    }
}
