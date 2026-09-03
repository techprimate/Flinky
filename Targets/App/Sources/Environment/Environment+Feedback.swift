import SwiftUI

struct FeedbackAction {
    private let handler: () -> Void

    init(handler: @escaping () -> Void = {}) {
        self.handler = handler
    }

    func show() {
        handler()
    }
}

extension EnvironmentValues {
    var feedback: FeedbackAction {
        get { self[FeedbackKey.self] }
        set { self[FeedbackKey.self] = newValue }
    }

    private struct FeedbackKey: EnvironmentKey {
        static let defaultValue = FeedbackAction()
    }
}
