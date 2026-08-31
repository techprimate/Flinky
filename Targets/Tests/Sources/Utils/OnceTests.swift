import XCTest
@testable import FlinkyCore

final class OnceTests: XCTestCase {
    @MainActor
    func testRepeatedCallsRunOperationOnce() {
        var invocationCount = 0
        let once = Once {
            invocationCount += 1
        }

        once()
        once()

        XCTAssertEqual(invocationCount, 1)
    }
}
