import Foundation
import Sentry
import SwiftData
import os.log

/// Service responsible for pre-seeding data on first app launch
final class DataSeedingService {
    private static let logger = Logger.forType(DataSeedingService.self)

    // MARK: - Public API

    /// Checks if the database has been seeded and seeds it if needed
    /// - Parameter modelContext: SwiftData model context to use for data operations
    static func seedDataIfNeeded(modelContext: ModelContext) {
        let breadcrumb = Breadcrumb()
        breadcrumb.message = "Starting database seeding check"
        breadcrumb.category = "database.seeding"
        breadcrumb.level = .info
        breadcrumb.timestamp = Date()
        SentrySDK.addBreadcrumb(breadcrumb)

        // Check if database has already been seeded
        if isDatabaseSeeded(modelContext: modelContext) {
            logger.info("Database already seeded, skipping")

            let skippingBreadcrumb = Breadcrumb()
            skippingBreadcrumb.message = "Database already seeded, skipping"
            skippingBreadcrumb.category = "database.seeding"
            skippingBreadcrumb.level = .info
            skippingBreadcrumb.timestamp = Date()
            SentrySDK.addBreadcrumb(skippingBreadcrumb)
            return
        }

        logger.info("Database not seeded, performing initial seeding")
        let seedingBreadcrumb = Breadcrumb()
        seedingBreadcrumb.message = "Database not seeded, performing initial seeding"
        seedingBreadcrumb.category = "database.seeding"
        seedingBreadcrumb.level = .info
        seedingBreadcrumb.timestamp = Date()
        SentrySDK.addBreadcrumb(seedingBreadcrumb)

        // Capture seeding event for analytics
        SentrySDK.capture(message: "Database seeding started") { scope in
            scope.setLevel(.info)
            scope.setTag(value: "database_seeding", key: "operation")
            scope.setContext(
                value: [
                    "action": "initial_seed",
                    "timestamp": ISO8601DateFormatter().string(from: Date())
                ], key: "seeding")
        }

        seedInitialData(modelContext: modelContext)
        markDatabaseAsSeeded(modelContext: modelContext)

        // Capture successful seeding completion
        SentrySDK.capture(message: "Database seeding completed successfully") { scope in
            scope.setLevel(.info)
            scope.setTag(value: "database_seeding", key: "operation")
            scope.setTag(value: "success", key: "status")
        }
    }

    // MARK: - Private Implementation

    /// Checks if the database has been seeded by looking for the metadata marker
    /// - Parameter modelContext: SwiftData model context to use for data operations
    /// - Returns: True if the database has been seeded, false otherwise
    private static func isDatabaseSeeded(modelContext: ModelContext) -> Bool {
        let checkBreadcrumb = Breadcrumb()
        checkBreadcrumb.message = "Checking database seeding status"
        checkBreadcrumb.category = "database.query"
        checkBreadcrumb.level = .debug
        checkBreadcrumb.timestamp = Date()
        SentrySDK.addBreadcrumb(checkBreadcrumb)

        let descriptor = FetchDescriptor<DatabaseMetadata>(
            predicate: #Predicate { metadata in
                metadata.key == "database_seeded" && metadata.value == "true"
            }
        )

