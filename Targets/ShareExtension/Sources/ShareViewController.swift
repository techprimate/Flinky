// swiftlint:disable file_length

import UIKit
import Social
import SwiftData
import FlinkyCore
import Sentry
import os.log
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController { // swiftlint:disable:this type_body_length
    // MARK: - Properties

    private static let logger = Logger.forType(ShareViewController.self)

    // MARK: Form State

    /// The name of the link being shared.
    private var name: String?

    /// The raw URL string being shared.
    private var rawUrl: String?

    /// The placeholder text for the text view.
    private var selectedList: LinkListModel?

    // MARK: Persistence

    /// The model container used for persistence in the share extension.
    private var modelContainer: ModelContainer?

    /// The model context used for operations in the share extension.
    private var modelContext: ModelContext?

    /// The lists that can be selected in the share extension.
    private var lists: Result<[LinkListModel], Error>?

    // MARK: - Instance Life Cycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupSentry()
        setupModelContainer()
        loadLists()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        setupSentry()
        setupModelContainer()
        loadLists()
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadShareItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Validate content after the view appears to enable the post button in case all required fields
        // have been pre-filled.
        self.validateContent()
    }

    private func setupSentry() {
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
        // Disable Sentry for tests because it produces a lot of noise.
        if ProcessInfo.processInfo.environment["TESTING"] == "1" {
            Self.logger.warning("Sentry is disabled in test environment")
            return
        }

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

        options.sampleRate = 0.2
        options.tracesSampleRate = 0.2

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

        // Configure Session Replay
        options.sessionReplay.onErrorSampleRate = 1.0
        options.sessionReplay.sessionSampleRate = 0.1
        options.sessionReplay.enableViewRendererV2 = true
        options.sessionReplay.enableFastViewRendering = false

        // Configure App Hang
        options.enableAppHangTracking = false
        options.enableReportNonFullyBlockingAppHangs = false

        // Configure File I/O
        options.enableFileIOTracing = true
        options.enableDataSwizzling = true
        options.enableFileManagerSwizzling = true

        // Configure Tracing
        options.enableAutoPerformanceTracing = true
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

        // Configure Other Options
        options.experimental.enableUnhandledCPPExceptionsV2 = false
    }

    private func setupModelContainer() {
        do {
            // Use shared App Group store to access the same database as the main app
            let modelContainer = try SharedModelContainerFactory.make()
            self.modelContainer = modelContainer

            let modelContext = modelContainer.mainContext
            self.modelContext = modelContext

            let breadcrumb = Breadcrumb(level: .info, category: "share_extension")
            breadcrumb.message = "ModelContainer setup successful in share extension"
            SentrySDK.addBreadcrumb(breadcrumb)
        } catch {
            let localDescription = "Failed to setup ModelContainer in share extension: \(error)"
            Self.logger.error("\(localDescription)")

            SentrySDK.capture(error: error) { scope in
                scope.setTag(value: "share_extension_model_container", key: "operation")
                scope.setContext(
                    value: [
                        "error_type": "model_container_setup_failed",
                        "creation_flow": "share_extension"
                    ],
                    key: "error_details"
                )
            }

            // The share extension cannot continue without a valid model context.
            // Therefore cancel the request with an error to signal the host app that something went wrong.
            self.extensionContext?.cancelRequest(withError: error)
        }
    }

    private func loadLists() { // swiftlint:disable:this function_body_length
        guard let modelContext = modelContext else {
            Self.logger.error("Model context is not available")
            let event = Event(level: .error)
            event.message = SentryMessage(formatted: "Failed to load lists due to missing model context")
            event.extra = [
                "creation_flow": "share_extension"
            ]
            SentrySDK.capture(event: event)
            return
        }

        do {
            // Load all lists that can be selected
            let fetchDescriptor = FetchDescriptor<LinkListModel>(
                sortBy: [SortDescriptor(\.name, comparator: .localized)]
            )
            var lists = try modelContext.fetch(fetchDescriptor)

            // If there are no lists yet (e.g. extension launched before the app), create a default one.
            if lists.isEmpty {
                let defaultList = LinkListModel(name: L10n.ShareExtension.DefaultList.name)
                modelContext.insert(defaultList)
                try? modelContext.save()
                lists = [defaultList]

                // Breadcrumb for debugging context
                let breadcrumb = Breadcrumb(level: .info, category: "list_management")
                breadcrumb.message = "Default list created in share extension"
                breadcrumb.data = [
                    "list_id": defaultList.id.uuidString
                ]
                SentrySDK.addBreadcrumb(breadcrumb)

                // Analytics: list_created (no PII)
                let event = Event(level: .info)
                event.message = SentryMessage(formatted: "list_created")
                event.extra = [
                    "list_id": defaultList.id.uuidString,
                    "entity_type": "list",
                    "creation_flow": "share_extension",
                    "auto_created": true
                ]
                SentrySDK.capture(event: event)
            }

            self.lists = .success(lists)

            // Select the first list if none is selected, so that the user can immediately post
            if selectedList == nil {
                selectedList = lists.first
            }

            // Refresh configuration items and validate so the UI is ready (enables chevron and Post button)
            self.reloadConfigurationItems()
            self.validateContent()
        } catch {
            Self.logger.error("Failed to fetch lists: \(error)")
            SentrySDK.capture(error: error) { scope in
                scope.setTag(value: "share_extension", key: "operation")
                scope.setContext(
                    value: [
                        "error_type": "list_fetch_failed",
                        "creation_flow": "share_extension"
                    ],
                    key: "error_details"
                )
            }
            self.lists = .failure(error)
        }
    }

    private func setupUI() {
        // URL text area
        self.placeholder = L10n.ShareExtension.Placeholder.loading
        self.textView.isEditable = true // Allow editing so that users can correct malformed URLs
        self.textView.isSelectable = true
        self.textView.dataDetectorTypes = .link
        self.textView.backgroundColor = .clear

        // Accessibility
        self.textView.accessibilityLabel = L10n.ShareExtension.Url.Accessibility.label
        self.textView.accessibilityHint = L10n.ShareExtension.Url.Accessibility.hint

        // Navigation
        self.navigationItem.title = L10n.ShareExtension.Nav.title
        self.navigationController?.navigationBar.topItem?.title = L10n.ShareExtension.Nav.title
    }

    private func loadShareItem() {
        guard let extensionContext = extensionContext else {
            Self.logger.error("Extension context not available")
            return
        }
        let inputItems = extensionContext.inputItems.compactMap { $0 as? NSExtensionItem }
        Task.detached { [weak self] in
            guard let self = self else { return }

            // Load items in the background to avoid blocking the main thread.
            //
            // Share extensions can be indicated as pending data by set the `valuePending` property on
            // the configuration items.
            await self.processInputItems(inputItems, extensionContext: extensionContext)
        }
    }

    private func processInputItems(_ items: [NSExtensionItem], extensionContext: NSExtensionContext) async {
        for item in items {
            do {
                guard let (name, url) = try await fetchNameAndUrl(item: item) else {
                    // Skip this item if no valid name or URL could be fetched.
                    // The fetch method already logs the error.
                    continue
                }
                // Update the share extension state on the main thread, as it is updating the UI, which must
                // be done on the main thread.
                await MainActor.run { [weak self] in
                    guard let self = self else { return }

                    self.name = name
                    self.rawUrl = url.absoluteString

                    // Show the URL
                    self.textView.text = url.absoluteString

                    // Update placeholder with selected list name when available
                    self.placeholder = L10n.ShareExtension.Placeholder.addToList(self.selectedList?.name ?? "")
                    self.reloadConfigurationItems()
                    self.validateContent()
                }

                // Exit the method after processing the first item.
                return
            } catch {
                Self.logger.error("Failed to process input item: \(error)")
                SentrySDK.capture(error: error) { scope in
                    scope.setTag(value: "share_extension", key: "operation")
                    scope.setContext(
                        value: [
                            "error_type": "input_item_processing_failed",
                            "creation_flow": "share_extension"
                        ],
                        key: "error_details"
                    )
                }
                // Continue to the next item if processing fails
            }
        }

        // If no valid items were found, cancel the extension request with an error and log the error.
        // This case should not happen in normal usage, because the extension should be configured to run with
        // at least one valid URL item.
        //
        // By cancelling the request, we signal to the host app that something went wrong
        // and it should not expect any data to be returned.
        //
        // Using Sentry we can capture these cases to ensure they are not happening in production.
        let error = NSError(
            domain: "ShareExtensionError",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "No valid URL found in shared items"]
        )
        Self.logger.error("No valid URL found in shared items, cancelling extension request")

        SentrySDK.capture(error: error) { scope in
            scope.setTag(value: "share_extension", key: "operation")
            scope.setContext(
                value: [
                    "error_type": "no_valid_url_found",
                    "creation_flow": "share_extension"
                ],
                key: "error_details"
            )
        }
    }

    private func fetchNameAndUrl(item: NSExtensionItem) async throws -> (name: String, url: URL)? {
        guard let attachment = item.attachments?.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.url.identifier) }) else {
            return nil
        }

        let url: URL
        do {
            let item = try await attachment.loadItem(forTypeIdentifier: UTType.url.identifier)
            guard let itemUrl = item as? URL else {
                throw NSError(domain: "ShareExtensionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Item is not a valid URL"])
            }
            url = itemUrl
        } catch {
            Self.logger.error("Failed to load item for type identifier: \(UTType.url.identifier), error: \(error)")
            SentrySDK.capture(error: error) { scope in
                scope.setTag(value: "share_extension", key: "operation")
                scope.setContext(
                    value: [
                        "error_type": "url_load_failed",
                        "creation_flow": "share_extension"
                    ],
                    key: "error_details"
                )
            }

            // Return nil as there might be other items that can be processed.
            return nil
        }

        var name = item.attributedContentText?.string.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if name.isEmpty {
            // Fallback to URL host if name is empty
            name = url.host ?? url.absoluteString
        }

        return (name: name, url: url)
    }

    // MARK: - SLComposeServiceViewController Methods

    override func isContentValid() -> Bool {
        guard let url = URL(string: rawUrl ?? "") else {
            return false
        }
        return !url.absoluteString.isEmpty && selectedList != nil
    }

    override func didSelectPost() { // swiftlint:disable:this function_body_length
        guard let modelContext = modelContext else {
            Self.logger.error("Model context is not available")
            let event = Event(level: .error)
            event.message = SentryMessage(formatted: "Failed to create link due to missing model context")
            event.extra = [
                "creation_flow": "share_extension",
                "action": "create_link"
            ]
            SentrySDK.capture(event: event)
            return
        }
        guard let url = URL(string: rawUrl ?? "") else {
            Self.logger.error("Failed to create link due to invalid URL: \(self.rawUrl ?? "nil")")
            let event = Event(level: .error)
            event.message = SentryMessage(formatted: "Failed to create link due to invalid URL")
            event.extra = [
                "creation_flow": "share_extension",
                "action": "create_link"
            ]
            SentrySDK.capture(event: event)
            return
        }
        guard let name = self.name, !name.isEmpty else {
            Self.logger.error("Link created without a name")
            let event = Event(level: .error)
            event.message = SentryMessage(formatted: "Link created without a name")
            event.extra = [
                "creation_flow": "share_extension",
                "action": "create_link"
            ]
            SentrySDK.capture(event: event)
            return
        }
        guard let list = selectedList else {
            let event = Event(level: .error)
            event.message = SentryMessage(formatted: "Failed to create link due to no selected list")
            event.extra = [
                "creation_flow": "share_extension",
                "action": "create_link"
            ]
            SentrySDK.capture(event: event)
            return
        }

        let newLink = LinkModel(name: name, url: url)
        modelContext.insert(newLink)

        // Add link to the selected list
        list.links.append(newLink)
        list.updatedAt = Date()

        do {
            try modelContext.save()
            Self.logger.info("Link saved successfully via share extension")

            let breadcrumb = Breadcrumb(level: .info, category: "link_management")
            breadcrumb.message = "Link created successfully via share extension"
            breadcrumb.data = [
                "link_id": newLink.id.uuidString,
                "list_id": list.id.uuidString,
                "creation_flow": "share_extension"
            ]
            SentrySDK.addBreadcrumb(breadcrumb)

            let event = Event(level: .info)
            event.message = SentryMessage(formatted: "link_created")
            event.extra = [
                "link_id": newLink.id.uuidString,
                "list_id": list.id.uuidString,
                "entity_type": "link",
                "creation_flow": "share_extension"
            ]
            SentrySDK.capture(event: event)

            // Post an accessibility announcement to inform users, especially those using VoiceOver or other assistive technologies,
            // that the link has been successfully saved. This ensures that users with visual impairments receive immediate, audible feedback
            // about the completion of the action, improving the app's accessibility and user experience. The announcement uses a localized
            // string to provide contextually appropriate feedback in the user's language.
            UIAccessibility.post(notification: .announcement, argument: L10n.ShareExtension.Success.linkSaved)

            // Complete the extension request to signal that the share extension has finished its work.
            super.didSelectPost()
        } catch {
            Self.logger.error("Failed to save link: \(error)")
            let appError = AppError.persistenceError(
                .saveLinkFailed(underlyingError: error.localizedDescription))
            SentrySDK.capture(error: appError) { scope in
                scope.setTag(value: "share_extension", key: "operation")
                scope.setContext(
                    value: [
                        "error_type": "link_save_failed",
                        "creation_flow": "share_extension"
                    ],
                    key: "error_details"
                )
            }

            // Do not complete or cancel the extension request here, so that a user can retry saving the link.
        }
    }

    override func didSelectCancel() {
        let breadcrumb = Breadcrumb(level: .info, category: "share_extension")
        breadcrumb.message = "User cancelled share extension"
        SentrySDK.addBreadcrumb(breadcrumb)

        // Post an accessibility announcement to inform users that the share action was cancelled.
        // This is especially useful for users relying on VoiceOver or other assistive technologies,
        // ensuring they receive immediate, audible feedback about the cancellation.
        UIAccessibility.post(notification: .announcement, argument: FlinkyCore.L10n.Shared.Button.cancel)

        Self.logger.debug("User cancelled the share extension")
        super.didSelectCancel()
    }

    override func configurationItems() -> [Any]? {
        var items: [SLComposeSheetConfigurationItem] = []
        if let nameItem = nameConfigurationItem {
            items.append(nameItem)
        }
        if let pickerItem = listPickerConfigurationItem {
            items.append(pickerItem)
        }
        return items as [Any]
    }

    /// Creates a configuration item to edit the name in a detail page
    private var nameConfigurationItem: SLComposeSheetConfigurationItem? {
        guard let item = SLComposeSheetConfigurationItem() else {
            Self.logger.error("Failed to create name configuration item")
            let event = Event(level: .error)
            event.message = SentryMessage(formatted: "Failed to create name configuration item")
            event.extra = [
                "creation_flow": "share_extension"
            ]
            SentrySDK.capture(event: event)

            return nil
        }

        item.title = L10n.ShareExtension.Name.title
        item.value = name
        item.valuePending = name == nil
        item.tapHandler = { [weak self] in
            guard let self = self else { return }

            let controller = TextInputViewController()
            controller.initialText = self.name ?? ""
            controller.onSave = { text in
                self.name = text
                self.reloadConfigurationItems()
                self.validateContent()
            }

            // Only the push configuration view controller navigation is supported in the share extension
            self.pushConfigurationViewController(controller)
        }

        return item
    }

    /// Creates a configuration item to select the list
    private var listPickerConfigurationItem: SLComposeSheetConfigurationItem? {
        guard let item = SLComposeSheetConfigurationItem() else {
            Self.logger.error("Failed to create list picker configuration item")
            let event = Event(level: .error)
            event.message = SentryMessage(formatted: "Failed to create list picker configuration item")
            event.extra = [
                "creation_flow": "share_extension"
            ]
            SentrySDK.capture(event: event)

            return nil
        }
        item.title = L10n.ShareExtension.ListPicker.title
        switch lists {
        case .failure(let error):
            item.value = error.localizedDescription
        default:
            item.value = selectedList?.name
        }
        item.valuePending = lists == nil
        item.tapHandler = { [weak self] in
            guard let self = self else { return }
            guard case .success(let lists) = self.lists else {
                return
            }

            let items = lists.map { ItemPickerViewController.Item(id: $0.id, name: $0.name) }
            let controller = ItemPickerViewController(options: items, selected: self.selectedList?.id)
            controller.onSelect = { itemId in
                self.selectedList = lists.first(where: { $0.id == itemId })
                self.reloadConfigurationItems()
                self.validateContent()
            }

            // Only the push configuration view controller navigation is supported in the share extension
            self.pushConfigurationViewController(controller)
        }
        return item
    }
}

// swiftlint:enable file_length
