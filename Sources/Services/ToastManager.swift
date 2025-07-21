import SwiftUI
import Combine

// MARK: - Toast Types and Models

/// Toast status similar to ChakraUI
public enum ToastStatus: String, CaseIterable {
    case success = "success"
    case error = "error"
    case warning = "warning"
    case info = "info"
    
    public var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}

/// Individual toast item for the stack
public struct AlertToastItem {
    public let title: String
    public let status: ToastStatus
    
    public init(title: String, status: ToastStatus = .info) {
        self.title = title
        self.status = status
    }
}

/// Toast stack item with additional properties
public struct AlertToastStackItem: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let status: ToastStatus
    public let duration: TimeInterval
    public let tapToDismiss: Bool
    public let createdAt = Date()
    
    public init(
        title: String,
        status: ToastStatus = .info,
        duration: TimeInterval = 4.0,
        tapToDismiss: Bool = true
    ) {
        self.title = title
        self.status = status
        self.duration = duration
        self.tapToDismiss = tapToDismiss
    }
    
    /// Convert to AlertToastItem for display
    public var asToastItem: AlertToastItem {
        AlertToastItem(title: title, status: status)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: AlertToastStackItem, rhs: AlertToastStackItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Toast Manager

/// Global toast manager similar to ChakraUI's useToast
public class ToastManager: ObservableObject {
    @Published public var toastStack: [AlertToastStackItem] = []
    private var timers: [UUID: Timer] = [:]
    
    public init() {}
    
    /// Create and show a new toast - ChakraUI style API
    public func create(
        description: String,
        type: String = "info",
        closable: Bool = true,
        duration: TimeInterval = 4.0
    ) {
        let status: ToastStatus
        switch type.lowercased() {
        case "success":
            status = .success
        case "error":
            status = .error
        case "warning":
            status = .warning
        case "info":
            status = .info
        default:
            status = .info
        }
        
        let toast = AlertToastStackItem(
            title: description,
            status: status,
            duration: duration,
            tapToDismiss: closable
        )
        
        DispatchQueue.main.async {
            self.toastStack.append(toast)
            
            // Auto-dismiss after duration (if specified)
            if duration > 0 {
                let timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
                    self.dismiss(toast.id)
                }
                self.timers[toast.id] = timer
            }
        }
    }
    
    /// Convenience methods for different types
    public func success(
        title: String? = nil,
        description: String,
        duration: TimeInterval = 4.0,
        isClosable: Bool = true
    ) {
        create(description: description, type: "success", closable: isClosable, duration: duration)
    }
    
    public func error(
        title: String? = nil,
        description: String,
        duration: TimeInterval = 6.0,
        isClosable: Bool = true
    ) {
        create(description: description, type: "error", closable: isClosable, duration: duration)
    }
    
    public func warning(
        title: String? = nil,
        description: String,
        duration: TimeInterval = 5.0,
        isClosable: Bool = true
    ) {
        create(description: description, type: "warning", closable: isClosable, duration: duration)
    }
    
    public func info(
        title: String? = nil,
        description: String,
        duration: TimeInterval = 4.0,
        isClosable: Bool = true
    ) {
        create(description: description, type: "info", closable: isClosable, duration: duration)
    }
    
    /// Convenience method to show any Error as a toast
    public func show(error: Error, duration: TimeInterval = 6.0, isClosable: Bool = true) {
        let description: String
        
        if let localizedError = error as? LocalizedError {
            description = localizedError.errorDescription ?? localizedError.localizedDescription
        } else {
            description = error.localizedDescription
        }
        
        create(
            description: description,
            type: "error",
            closable: isClosable,
            duration: duration
        )
    }
    
    /// Dismiss a specific toast
    public func dismiss(_ toastId: UUID) {
        DispatchQueue.main.async {
            self.toastStack.removeAll { $0.id == toastId }
            
            // Cancel timer if exists
            self.timers[toastId]?.invalidate()
            self.timers.removeValue(forKey: toastId)
        }
    }
    
    /// Dismiss all toasts
    public func dismissAll() {
        DispatchQueue.main.async {
            self.toastStack.removeAll()
            
            // Cancel all timers
            self.timers.values.forEach { $0.invalidate() }
            self.timers.removeAll()
        }
    }
}

// MARK: - Environment Support

/// Environment key for ToastManager
public struct ToastManagerKey: EnvironmentKey {
    public static let defaultValue = ToastManager()
}

public extension EnvironmentValues {
    var toaster: ToastManager {
        get { self[ToastManagerKey.self] }
        set { self[ToastManagerKey.self] = newValue }
    }
}

// MARK: - View Extensions

public extension View {
    /// Add toast stack support to any view
    func withToastStack() -> some View {
        ToastStackWrapperView(content: self)
    }
}

/// Direct toast stack view that observes a ToastManager instance
struct ToastStackView: View {
    @ObservedObject var toastManager: ToastManager
    
    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
            .modifier(AlertToastStackModifier(stack: $toastManager.toastStack))
    }
}

/// Wrapper view that has access to the environment toaster
struct ToastStackWrapperView<Content: View>: View {
    let content: Content
    @Environment(\.toaster) var toaster
    
    var body: some View {
        content
            .modifier(ToastStackViewModifier(toaster: toaster))
    }
}

/// View modifier to display toast stack
struct ToastStackViewModifier: ViewModifier {
    @ObservedObject var toaster: ToastManager
    
    init(toaster: ToastManager) {
        self.toaster = toaster
    }
    
    func body(content: Content) -> some View {
        content
            .toastStack(stack: $toaster.toastStack)
    }
} 