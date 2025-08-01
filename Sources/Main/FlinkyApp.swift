import OnLaunch
import Sentry
import SwiftData
import SwiftUI
import os.log

@main
struct FlinkyApp: App {
    static let logger = Logger.forType(Self.self)

    @StateObject private var toastManager = ToastManager()

    init() {
        SentrySDK.start { options in
            Self.configureSentry(options: options)
        }
    }

    /// Configures the Sentry SDK options.
    ///
    /// This method is defined as `private static` to because it is called from a non-mutating context.
    ///
    /// - Parameter options: Options structure to configure Sentry.
    private static func configureSentry(options: Options) {
        options.debug = true
        options.dsn = "https://f371822cfa840de0c6a27a788a5fa48e@o188824.ingest.us.sentry.io/4509640637349888"

        let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        options.releaseName = "\(bundleId ?? "unknown")@\(version ?? "unknown")+\(build ?? "unknown")"

        #if DEBUG
            options.environment = "development"
        #else
            options.environment = "production"
        #endif

        options.sampleRate = 1.0
        options.tracesSampleRate = 1.0

        // Configure General Options
        options.sendDefaultPii = true
        options.enableAutoBreadcrumbTracking = true
        options.enableMetricKit = true
        options.enableTimeToFullDisplayTracing = true
        options.enableSwizzling = true
        options.swiftAsyncStacktraces = true

        // Configure Crash Reporting
        options.enableCrashHandler = true
        options.enableSigtermReporting = true
        options.enableWatchdogTerminationTracking = true
        options.attachStacktrace = true
        options.enablePersistingTracesWhenCrashing = true

        // Configure Profiling
        options.enableAppLaunchProfiling = true
        options.profilesSampleRate = 1.0

        // Configure Session Replay
        options.sessionReplay.onErrorSampleRate = 1.0
        options.sessionReplay.sessionSampleRate = 1.0
        options.sessionReplay.enableViewRendererV2 = true
        options.sessionReplay.enableFastViewRendering = false

        // Configure App Hang
        options.enableAppHangTracking = true
        options.enableAppHangTrackingV2 = true
        options.enableReportNonFullyBlockingAppHangs = false

        // Configure File I/O
        options.enableFileIOTracing = true
        options.experimental.enableDataSwizzling = true
        options.experimental.enableFileManagerSwizzling = true

        // Configure Tracing
        options.enableAutoPerformanceTracing = true
        options.enablePerformanceV2 = true
        options.enableCoreDataTracing = true
        options.enablePreWarmedAppStartTracing = true

        // Configure UI Insights
        options.enableUIViewControllerTracing = true
        options.attachScreenshot = true
        options.attachViewHierarchy = true
        options.enableUserInteractionTracing = true
        options.reportAccessibilityIdentifier = true

        // Configure Networking
        options.enableNetworkTracking = true
        options.enableNetworkBreadcrumbs = true
        options.enableGraphQLOperationTracking = true
        options.enableCaptureFailedRequests = true

        // Configure User Feedback
        options.configureUserFeedback = { feedbackOptions in
            feedbackOptions.animations = true
            feedbackOptions.configureWidget = { widgetOptions in
                widgetOptions.autoInject = false  // Disable automatic injection of the widget, because it's not supported in SwiftUI.
                widgetOptions.labelText = "Send Feedback"
                widgetOptions.showIcon = true
                widgetOptions.widgetAccessibilityLabel = "Feedback Widget"
                widgetOptions.windowLevel = UIWindow.Level.normal + 1
                widgetOptions.location = [.bottom, .trailing]
                widgetOptions.layoutUIOffset = .init(horizontal: 18, vertical: 80)
            }
            feedbackOptions.useShakeGesture = true
            feedbackOptions.showFormForScreenshots = true
            feedbackOptions.configureForm = { formOptions in
                formOptions.useSentryUser = true
                formOptions.showBranding = true
                formOptions.formTitle = "Send Feedback"
                formOptions.messageLabel = "Description"
                formOptions.messagePlaceholder = "Please describe the issue you encountered"
                formOptions.messageTextViewAccessibilityLabel = "Feedback Message"
                formOptions.isRequiredLabel = "(Required)"
                formOptions.removeScreenshotButtonLabel = "Remove Screenshot"
                formOptions.removeScreenshotButtonAccessibilityLabel = "Remove Screenshot"

                formOptions.isNameRequired = false
                formOptions.showName = false
                formOptions.nameLabel = "Name"
                formOptions.namePlaceholder = "Your Name"
                formOptions.nameTextFieldAccessibilityLabel = "Your Name"

                formOptions.isEmailRequired = false
                formOptions.showEmail = true
                formOptions.emailLabel = "Email"
                formOptions.emailPlaceholder = "Your Email"
                formOptions.emailTextFieldAccessibilityLabel = "Your Email"

                formOptions.submitButtonLabel = "Send Feedback"
                formOptions.submitButtonAccessibilityLabel = "Send Feedback"

                formOptions.cancelButtonLabel = "Cancel"
                formOptions.cancelButtonAccessibilityLabel = "Cancel Feedback"
            }
            feedbackOptions.configureTheme = { themeOptions in
                // The font family to use for form text elements.
                themeOptions.fontFamily = nil  // Defaults to system font

                // Foreground text color of the widget and form.
                themeOptions.foreground = UIColor.label

                // Background color of the widget and form.
                themeOptions.background = UIColor.systemBackground

                // Foreground color for the form submit button.
                themeOptions.submitForeground = UIColor.white

                // Background color for the form submit button in light and dark modes.
                themeOptions.submitBackground = UIColor.systemBlue

                // Foreground color for the cancel and screenshot buttons.
                themeOptions.buttonForeground = UIColor.label

                // Background color for the form cancel and screenshot buttons in light and dark modes.
                themeOptions.buttonBackground = UIColor.white

                // Color used for error-related components (such as text color when there's an error submitting feedback).
                themeOptions.errorColor = UIColor.systemRed

                // Options for styling the outline of input elements and buttons in the feedback form.
                themeOptions.outlineStyle.color = UIColor.systemGray
                themeOptions.outlineStyle.cornerRadius = 5
                themeOptions.outlineStyle.outlineWidth = 0.5
            }
            feedbackOptions.configureDarkTheme = { themeOptions in
                // Background color to use for text inputs in the feedback form.
                themeOptions.inputBackground = UIColor.systemGray6

                // Background color to use for text inputs in the feedback form.
                themeOptions.inputForeground = UIColor.label

                // The font family to use for form text elements.
                themeOptions.fontFamily = nil  // Defaults to system font

                // Foreground text color of the widget and form.
                themeOptions.foreground = UIColor.label

                // Background color of the widget and form.
                themeOptions.background = UIColor.systemBackground

                // Foreground color for the form submit button.
                themeOptions.submitForeground = UIColor.systemBlue

                // Background color for the form submit button in light and dark modes.
                themeOptions.submitBackground = UIColor.systemBackground

                // Foreground color for the cancel and screenshot buttons.
                themeOptions.buttonForeground = UIColor.label

                // Background color for the form cancel and screenshot buttons in light and dark modes.
                themeOptions.buttonBackground = UIColor.systemBackground

                // Color used for error-related components (such as text color when there's an error submitting feedback).
                themeOptions.errorColor = UIColor.systemRed

                // Options for styling the outline of input elements and buttons in the feedback form.
                themeOptions.outlineStyle.color = UIColor.systemGray
                themeOptions.outlineStyle.cornerRadius = 5
                themeOptions.outlineStyle.outlineWidth = 0.5
            }
            feedbackOptions.onFormOpen = {
                let breadcrumb = Breadcrumb(level: .info, category: "user_feedback")
                breadcrumb.message = "User opened feedback form"
                SentrySDK.addBreadcrumb(breadcrumb)

                let event = Event(level: .info)
                event.message = SentryMessage(formatted: "User opened feedback form")
                SentrySDK.capture(event: event)
            }
            feedbackOptions.onFormClose = {
                let breadcrumb = Breadcrumb(level: .info, category: "user_feedback")
                breadcrumb.message = "User closed feedback form"
                SentrySDK.addBreadcrumb(breadcrumb)

                let event = Event(level: .info)
                event.message = SentryMessage(formatted: "User closed feedback form")
                SentrySDK.capture(event: event)
            }
        }

        // Configure Other Options
        options.experimental.enableUnhandledCPPExceptionsV2 = false
    }

