import Logging

public extension Logger {
    init<T>(for type: T.Type) {
        self.init(label: String(reflecting: type))
    }
}
