final class LazyThrowingValue<T> {
    private var cached: T?
    private let factory: () throws -> T

    init(_ factory: @escaping () throws -> T) {
        self.factory = factory
    }

    func resolve() throws -> T {
        if let cached { return cached }
        let value = try factory()
        cached = value
        return value
    }
}