    var body: some Scene {
        WindowGroup {
            MainContainerView()
                .toaster(toastManager)
                .configureOnLaunch { options in
                    options.publicKey = "30d2f7cc2fa469eaf8e4bdf958ad9d66bce491a7da1fb08ff0a7156a8e15a47d"
                }
        }
        .modelContainer(
            for: [
                LinkListModel.self,
                LinkModel.self,
                DatabaseMetadata.self
            ],
            inMemory: false,
            isAutosaveEnabled: false,
            isUndoEnabled: false,
            onSetup: { result in
                switch result {
                case .failure(let error):
                    Self.logger.error("Failed to setup ModelContainer: \(error)")
                    SentrySDK.capture(error: error) { scope in
                        scope.setTag(value: "model_container_setup", key: "operation")
                        scope.setContext(
                            value: [
                                "action": "setting_up_model_container"
                            ], key: "error_details")
                    }

                case .success(let container):
                    let breadcrumb = Breadcrumb()
                    breadcrumb.message = "ModelContainer setup successful, starting data seeding check"
                    breadcrumb.category = "database.setup"
                    breadcrumb.level = .info
                    SentrySDK.addBreadcrumb(breadcrumb)

                    DataSeedingService.seedDataIfNeeded(modelContext: container.mainContext)
                }
            }
        )
    }
}
