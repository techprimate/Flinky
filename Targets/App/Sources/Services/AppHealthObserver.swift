import Foundation
import Network
import os.log
import SentrySwift
import UIKit

/// Observes app health signals and reports them as Sentry metrics.
///
/// This class monitors:
/// - **Thermal state changes**: Track when the device heats up or cools down
/// - **Network reachability changes**: Track connectivity state transitions
/// - **App state transitions**: Track foreground/background transitions
///
/// These metrics are recommended by the Sentry SDK team for app health monitoring
/// that doesn't overlap with automatic tracing features.
///
/// Reference: https://github.com/getsentry/sentry-cocoa/issues/7000
final class AppHealthObserver {

    // MARK: - Singleton

    /// Shared instance of the app health observer.
    static let shared = AppHealthObserver()

    // MARK: - Properties

    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Flinky", category: "AppHealthObserver")

    private var previousThermalState: ProcessInfo.ThermalState = ProcessInfo.processInfo.thermalState
    private var previousAppState: UIApplication.State = .inactive
    private var previousNetworkStatus: NWPath.Status?
    private var previousNetworkInterface: String?

    private let networkMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "com.flinky.network-monitor")

    private var isObserving = false

    // MARK: - Initialization

    private init() {}

    // MARK: - Public Methods

    /// Starts observing app health signals.
    ///
    /// Call this method once during app initialization, typically in `FlinkyApp.init()`.
    func startObserving() {
        guard !isObserving else {
            Self.logger.warning("AppHealthObserver is already observing")
            return
        }

        isObserving = true
        Self.logger.info("Starting app health observation")

        setupThermalStateObserver()
        setupNetworkReachabilityObserver()
        setupAppStateObserver()
    }

    /// Stops observing app health signals.
    ///
    /// Call this method during app cleanup if needed.
    func stopObserving() {
        guard isObserving else { return }

        isObserving = false
        Self.logger.info("Stopping app health observation")

        // swiftlint:disable:next notification_center_detachment
        NotificationCenter.default.removeObserver(self)
        networkMonitor.cancel()
    }

    // MARK: - Thermal State Observation

    private func setupThermalStateObserver() {
        previousThermalState = ProcessInfo.processInfo.thermalState

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleThermalStateChange),
            name: ProcessInfo.thermalStateDidChangeNotification,
            object: nil
        )

        Self.logger.debug("Thermal state observer setup complete. Initial state: \(self.thermalStateString(self.previousThermalState))")
    }

    @objc private func handleThermalStateChange() {
        let newState = ProcessInfo.processInfo.thermalState
        let oldState = previousThermalState

        guard newState != oldState else { return }

        let fromString = thermalStateString(oldState)
        let toString = thermalStateString(newState)
        let isEscalation = newState.rawValue > oldState.rawValue

        Self.logger.info("Thermal state changed: \(fromString) → \(toString) (escalation: \(isEscalation))")

        // Track thermal state transition
        SentryMetricsHelper.trackThermalStateTransition(
            fromState: fromString,
            toState: toString,
            isEscalation: isEscalation
        )

        // Add breadcrumb for debugging context
        let breadcrumb = Breadcrumb(level: isEscalation ? .warning : .info, category: "device_health")
        breadcrumb.message = "Thermal state changed: \(fromString) → \(toString)"
        breadcrumb.data = [
            "from_state": fromString,
            "to_state": toString,
            "is_escalation": isEscalation
        ]
        SentrySDK.addBreadcrumb(breadcrumb)

        previousThermalState = newState
    }

    private func thermalStateString(_ state: ProcessInfo.ThermalState) -> String {
        SentryMetricsHelper.thermalStateString(state)
    }

    // MARK: - Network Reachability Observation

    private func setupNetworkReachabilityObserver() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.handleNetworkPathUpdate(path)
        }

        networkMonitor.start(queue: networkQueue)

        Self.logger.debug("Network reachability observer setup complete")
    }

    private func handleNetworkPathUpdate(_ path: NWPath) {
        let status = path.status
        let interfaceType = getInterfaceType(path)
        let statusString = status == .satisfied ? "connected" : "disconnected"

        // Only track changes, not initial state
        guard previousNetworkStatus != nil else {
            previousNetworkStatus = status
            previousNetworkInterface = interfaceType
            Self.logger.debug("Initial network state: \(statusString) via \(interfaceType)")
            return
        }

        // Check if there's an actual change
        let statusChanged = previousNetworkStatus != status
        let interfaceChanged = previousNetworkInterface != interfaceType

        guard statusChanged || interfaceChanged else { return }

        Self.logger.info("Network changed: \(statusString) via \(interfaceType) (expensive: \(path.isExpensive), constrained: \(path.isConstrained))")

        // Track network reachability change
        SentryMetricsHelper.trackNetworkReachabilityChanged(
            status: statusString,
            interfaceType: interfaceType,
            isExpensive: path.isExpensive,
            isConstrained: path.isConstrained
        )

        // Add breadcrumb for debugging context
        let breadcrumb = Breadcrumb(level: .info, category: "network")
        breadcrumb.message = "Network changed: \(statusString) via \(interfaceType)"
        breadcrumb.data = [
            "status": statusString,
            "interface": interfaceType,
            "is_expensive": path.isExpensive,
            "is_constrained": path.isConstrained
        ]
        SentrySDK.addBreadcrumb(breadcrumb)

        previousNetworkStatus = status
        previousNetworkInterface = interfaceType
    }

    private func getInterfaceType(_ path: NWPath) -> String {
        if path.usesInterfaceType(.wifi) {
            return "wifi"
        } else if path.usesInterfaceType(.cellular) {
            return "cellular"
        } else if path.usesInterfaceType(.wiredEthernet) {
            return "wired"
        } else if path.usesInterfaceType(.loopback) {
            return "loopback"
        } else {
            return "other"
        }
    }

    // MARK: - App State Observation

    private func setupAppStateObserver() {
        previousAppState = UIApplication.shared.applicationState

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        Self.logger.debug("App state observer setup complete. Initial state: \(self.appStateString(self.previousAppState))")
    }

    @objc private func handleAppDidBecomeActive() {
        trackAppStateTransition(to: .active)
    }

    @objc private func handleAppWillResignActive() {
        trackAppStateTransition(to: .inactive)
    }

    @objc private func handleAppDidEnterBackground() {
        trackAppStateTransition(to: .background)
    }

    @objc private func handleAppWillEnterForeground() {
        // This is called before didBecomeActive, we'll track the full transition there
        Self.logger.debug("App will enter foreground")
    }

    private func trackAppStateTransition(to newState: UIApplication.State) {
        let oldState = previousAppState

        guard newState != oldState else { return }

        let fromString = appStateString(oldState)
        let toString = appStateString(newState)

        Self.logger.info("App state changed: \(fromString) → \(toString)")

        // Track app state transition
        SentryMetricsHelper.trackAppStateTransition(toState: toString, fromState: fromString)

        previousAppState = newState
    }

    private func appStateString(_ state: UIApplication.State) -> String {
        SentryMetricsHelper.appStateString(state)
    }

    // MARK: - Cleanup

    deinit {
        stopObserving()
    }
}
