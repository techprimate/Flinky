import FlinkyCore
import SwiftData

@MainActor
struct Dependencies {
    let toastManager = ToastManager()
    let appHealthObserver = AppHealthObserver()
    let metricKitManager = MetricKitManager()

    private let _modelContainer: LazyThrowingValue<ModelContainer>

    var modelContainer: ModelContainer {
        get throws { try _modelContainer.resolve() }
    }

    init(isTestingEnabled: Bool) {
        _modelContainer = LazyThrowingValue {
            try SharedModelContainerFactory.make(isStoredInMemoryOnly: isTestingEnabled)
        }
    }
}
