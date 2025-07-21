import XCTest
@testable import Flinky

final class PersistenceErrorTests: XCTestCase {
    
    func testPersistenceErrorDescriptions() throws {
        // Test all persistence error descriptions
        let saveLinkError = PersistenceError.saveLinkFailed(underlyingError: "Core Data error")
        XCTAssertEqual(saveLinkError.errorDescription, "Failed to save link")
        
        let saveListError = PersistenceError.saveListFailed(underlyingError: "Core Data error")
        XCTAssertEqual(saveListError.errorDescription, "Failed to save list")
        
        let deleteLinkError = PersistenceError.deleteLinkFailed(underlyingError: "Core Data error")
        XCTAssertEqual(deleteLinkError.errorDescription, "Failed to delete link")
        
        let deleteMultipleLinksError = PersistenceError.deleteMultipleLinksFailed(underlyingError: "Core Data error")
        XCTAssertEqual(deleteMultipleLinksError.errorDescription, "Failed to delete links")
        
        let deleteListError = PersistenceError.deleteListFailed(underlyingError: "Core Data error")
        XCTAssertEqual(deleteListError.errorDescription, "Failed to delete list")
        
        let saveChangesAfterDeletionError = PersistenceError.saveChangesAfterDeletionFailed(underlyingError: "Core Data error")
        XCTAssertEqual(saveChangesAfterDeletionError.errorDescription, "Failed to save deletion changes")
        
        let pinListError = PersistenceError.pinListFailed(underlyingError: "Core Data error")
        XCTAssertEqual(pinListError.errorDescription, "Failed to pin list")
        
        let unpinListError = PersistenceError.unpinListFailed(underlyingError: "Core Data error")
        XCTAssertEqual(unpinListError.errorDescription, "Failed to unpin list")
        
        let saveLinkChangesError = PersistenceError.saveLinkChangesFailed(underlyingError: "Core Data error")
        XCTAssertEqual(saveLinkChangesError.errorDescription, "Failed to save link changes")
        
        let saveListChangesError = PersistenceError.saveListChangesFailed(underlyingError: "Core Data error")
        XCTAssertEqual(saveListChangesError.errorDescription, "Failed to save list changes")
    }
    
    func testPersistenceErrorRecoverySuggestion() throws {
        let error = PersistenceError.saveLinkFailed(underlyingError: "Test error")
        XCTAssertEqual(error.recoverySuggestion, "Please try again. If the problem persists, restart the app.")
    }
    
    func testPersistenceErrorUnderlyingError() throws {
        let underlyingErrorMessage = "Core Data constraint violation"
        let error = PersistenceError.saveLinkFailed(underlyingError: underlyingErrorMessage)
        XCTAssertEqual(error.underlyingError, underlyingErrorMessage)
    }
    
    func testPersistenceErrorEquality() throws {
        let error1 = PersistenceError.saveLinkFailed(underlyingError: "Error 1")
        let error2 = PersistenceError.saveLinkFailed(underlyingError: "Error 1")
        let error3 = PersistenceError.saveLinkFailed(underlyingError: "Error 2")
        let error4 = PersistenceError.saveListFailed(underlyingError: "Error 1")
        
        // Same error type and message should be equal
        XCTAssertEqual(error1, error2)
        
        // Different message should not be equal
        XCTAssertNotEqual(error1, error3)
        
        // Different error type should not be equal
        XCTAssertNotEqual(error1, error4)
    }
    
    func testAppErrorWithPersistenceError() throws {
        let persistenceError = PersistenceError.deleteLinkFailed(underlyingError: "Network timeout")
        let appError = AppError.persistenceError(persistenceError)
        
        XCTAssertEqual(appError.errorDescription, "Failed to delete link")
        XCTAssertEqual(appError.recoverySuggestion, "Please try again. If the problem persists, restart the app.")
        XCTAssertTrue(appError.id.contains("Network timeout"))
    }
} 