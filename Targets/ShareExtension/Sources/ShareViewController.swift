//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Philip Niedertscheider on 08.08.25.
//

import UIKit
import Social
import SwiftData
import FlinkyCore
import Sentry
import os.log
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {
    // MARK: - Properties

    private static let logger = Logger.forType(ShareViewController.self)

    private var name: String?
    private var rawUrl: String?
    private var selectedList: LinkListModel?

    private var lists: Result<[LinkListModel], Error>?

    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupModelContainer()
        loadLists()
        setupUI()
        loadShareItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.validateContent()
    }

    private func setupModelContainer() {
        do {
            let modelContainer = try ModelContainer(
                for: LinkListModel.self, LinkModel.self, DatabaseMetadata.self
            )
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
        }
    }

    private func loadLists() {
        guard let modelContext = modelContext else {
            Self.logger.error("Model context is not available")
            let breadcrumb = Breadcrumb(level: .error, category: "share_extension")
            breadcrumb.message = "Failed to load lists due to missing model context"
            breadcrumb.data = [
                "creation_flow": "share_extension"
            ]
            SentrySDK.addBreadcrumb(breadcrumb)
            return
        }
        do {
            // Load all lists that can be selected
            let fetchDescriptor = FetchDescriptor<LinkListModel>(
                sortBy: [SortDescriptor(\.name, comparator: .localized)]
            )
            let lists = try modelContext.fetch(fetchDescriptor)
            self.lists = .success(lists)

            // Select the first list if none is selected, so that the user can immediately post
            if selectedList == nil {
                selectedList = lists.first
            }

            // Validate content after loading lists so the UI is ready
            self.validateContent()
        } catch {
            Self.logger.error("Failed to fetch lists: \(error)")
            let breadcrumb = Breadcrumb(level: .error, category: "share_extension")
            breadcrumb.message = "Failed to load lists"
            breadcrumb.data = [
                "creation_flow": "share_extension",
                "error": error.localizedDescription
            ]
            SentrySDK.addBreadcrumb(breadcrumb)
            self.lists = .failure(error)
        }
    }

    private func setupUI() {
        // Setup text view
        self.placeholder = L10n.ShareExtension.Error.noUrl

        // Setup accessibility
        self.textView.accessibilityLabel = "URL"
        self.textView.accessibilityHint = "The URL being shared"
        self.textView.accessibilityTraits = .staticText

        // Setup navigation
        self.navigationItem.title = "Add to Flinky"
        self.navigationController?.navigationBar.topItem?.title = "Add to Flinky"
    }

    private func loadShareItem() {
        guard let extensionContext = extensionContext else {
            Self.logger.error("Extension context not available")
            return
        }
        let inputItems = extensionContext.inputItems.compactMap { $0 as? NSExtensionItem }
        Task.detached {
            await self.processInputItems(inputItems, extensionContext: extensionContext)
        }
    }

    private func processInputItems(_ items: [NSExtensionItem], extensionContext: NSExtensionContext) async {
        for item in items {
            do {
                guard let (name, url) = try await fetchNameAndUrl(item: item) else {
                    continue
                }
                await MainActor.run { [weak self] in
                    self?.name = name
                    self?.rawUrl = url.absoluteString
                    // Show the URL and make the text view read-only
                    self?.textView.text = url.absoluteString
                    // Update placeholder with selected list name when available
                    self?.placeholder = L10n.ShareExtension.Placeholder.addToList(self?.selectedList?.name ?? "")
                    self?.reloadConfigurationItems()
                    self?.validateContent()
                }
                return
            } catch {
                Self.logger.error("Failed to process input item: \(error)")
                let breadcrumb = Breadcrumb(level: .error, category: "share_extension")
                breadcrumb.message = "Failed to process input item"
                breadcrumb.data = [
                    "creation_flow": "share_extension",
                    "error": error.localizedDescription
                ]
                SentrySDK.addBreadcrumb(breadcrumb)
            }
        }
    }

    private func fetchNameAndUrl(item: NSExtensionItem) async throws -> (name: String, url: URL)? {
        guard let attachment = item.attachments?.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.url.identifier) || $0.canLoadObject(ofClass: URL.self) || $0.canLoadObject(ofClass: NSURL.self) || $0.canLoadObject(ofClass: NSString.self) }) else {
            return nil
        }

        // Prefer explicit class loading to avoid noisy expectedValueClass logs
        let url: URL
        if attachment.canLoadObject(ofClass: URL.self) {
            url = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
                _ = attachment.loadObject(ofClass: URL.self) { object, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let url = object {
                        continuation.resume(returning: url)
                    } else if let nsurl = object as? NSURL {
                        continuation.resume(returning: nsurl as URL)
                    } else {
                        continuation.resume(throwing: NSError(domain: "ShareExtension", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported URL object type"]))
                    }
                }
            }
        } else if attachment.canLoadObject(ofClass: NSURL.self) {
            url = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
                _ = attachment.loadObject(ofClass: NSURL.self) { object, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let nsurl = object as? NSURL {
                        continuation.resume(returning: nsurl as URL)
                    } else {
                        continuation.resume(throwing: NSError(domain: "ShareExtension", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported NSURL object type"]))
                    }
                }
            }
        } else if attachment.canLoadObject(ofClass: NSString.self) {
            let urlString: String = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
                _ = attachment.loadObject(ofClass: NSString.self) { object, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let str = object as? NSString {
                        continuation.resume(returning: str as String)
                    } else {
                        continuation.resume(throwing: NSError(domain: "ShareExtension", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported NSString object type"]))
                    }
                }
            }
            guard let builtUrl = URL(string: urlString) else { return nil }
            url = builtUrl
        } else {
            // As a last resort, skip to avoid calling loadItem(forTypeIdentifier:) which logs noisy messages
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

    override func didSelectPost() {
        guard let modelContext = modelContext else {
            Self.logger.error("Model context is not available")
            let breadcrumb = Breadcrumb(level: .error, category: "share_extension")
            breadcrumb.message = "Failed to create link due to missing model context"
            breadcrumb.data = [
                "creation_flow": "share_extension"
            ]
            SentrySDK.addBreadcrumb(breadcrumb)
            return
        }
        guard let url = URL(string: rawUrl ?? "") else {
            Self.logger.error("Failed to create link due to invalid URL: \(self.rawUrl ?? "nil")")
            let breadcrumb = Breadcrumb(level: .error, category: "share_extension")
            breadcrumb.message = "Failed to create link due to invalid URL"
            breadcrumb.data = [
                "creation_flow": "share_extension"
            ]
            SentrySDK.addBreadcrumb(breadcrumb)
            return
        }
        guard let name = self.name, !name.isEmpty else {
            Self.logger.warning("Link created without a name")
            let breadcrumb = Breadcrumb(level: .warning, category: "share_extension")
            breadcrumb.message = "Link created without a name"
            breadcrumb.data = [
                "creation_flow": "share_extension"
            ]
            SentrySDK.addBreadcrumb(breadcrumb)
            return
        }
        guard let list = selectedList else {
            let breadcrumb = Breadcrumb(level: .error, category: "share-extension")
            breadcrumb.message = "Failed to create link due to no selected list"
            breadcrumb.data = [
                "creation_flow": "share_extension"
            ]
            SentrySDK.addBreadcrumb(breadcrumb)
            return
        }

        let newLink = LinkModel(name: name, url: url)
        modelContext.insert(newLink)

        // Add link to the selected list
        list.links.append(newLink)
        list.updatedAt = Date()

        do {
            try modelContext.save()

            // Success tracking
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

            // Announce success for accessibility
            UIAccessibility.post(notification: .announcement, argument: L10n.ShareExtension.Success.linkSaved)

            Self.logger.info("Link saved successfully via share extension")

            // Complete the extension request
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        } catch {
            Self.logger.error("Failed to save link: \(error)")
            let appError = AppError.persistenceError(
                .saveLinkFailed(underlyingError: error.localizedDescription))
            SentrySDK.capture(error: appError)
        }
    }

    override func didSelectCancel() {
        let breadcrumb = Breadcrumb(level: .info, category: "share_extension")
        breadcrumb.message = "User cancelled share extension"
        SentrySDK.addBreadcrumb(breadcrumb)

        // Accessibility announcement
        UIAccessibility.post(notification: .announcement, argument: FlinkyCore.L10n.Shared.Button.cancel)

        Self.logger.debug("User cancelled the share extension")

        super.didSelectCancel()
    }

    override func configurationItems() -> [Any]! {
        let nameItem = SLComposeSheetConfigurationItem()
        nameItem?.title = "Name"
        nameItem?.value = name
        nameItem?.valuePending = name == nil
        nameItem?.tapHandler = {
            let controller = TextInputViewController()
            controller.initialText = self.name ?? ""
            controller.onSave = { text in
                self.name = text
                self.reloadConfigurationItems()
                self.validateContent()
            }
            self.pushConfigurationViewController(controller)
        }

        let pickerItem = SLComposeSheetConfigurationItem()
        pickerItem?.title = "List"
        switch lists {
        case .failure(let error):
            pickerItem?.value = error.localizedDescription
        default:
            pickerItem?.value = selectedList?.name
        }
        pickerItem?.valuePending = lists == nil
        pickerItem?.tapHandler = {
            guard case .success(let lists) = self.lists else {
                return
            }
            let items = lists.map { PickerViewController.Item(id: $0.id, name: $0.name) }
            let controller = PickerViewController(options: items, selected: self.selectedList?.id)
            controller.onSelect = { itemId in
                self.selectedList = lists.first(where: { $0.id == itemId })
                self.reloadConfigurationItems()
                self.validateContent()
            }
            self.pushConfigurationViewController(controller)
        }

        return [
            nameItem as Any,
            pickerItem as Any
        ]
    }
}

class TextInputViewController: UIViewController {
    var initialText: String = ""
    var onSave: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let textField = UITextField(frame: CGRect(x: 20, y: 100, width: 280, height: 44))
        textField.text = initialText
        textField.borderStyle = .roundedRect
        view.addSubview(textField)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }

    @objc func doneTapped() {
        if let textField = view.subviews.first(where: { $0 is UITextField }) as? UITextField {
            onSave?(textField.text ?? "")
            navigationController?.popViewController(animated: true)
        }
    }
}

class PickerViewController: UITableViewController {
    struct Item: Identifiable {
        let id: UUID
        let name: String
    }

    let options: [Item]
    let selected: Item.ID?
    var onSelect: ((Item.ID) -> Void)?

    init(options: [Item], selected: Item.ID?) {
        self.options = options
        self.selected = selected
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let option = options[indexPath.row]
        cell.textLabel?.text = option.name
        cell.accessoryType = option.id == selected ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(options[indexPath.row].id)
        navigationController?.popViewController(animated: true)
    }
}
