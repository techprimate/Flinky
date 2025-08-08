import FlinkyCore
import Sentry
import SentrySwiftUI
import SwiftData
import SwiftUI
import os.log

struct CreateLinkWithListPickerEditorContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster

    @Query private var lists: [LinkListModel]
    @State private var selectedList: LinkListModel?

    @State private var name = ""
    @State private var url = ""

    var body: some View {
        renderView
            .onAppear {
                // If no list is selected, default to the first available list
                if selectedList == nil {
                    selectedList = lists.first
                }
            }
            .onChange(of: lists) { _, newLists in
                // If no list is selected, default to the first available list
                if selectedList == nil {
                    selectedList = newLists.first
                }
            }
    }

    @ViewBuilder private var renderView: some View {
        if let list = selectedList {
            CreateLinkWithListPickerEditorRenderView(
                name: $name,
                url: $url,
                selectedList: .init(
                    id: list.id,
                    name: list.name,
                    symbol: list.symbol ?? .defaultForList,
                    color: list.color ?? .defaultForList
                ),
                saveAction: {
                    guard let url = URL(string: url) else {
                        preconditionFailure("Validation of URL was not performed before saving")
                    }
                    let newItem = LinkModel(
                        name: name,
                        url: url
                    )
                    modelContext.insert(newItem)
                    list.links.append(newItem)
                    list.updatedAt = Date()

                    do {
                        try modelContext.save()

                        // Add Sentry breadcrumb for successful link creation from list picker flow
                        // Track both entities to understand which lists are popular for new links
                        let breadcrumb = Breadcrumb(level: .info, category: "link_management")
                        breadcrumb.message = "Link created successfully"
                        breadcrumb.data = [
                            "link_id": newItem.id.uuidString,
                            "list_id": list.id.uuidString,
                            "has_color": false,  // Currently no customization in this flow
                            "has_symbol": false
                        ]
                        SentrySDK.addBreadcrumb(breadcrumb)

                        // Track usage event with structured data for analytics segmentation
                        // This helps distinguish between different link creation flows
                        let event = Event(level: .info)
                        event.message = SentryMessage(formatted: "link_created")
                        event.extra = [
                            "link_id": newItem.id.uuidString,
                            "list_id": list.id.uuidString,
                            "entity_type": "link",
                            "creation_flow": "list_picker"  // Distinguish from direct list creation
                        ]
                        SentrySDK.capture(event: event)

                        dismiss()
                    } catch {
                        Self.logger.error("Failed to save link: \(error)")
                        let appError = AppError.persistenceError(
                            .saveLinkFailed(underlyingError: error.localizedDescription))
                        SentrySDK.capture(error: appError)
                        toaster.show(error: appError)
                    }
                }
            ) {  // swiftlint:disable:this multiple_closures_with_trailing_closure
                LinkListPickerContainerView(
                    preselectedList: list,
                    didSelectList: { list in
                        self.selectedList = list
                    }
                )
            }
            .sentryTrace("CREATE_LINK_WITH_LIST_PICKER_EDITOR_VIEW")
        } else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}
