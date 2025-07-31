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
            LinkModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Could not create test ModelContainer: \(error)")
        }

        // Clear UserDefaults for fresh test
        UserDefaults.standard.removeObject(forKey: "hasCompletedFirstLaunch")
    }

    override func tearDown() {
        // Clean up
        UserDefaults.standard.removeObject(forKey: "hasCompletedFirstLaunch")
        modelContainer = nil
        modelContext = nil
        super.tearDown()
    }

    func testSeedDataIfFirstLaunch_FirstLaunch_CreatesData() {
        // Given - Fresh install (UserDefaults not set)
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "hasCompletedFirstLaunch"))

        // When - Call seed data
        let myLinksId = DataSeedingService.seedDataIfFirstLaunch(modelContext: modelContext)

        // Then - Should return a valid UUID and create data
        XCTAssertNotNil(myLinksId)
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "hasCompletedFirstLaunch"))

        // Verify data was created
        let fetchDescriptor = FetchDescriptor<LinkListModel>()
        let lists = try! modelContext.fetch(fetchDescriptor)

        XCTAssertEqual(lists.count, 2) // "My Links" and "Favorites"

        // Check "My Links" list
        let myLinksList = lists.first { $0.name == "My Links" }
        XCTAssertNotNil(myLinksList)
        XCTAssertEqual(myLinksList?.links.count, 3)
        XCTAssertFalse(myLinksList?.isPinned ?? true)
        XCTAssertEqual(myLinksList?.id, myLinksId)

        // Check "Favorites" list
        let favoritesList = lists.first { $0.name == "Favorites" }
        XCTAssertNotNil(favoritesList)
        XCTAssertEqual(favoritesList?.links.count, 1)
        XCTAssertTrue(favoritesList?.isPinned ?? false)
        XCTAssertEqual(favoritesList?.color, .yellow)
        XCTAssertEqual(favoritesList?.symbol, .communication(.star))
    }

    func testSeedDataIfFirstLaunch_SecondLaunch_DoesNotCreateData() {
        // Given - App has already launched once
        UserDefaults.standard.set(true, forKey: "hasCompletedFirstLaunch")

        // When - Call seed data again
        let myLinksId = DataSeedingService.seedDataIfFirstLaunch(modelContext: modelContext)

        // Then - Should return nil and not create data
        XCTAssertNil(myLinksId)

        // Verify no data was created
        let fetchDescriptor = FetchDescriptor<LinkListModel>()
        let lists = try! modelContext.fetch(fetchDescriptor)

        XCTAssertEqual(lists.count, 0)
    }

    func testMyLinksListContent() {
        // When - Seed data on first launch
        _ = DataSeedingService.seedDataIfFirstLaunch(modelContext: modelContext)

        // Then - Verify "My Links" has correct example links
        let fetchDescriptor = FetchDescriptor<LinkListModel>(
            predicate: #Predicate { list in list.name == "My Links" }
        )
        let myLinksList = try! modelContext.fetch(fetchDescriptor).first

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

    func testFavoritesListContent() {
        // When - Seed data on first launch
        _ = DataSeedingService.seedDataIfFirstLaunch(modelContext: modelContext)

        // Then - Verify "Favorites" has correct content
        let fetchDescriptor = FetchDescriptor<LinkListModel>(
            predicate: #Predicate { list in list.name == "Favorites" }
        )
        let favoritesList = try! modelContext.fetch(fetchDescriptor).first

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
