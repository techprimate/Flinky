@MainActor
public final class Once {
    private var operation: (() -> Void)?

    public init(_ operation: @escaping () -> Void) {
        self.operation = operation
    }

    public func callAsFunction() {
        let operation = operation
        self.operation = nil
        operation?()
    }
}
