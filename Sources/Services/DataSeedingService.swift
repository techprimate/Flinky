import Foundation
import Sentry
import SwiftData
import os.log

/// Service responsible for pre-seeding data on first app launch
class DataSeedingService {
    private static let logger = Logger.forType(DataSeedingService.self)
    private static let firstLaunchKey = "hasCompletedFirstLaunch"

    /// Checks if this is the first app launch and seeds data if needed
    /// - Parameter modelContext: SwiftData model context to use for data operations
    /// - Returns: The ID of the "My Links" list if data was seeded, nil otherwise
    static func seedDataIfFirstLaunch(modelContext: ModelContext) -> UUID? {
        let defaults = UserDefaults.standard
        let hasCompletedFirstLaunch = defaults.bool(forKey: firstLaunchKey)

        if !hasCompletedFirstLaunch {
            logger.info("First app launch detected, seeding initial data")
            let myLinksListId = seedInitialData(modelContext: modelContext)

            // Mark first launch as completed
            defaults.set(true, forKey: firstLaunchKey)

            return myLinksListId
        }

        return nil
    }

    /// Seeds the initial data for first launch
    /// - Parameter modelContext: SwiftData model context to use for data operations
    /// - Returns: The ID of the "My Links" list
    private static func seedInitialData(modelContext: ModelContext) -> UUID {
        // Create "My Links" list with 3 common links
        let myLinksList = createMyLinksList()
        modelContext.insert(myLinksList)

        // Create "Favorites" list with yellow color, star symbol, pinned, and 1 link
        let favoritesList = createFavoritesList()
        modelContext.insert(favoritesList)

        // Save the context
        do {
            try modelContext.save()
            logger.info("Successfully seeded initial data")
        } catch {
            logger.error("Failed to save seeded data: \(error)")
            let appError = AppError.persistenceError(.saveListFailed(underlyingError: error.localizedDescription))
            SentrySDK.capture(error: appError)
        }

        return myLinksList.id
    }

    /// Creates the "My Links" list with 3 common example links
    /// - Returns: LinkListModel for "My Links"
    private static func createMyLinksList() -> LinkListModel {
        let myLinksList = LinkListModel(
            name: "My Links",
            color: .defaultForList,
            symbol: .defaultForList,
            isPinned: false
        )

        // Add 3 common example links
        let exampleLinks = [
            LinkModel(
                name: "Apple",
                url: URL(string: "https://apple.com")!,
                color: .gray,
                symbol: .technology(.computer)
            ),
            LinkModel(
                name: "Wikipedia",
                url: URL(string: "https://wikipedia.org")!,
                color: .blue,
                symbol: .documentsReadingWriting(.book)
            ),
            LinkModel(
                name: "GitHub",
                url: URL(string: "https://github.com")!,
                color: .purple,
                symbol: .technology(.computer)
            )
        ]

        myLinksList.links = exampleLinks

        return myLinksList
    }

    /// Creates the "Favorites" list with yellow color, star symbol, pinned status, and 1 link
    /// - Returns: LinkListModel for "Favorites"
    private static func createFavoritesList() -> LinkListModel {
        let favoritesList = LinkListModel(
            name: "Favorites",
            color: .yellow,
            symbol: .communication(.star),
            isPinned: true
        )

        // Add 1 example favorite link
        let favoriteLink = LinkModel(
            name: "Swift.org",
            url: URL(string: "https://swift.org")!,
            color: .orange,
            symbol: .communication(.star)
        )

        favoritesList.links = [favoriteLink]

        return favoritesList
    }
}