        do {
            let seededMarkers = try modelContext.fetch(descriptor)
            let isSeeded = !seededMarkers.isEmpty

            let statusBreadcrumb = Breadcrumb()
            statusBreadcrumb.message = "Database seeding status: \(isSeeded ? "seeded" : "not seeded")"
            statusBreadcrumb.category = "database.query"
            statusBreadcrumb.level = .debug
            statusBreadcrumb.timestamp = Date()
            statusBreadcrumb.data = ["is_seeded": isSeeded]
            SentrySDK.addBreadcrumb(statusBreadcrumb)

            return isSeeded
        } catch {
            logger.error("Failed to check if database is seeded: \(error)")

            // Capture the error but don't throw - assume not seeded to be safe
            SentrySDK.capture(error: error) { scope in
                scope.setTag(value: "check_database_seeded", key: "operation")
                scope.setContext(
                    value: [
                        "description": error.localizedDescription,
                        "action": "checking_seeding_status"
                    ], key: "error_details")
            }

            // If we can't check, assume it's not seeded to be safe
            return false
        }
    }

    /// Marks the database as seeded by creating a metadata entry
    /// - Parameter modelContext: SwiftData model context to use for data operations
    private static func markDatabaseAsSeeded(modelContext: ModelContext) {
        let creatingBreadcrumb = Breadcrumb()
        creatingBreadcrumb.message = "Creating database seeded marker"
        creatingBreadcrumb.category = "database.metadata"
        creatingBreadcrumb.level = .info
        creatingBreadcrumb.timestamp = Date()
        SentrySDK.addBreadcrumb(creatingBreadcrumb)

        let seededMarker = DatabaseMetadata.createSeededMarker()
        modelContext.insert(seededMarker)

        do {
            try modelContext.save()
            logger.info("Marked database as seeded")

            let successBreadcrumb = Breadcrumb()
            successBreadcrumb.message = "Successfully marked database as seeded"
            successBreadcrumb.category = "database.metadata"
            successBreadcrumb.level = .info
            successBreadcrumb.timestamp = Date()
            successBreadcrumb.data = [
                "marker_id": seededMarker.id.uuidString,
                "created_at": ISO8601DateFormatter().string(from: seededMarker.createdAt)
            ]
            SentrySDK.addBreadcrumb(successBreadcrumb)
        } catch {
            logger.error("Failed to mark database as seeded: \(error)")

            let appError = AppError.persistenceError(.saveListFailed(underlyingError: error.localizedDescription))
            SentrySDK.capture(error: appError) { scope in
                scope.setTag(value: "mark_database_seeded", key: "operation")
                scope.setContext(
                    value: [
                        "description": error.localizedDescription,
                        "action": "saving_seeded_marker"
                    ], key: "error_details")
            }
        }
    }

    /// Seeds the initial data for first launch
    /// - Parameter modelContext: SwiftData model context to use for data operations
    static func seedInitialData(modelContext: ModelContext) {  // swiftlint:disable:this function_body_length
        logger.info("Seeding initial data")

        let startBreadcrumb = Breadcrumb()
        startBreadcrumb.message = "Starting initial data seeding"
        startBreadcrumb.category = "database.seeding"
        startBreadcrumb.level = .info
        startBreadcrumb.timestamp = Date()
        SentrySDK.addBreadcrumb(startBreadcrumb)

        // Create "My Links" list with 3 common links
        let myLinksList = createMyLinksList()
        modelContext.insert(myLinksList)

        let myLinksBreadcrumb = Breadcrumb()
        myLinksBreadcrumb.message = "Created 'My Links' list with \(myLinksList.links.count) links"
        myLinksBreadcrumb.category = "database.seeding"
        myLinksBreadcrumb.level = .info
        myLinksBreadcrumb.timestamp = Date()
        myLinksBreadcrumb.data = [
            "list_name": myLinksList.name,
            "link_count": myLinksList.links.count,
            "is_pinned": myLinksList.isPinned
        ]
        SentrySDK.addBreadcrumb(myLinksBreadcrumb)

        // Create "Favorites" list with yellow color, star symbol, pinned, and 1 link
        let favoritesList = createFavoritesList()
        modelContext.insert(favoritesList)

        let favoritesBreadcrumb = Breadcrumb()
        favoritesBreadcrumb.message = "Created 'Favorites' list with \(favoritesList.links.count) links"
        favoritesBreadcrumb.category = "database.seeding"
        favoritesBreadcrumb.level = .info
        favoritesBreadcrumb.timestamp = Date()
        favoritesBreadcrumb.data = [
            "list_name": favoritesList.name,
            "link_count": favoritesList.links.count,
            "is_pinned": favoritesList.isPinned,
            "color": favoritesList.color?.rawValue ?? "none",
            "symbol": favoritesList.symbol?.rawValue ?? "none"
        ]
        SentrySDK.addBreadcrumb(favoritesBreadcrumb)

        // Save the context
        do {
            try modelContext.save()
            logger.info("Successfully seeded initial data")

            let successBreadcrumb = Breadcrumb()
            successBreadcrumb.message = "Successfully saved initial data to database"
            successBreadcrumb.category = "database.seeding"
            successBreadcrumb.level = .info
            successBreadcrumb.timestamp = Date()
            successBreadcrumb.data = [
                "lists_created": 2,
                "total_links_created": myLinksList.links.count + favoritesList.links.count
            ]
            SentrySDK.addBreadcrumb(successBreadcrumb)
        } catch {
            logger.error("Failed to save seeded data: \(error)")

            let appError = AppError.persistenceError(.saveListFailed(underlyingError: error.localizedDescription))
            SentrySDK.capture(error: appError) { scope in
                scope.setTag(value: "seed_initial_data", key: "operation")
                scope.setContext(
                    value: [
                        "description": error.localizedDescription,
                        "action": "saving_initial_seed_data",
                        "lists_attempted": 2
                    ], key: "error_details")
            }
        }
    }

    // MARK: - Data Creation Methods

    /// Creates the "My Links" list with 3 common example links
    /// - Returns: LinkListModel for "My Links"
    private static func createMyLinksList() -> LinkListModel {
        let myLinksList = LinkListModel(
            name: "My Links",
            color: .defaultForList,
            symbol: .defaultForList,
            isPinned: false
        )

        // Add 3 common example links that showcase different types of content
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

        // Add 1 example favorite link to demonstrate the favorites feature
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
