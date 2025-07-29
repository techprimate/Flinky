import Sentry
import SentrySwiftUI
import SwiftUI
import os.log

struct CreateLinkEditorContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster

    @State private var name = ""
    @State private var url = ""

    let list: LinkListModel

    var body: some View {
        CreateLinkEditorRenderView(
            name: $name,
            url: $url,
            saveAction: {
                guard let url = URL(string: url) else {
                    preconditionFailure("Validation of URL was not performed before saving")
                }
                let link = LinkModel(
                    name: name,
                    url: url
                )
                modelContext.insert(link)
                list.links.append(link)
                list.updatedAt = Date()

                do {
                    try modelContext.save()

                    // Add Sentry breadcrumb for successful link creation - provides context for debugging
                    // Include both link_id and list_id to track relationships between entities
                    let breadcrumb = Breadcrumb(level: .info, category: "link_management")
                    breadcrumb.message = "Link created successfully"
                    breadcrumb.data = [
                        "link_id": link.id.uuidString,
                        "list_id": list.id.uuidString,
                        "has_color": false,  // Track customization level for UX insights
                        "has_symbol": false
                    ]
                    SentrySDK.addBreadcrumb(breadcrumb)

                    // Track usage event for analytics - using Event object instead of simple message
                    // to capture structured metadata for better analytics querying and filtering
                    let event = Event(level: .info)
                    event.message = SentryMessage(formatted: "link_created")
                    event.extra = [
                        "link_id": link.id.uuidString,
                        "list_id": list.id.uuidString,
                        "entity_type": "link"  // Consistent entity typing for cross-feature analytics
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
        )
        .sentryTrace("CREATE_LINK_EDITOR_VIEW")
    }
}
