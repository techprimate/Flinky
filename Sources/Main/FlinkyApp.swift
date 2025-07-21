import Sentry
import SwiftData
import SwiftUI

@main
struct FlinkyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LinkListModel.self,
            LinkModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        #if DEBUG
            print("Sentry is disabled in debug mode")
        #else
            SentrySDK.start { options in
                options.dsn = "https://f371822cfa840de0c6a27a788a5fa48e@o188824.ingest.us.sentry.io/4509640637349888"

                options.sendDefaultPii = true
                options.tracesSampleRate = 1.0

                options.sessionReplay.onErrorSampleRate = 1.0
                options.sessionReplay.sessionSampleRate = 0.1
            }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            MainContainerView()
        }
        .modelContainer(sharedModelContainer)
    }
}
