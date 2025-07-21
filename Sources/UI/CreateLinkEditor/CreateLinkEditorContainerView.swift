import SwiftUI
import os.log
import Sentry

struct CreateLinkEditorContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster

    let list: LinkListModel
    
    private static let logger = Logger(subsystem: "com.techprimate.Flinky", category: "CreateLinkEditorContainerView")

    var body: some View {
        CreateLinkEditorRenderView { data in
            let newItem = LinkModel(
                id: UUID(),
                createdAt: Date(),
                updatedAt: Date(),
                name: data.title,
                color: nil,
                symbol: nil,
                url: data.url
            )
            modelContext.insert(newItem)
            list.links.append(newItem)
            list.updatedAt = Date()

            // Save the context to persist the new link
            do {
                try modelContext.save()
                dismiss()
            } catch {
                Self.logger.error("Failed to save link: \(error)")
                let appError = AppError.persistenceError(.saveLinkFailed(underlyingError: error.localizedDescription))
                SentrySDK.capture(error: appError)
                toaster.show(error: appError)
            }
        }
    }
}
