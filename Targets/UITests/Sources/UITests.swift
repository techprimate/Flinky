import XCTest

final class UITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["TESTING"] = "1"
        app.launch()
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let app = XCUIApplication()
            app.launchEnvironment["TESTING"] = "1"
            app.launch()
        }
    }

    // MARK: - Feedback Button Tests

    func testFeedbackButtonExistsOnListsView() throws {
        // -- Act --
        let feedbackButton = app.buttons["link-lists.feedback.button"]
        XCTAssertTrue(feedbackButton.waitForExistence(timeout: 5))
        XCTAssertTrue(feedbackButton.isHittable)
        feedbackButton.tap()

        // -- Assert --
        assertFeedbackSubmitButtonExists()
    }

    func testFeedbackButtonExistsOnListDetailView() throws {
        // -- Arrange --
        navigateToListDetail()

        // -- Act --
        let feedbackButton = app.buttons["link-list-detail.feedback.button"]
        XCTAssertTrue(feedbackButton.waitForExistence(timeout: 5))
        XCTAssertTrue(feedbackButton.isHittable)
        feedbackButton.tap()

        // -- Assert --
        assertFeedbackSubmitButtonExists()
    }

    func testFeedbackButtonExistsOnLinkDetailView() throws {
        // -- Arrange --
        navigateToLinkDetail()

        // -- Act --
        let feedbackButton = app.buttons["link-detail.feedback.button"]
        XCTAssertTrue(feedbackButton.waitForExistence(timeout: 5))
        XCTAssertTrue(feedbackButton.isHittable)
        feedbackButton.tap()

        // -- Assert --
        assertFeedbackSubmitButtonExists()
    }

    func testFeedbackButtonExistsOnLinkInfoView() throws {
        // -- Arrange --
        navigateToLinkDetail()

        let moreMenu = app.buttons["link-detail.more-menu.button"]
        XCTAssertTrue(moreMenu.waitForExistence(timeout: 5))
        moreMenu.tap()

        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 5))
        editButton.tap()

        // -- Act --
        let feedbackButton = app.buttons["link-info.feedback.button"]
        XCTAssertTrue(feedbackButton.waitForExistence(timeout: 5))
        XCTAssertTrue(feedbackButton.isHittable)
        feedbackButton.tap()

        // -- Assert --
        assertFeedbackSubmitButtonExists()
    }

    func testFeedbackButtonExistsOnCreateListView() throws {
        // -- Arrange --
        let createListButton = app.buttons["link-lists.create-list.button"]
        XCTAssertTrue(createListButton.waitForExistence(timeout: 5))
        createListButton.tap()

        // -- Act --
        let feedbackButton = app.buttons["create-link-list.feedback.button"]
        XCTAssertTrue(feedbackButton.waitForExistence(timeout: 5))
        XCTAssertTrue(feedbackButton.isHittable)
        feedbackButton.tap()

        // -- Assert --
        assertFeedbackSubmitButtonExists()
    }

    func testFeedbackButtonExistsOnCreateLinkView() throws {
        // -- Arrange --
        navigateToListDetail()

        let newLinkButton = app.buttons["link-list-detail.new-link.button"]
        XCTAssertTrue(newLinkButton.waitForExistence(timeout: 5))
        newLinkButton.tap()

        // -- Act --
        let feedbackButton = app.buttons["create-link.feedback.button"]
        XCTAssertTrue(feedbackButton.waitForExistence(timeout: 5))
        XCTAssertTrue(feedbackButton.isHittable)
        feedbackButton.tap()

        // -- Assert --
        assertFeedbackSubmitButtonExists()
    }

    // MARK: - Navigation Helpers

    private func navigateToListDetail() {
        let myLinksRow = app.cells.containing(.staticText, identifier: "My Links").firstMatch
        XCTAssertTrue(myLinksRow.waitForExistence(timeout: 5))
        myLinksRow.tap()

        XCTAssertTrue(app.navigationBars["My Links"].waitForExistence(timeout: 5))
    }

    private func navigateToLinkDetail() {
        navigateToListDetail()

        let appleRow = app.cells.containing(.staticText, identifier: "Apple").firstMatch
        XCTAssertTrue(appleRow.waitForExistence(timeout: 5))
        appleRow.tap()
    }

    // MARK: - Assertion Helpers

    private func assertFeedbackSubmitButtonExists() {
        let submitButton = app.buttons["io.sentry.feedback.form.submit"].firstMatch
        XCTAssertTrue(submitButton.waitForExistence(timeout: 5))
    }
}
