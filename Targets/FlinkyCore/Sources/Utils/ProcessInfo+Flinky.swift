import Foundation

public extension ProcessInfo {
    var isTestingEnabled: Bool {
        self.environment["TESTING"] == "1"
    }
}
