import SwiftUI
import os.log
import Sentry

struct CreateLinkListEditorContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster
    
    private static let logger = Logger(subsystem: "com.techprimate.Flinky", category: "CreateLinkListEditorContainerView")

    var body: some View {
        CreateLinkListEditorRenderView { data in
            let newItem = LinkListModel(
                id: UUID(),
                createdAt: Date(),
                updatedAt: Date(),
                name: data.name,
                color: nil,
                symbol: nil,
                links: [],
                isPinned: false
            )
            modelContext.insert(newItem)

            do {
                try modelContext.save()
                dismiss()
            } catch {
                Self.logger.error("Failed to save list: \(error)")
                let appError = AppError.persistenceError(.saveListFailed(underlyingError: error.localizedDescription))
                SentrySDK.capture(error: appError)
                toaster.show(error: appError)
            }
        }
    }
}
