import FlinkyCore
import Sentry
import SentrySwiftUI
import SwiftUI
import os.log

struct CreateLinkListEditorContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster

    @State private var name = ""

    var body: some View {
        CreateLinkListEditorRenderView(
            name: $name,
            saveAction: {
                let newItem = LinkListModel(
                    name: name
                )
                modelContext.insert(newItem)

                do {
                    try modelContext.save()

                    // Add Sentry breadcrumb for successful list creation
                    // Privacy-conscious breadcrumb - no PII (list names, URLs) included
                    let breadcrumb = Breadcrumb(level: .info, category: "list_management")
                    breadcrumb.message = "List created successfully"
                    breadcrumb.data = [
                        "list_id": newItem.id.uuidString
                            // Note: Removed list_name to protect user privacy
                    ]
                    SentrySDK.addBreadcrumb(breadcrumb)

                    // Track list creation using metrics - better for aggregate counts than individual events
                    SentryMetricsHelper.trackListCreated(creationFlow: "direct")

                    dismiss()
                } catch {
                    Self.logger.error("Failed to save list: \(error)")
                    let appError = AppError.persistenceError(
                        .saveListFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            }
        )
        .sentryTrace("CREATE_LINK_LIST_EDITOR_VIEW")
    }
}
