import XCTest

final class ScreenshotUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testScreenshots() throws {
        let app = XCUIApplication()
        app.launchEnvironment["TESTING"] = "1"
        setupSnapshot(app)
        app.launch()

        // Wait for app to fully load by waiting for the main navigation title
        let navigationTitle = app.navigationBars.firstMatch
        XCTAssert(navigationTitle.waitForExistence(timeout: 10), "App failed to load")

        // Wait for data seeding to complete by checking for list elements
        let listElements = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'link-lists.list-item.'"))
        let hasListData = listElements.firstMatch.waitForExistence(timeout: 10)
        XCTAssert(hasListData, "Sample data failed to load")

        // 1. Navigate to "My Links" list to show list detail
        let myLinksButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'My Links'")).firstMatch
        XCTAssert(myLinksButton.waitForExistence(timeout: 5), "My Links button not found")
        myLinksButton.tap()

        // Wait for list detail view to load
        let newLinkButton = app.buttons["link-list-detail.new-link.button"]
        XCTAssert(newLinkButton.waitForExistence(timeout: 5), "Link list detail view failed to load")

        // 2. Create new link
        newLinkButton.tap()

        // Wait for create link form to appear
        let titleField = app.textFields["create-link.title.text-field"]
        XCTAssert(titleField.waitForExistence(timeout: 5), "Create link form failed to load")

        // Fill in the new link data
        titleField.tap()
        titleField.typeText("philprime.dev")

        let urlField = app.textFields["create-link.url.text-field"]
        XCTAssert(urlField.waitForExistence(timeout: 3), "URL field not found")
        urlField.tap()
        urlField.typeText("https://philprime.dev")

        // Save the link
        let saveButton = app.buttons["create-link.save.button"]
        XCTAssert(saveButton.waitForExistence(timeout: 3), "Save button not found")
        XCTAssert(saveButton.isEnabled, "Save button is not enabled")
        saveButton.tap()

        // Wait for return to list detail view with new link
        XCTAssert(newLinkButton.waitForExistence(timeout: 5), "Failed to return to list detail after saving")

        // 3. Find and edit the newly created link
        let createdLinkButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'philprime.dev'")).firstMatch
        XCTAssert(createdLinkButton.waitForExistence(timeout: 5), "Newly created link not found after creation")

        // Long press to bring up context menu for edit
        createdLinkButton.press(forDuration: 1.0)

        let editButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Edit'")).firstMatch
        XCTAssert(editButton.waitForExistence(timeout: 3), "Edit button not found in context menu")
        editButton.tap()

        // Wait for edit form to appear
        let editForm = app.collectionViews["link-info.container"]
        XCTAssert(editForm.waitForExistence(timeout: 5), "Edit form failed to load")

        // Select a new color for the link
        app.buttons["grid-picker.item.orange"].tap()
        if UIDevice.current.userInterfaceIdiom != .pad {
            // Due to crashes of the UI layout on iPad when the sheet is not high enough,
            // we disabled the picker in the screenshots run.
            app.buttons["advanced-grid-picker.item.entertainment.party-popper"].tap()
        }

        // 4. Take screenshot of edit link settings
        snapshot("03_Edit_Link_Settings")

        // Save changes and close edit form
        app.buttons["link-info.save.button"].tap()

        // Wait for return to list detail
        XCTAssert(newLinkButton.waitForExistence(timeout: 5), "Failed to return to list detail after edit")

        // 5. Navigate to the created link detail page for QR code
        let updatedLinkButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'philprime.dev'")).firstMatch
        XCTAssert(updatedLinkButton.waitForExistence(timeout: 3), "Updated link not found")
        updatedLinkButton.tap()

        // Wait for QR code to generate
        let qrCodeContainer = app.images["link-detail.qr-code.container"]
        XCTAssert(qrCodeContainer.waitForExistence(timeout: 10), "QR code failed to generate")

        // SCREENSHOT ORDER:
        // 1. The QR code
        snapshot("01_QR_Code")

        // Close QR code view and return to list detail
        let doneButton = app.buttons["link-detail.done.button"]
        XCTAssert(doneButton.waitForExistence(timeout: 5), "Done button not found")
        doneButton.tap()

        // Wait for return to list detail view
        XCTAssert(newLinkButton.waitForExistence(timeout: 5), "Failed to return to list detail view")

        snapshot("02_List_Detail_View")

        // Go back to main list view
        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssert(backButton.waitForExistence(timeout: 3), "Back button not found")
        backButton.tap()

        // Wait for main lists view
        let createListButton = app.buttons["link-lists.create-list.button"]
        XCTAssert(createListButton.waitForExistence(timeout: 5), "Failed to return to main lists view")

        // Create three additional lists and edit their color and symbols
        let lists = [
            (name: "Travel", color: "grid-picker.item.mint", symbol: "advanced-grid-picker.item.transportation.airplane"),
            (name: "Work", color: "grid-picker.item.pink", symbol: "advanced-grid-picker.item.documents-reading-writing.book"),
            (name: "Food", color: "grid-picker.item.green", symbol: "advanced-grid-picker.item.food.fork-knife")
        ]
        for i in 0..<3 {
            // Tap the create list button
            createListButton.tap()

            // Wait for the create list form to appear
            let createListForm = app.collectionViews["create-link-list.container"]
            XCTAssert(createListForm.waitForExistence(timeout: 3), "Create list form did not appear for list \(i)")

            // Enter a unique list name
            let listNameField = app.textFields["create-link-list.name.text-field"]
            XCTAssert(listNameField.waitForExistence(timeout: 1), "List name text field not found for list \(i)")
            listNameField.tap()
            listNameField.typeText(lists[i].name)

            // Save the new list
            let saveButton = app.buttons["create-link-list.save-button"]
            XCTAssert(saveButton.waitForExistence(timeout: 2), "Save button not found for list \(i)")
            saveButton.tap()

            // Open the edit list editor
            let createdListButton = app.buttons.containing(NSPredicate(format: "label CONTAINS '\(lists[i].name)'")).firstMatch
            XCTAssert(createdListButton.waitForExistence(timeout: 5), "Created list button not found for list \(i)")
            createdListButton.press(forDuration: 1.0)

            let editButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Edit'")).firstMatch
            XCTAssert(editButton.waitForExistence(timeout: 3), "Edit button not found in context menu")
            editButton.tap()

            // Wait for the edit list form to appear
            let editListForm = app.collectionViews["link-list-info.container"]
            XCTAssert(editListForm.waitForExistence(timeout: 3), "Edit list form did not appear for list \(i)")

            // Select a new color for the list
            app.buttons[lists[i].color].tap()
            app.buttons[lists[i].symbol].tap()

            // Save changes and close edit form
            app.buttons["link-list-info.save-button"].tap()

            // Wait for return to main lists view
            XCTAssert(createListButton.waitForExistence(timeout: 5), "Failed to return to main lists view after creating list \(i)")
        }

        // 5. List of lists
        snapshot("04_List_Of_Lists")
    }
}
