import Logging
import XCTest
@testable import FlinkyCore

final class LoggerForTypeTests: XCTestCase {
    func testForInitializerUsesModuleQualifiedTypeNameAsLabel() {
        let logger = Logger(for: LoggerForTypeFixture.self)

        XCTAssertEqual(logger.label, "Tests.LoggerForTypeFixture")
    }
}

struct LoggerForTypeFixture {}
