import os.log

extension Logger {
    static func forType<T>(_ type: T.Type) -> Logger {
        Logger(subsystem: "com.techprimate.Flinky", category: String(describing: type))
    }
}
