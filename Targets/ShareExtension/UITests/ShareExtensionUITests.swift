import XCTest

final class ShareExtensionUITests: XCTestCase {

    override func setUpWithError() throws {
        // For UI tests we must stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    @MainActor
    func testShareLinkToFlinky() throws {
        // Launch Safari
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        safari.launch()

        // Find the address bar and enter the URL
        let addressFieldPrimary = safari.textFields["Address"]
        let addressFieldAlt = safari.textFields["Search or enter website name"]
        let addressFieldAny = safari.textFields.firstMatch
        if addressFieldPrimary.waitForExistence(timeout: 10) {
            addressFieldPrimary.tap()
        } else if addressFieldAlt.waitForExistence(timeout: 3) {
            addressFieldAlt.tap()
        } else {
            XCTAssertTrue(addressFieldAny.waitForExistence(timeout: 5), "Could not find Safari address field")
            addressFieldAny.tap()
        }

        safari.typeText("https://apple.com\n")

        // Wait for page to load and the Share button to appear
        let shareButton = safari.buttons["Share"]
        XCTAssertTrue(shareButton.waitForExistence(timeout: 10), "Share button did not appear in Safari")
        shareButton.tap()

        let shareToFlinkyButton = safari.cells
            .matching(NSPredicate(format: "identifier == 'shareCell' AND label == 'Flinky'"))
            .firstMatch

        XCTAssertTrue(shareToFlinkyButton.waitForExistence(timeout: 10), "Flinky share action did not appear")
        shareToFlinkyButton.tap()

        // Wait for the share extension UI to appear
        let addToFlinkyNavBar = safari.navigationBars["Add to Flinky"]
        XCTAssertTrue(addToFlinkyNavBar.waitForExistence(timeout: 10), "Share extension UI did not appear")

        // Validate key UI elements
        let urlLabel = safari.staticTexts["URL"]
        XCTAssertTrue(urlLabel.waitForExistence(timeout: 5), "URL label not found in share extension")

        let listLabel = safari.staticTexts["List"]
        XCTAssertTrue(listLabel.waitForExistence(timeout: 5), "List label not found in share extension")

        let myLinksValue = safari.staticTexts["My Links"]
        XCTAssertTrue(myLinksValue.waitForExistence(timeout: 5), "Selected list value 'My Links' not visible")

        // Wait for Post button to become enabled, then tap it
        let postButton = addToFlinkyNavBar.buttons["Post"]
        XCTAssertTrue(postButton.waitForExistence(timeout: 5), "Post button not found")

        if postButton.isEnabled {
            postButton.tap()
        } else if addToFlinkyNavBar.buttons["Add"].exists {
            addToFlinkyNavBar.buttons["Add"].tap()
        } else if addToFlinkyNavBar.buttons["Done"].exists {
            addToFlinkyNavBar.buttons["Done"].tap()
        } else {
            XCTFail("Could not find an enabled button to complete the share (Post/Done/Add)")
        }

        // Verify the share sheet/extension dismisses
        XCTAssertFalse(addToFlinkyNavBar.waitForExistence(timeout: 5), "Share extension did not dismiss")
    }
}
