import SwiftUI
import UIKit

extension View {
    /// This modifier is used to integrate a toast notification system into the view hierarchy.
    ///
    /// - Note: This should be used on the main container view of your application to ensure that the toast notifications are displayed correctly.
    /// - Parameter toastManager: An instance of `ToastManager` that manages the toast notifications.
    /// - Returns: A view with the `ToastManager` environment value set and an overlay for the toast stack.
    func toaster(_ toastManager: ToastManager) -> some View {
        environment(\.toaster, toastManager)
            .overlay(
                // Use window-based approach for toasts that appear above modal sheets
                ToastTopLevelView(toastManager: toastManager)
                    .allowsHitTesting(false)
            )
    }
}

/// Top-level toast view that appears above modal sheets using a window-based approach
struct ToastTopLevelView: View {
    @ObservedObject var toastManager: ToastManager
    @State private var toastWindow: UIWindow?
    @State private var hostingController: PassThroughUIHostingController<ToastStackView>?

    var body: some View {
        Color.clear
            .onAppear {
                setupToastWindow()
                setupNotifications()
            }
            .onDisappear {
                teardownToastWindow()
                teardownNotifications()
            }
            .onChange(of: toastManager.toastStack) {
                updateToastWindow()
            }
    }

    private func setupToastWindow() {
        guard toastWindow == nil else { return } // Prevent multiple setups

        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }

        let window = PassThroughWindow(name: "ToastWindow", windowScene: windowScene)
        window.backgroundColor = .clear
        window.windowLevel = UIWindow.Level.alert + 1 // Above modal sheets

        let hostingController = PassThroughUIHostingController(
            rootView: ToastStackView(toastManager: toastManager)
        )
        hostingController.view.backgroundColor = .clear
        window.rootViewController = hostingController

        // Only show window if there are toasts
        window.isHidden = toastManager.toastStack.isEmpty

        toastWindow = window
        self.hostingController = hostingController

        // Force layout update
        DispatchQueue.main.async {
            hostingController.view.setNeedsLayout()
            hostingController.view.layoutIfNeeded()
        }
    }

    private func teardownToastWindow() {
        toastWindow?.isHidden = true
        toastWindow?.rootViewController = nil
        toastWindow = nil
        hostingController = nil
    }

    private func updateToastWindow() {
        guard let window = toastWindow else {
            if !toastManager.toastStack.isEmpty {
                setupToastWindow()
            }
            return
        }

        // Update window visibility
        if toastManager.toastStack.isEmpty {
            window.isHidden = true
        } else {
            window.isHidden = false
            // Force layout update when showing toasts
            DispatchQueue.main.async {
                self.hostingController?.view.setNeedsLayout()
                self.hostingController?.view.layoutIfNeeded()
            }
        }
    }

    private func setupNotifications() {
        // Listen for window changes that might affect safe area
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            DispatchQueue.main.async {
                self.hostingController?.view.setNeedsLayout()
                self.hostingController?.view.layoutIfNeeded()
            }
        }
    }

    private func teardownNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
