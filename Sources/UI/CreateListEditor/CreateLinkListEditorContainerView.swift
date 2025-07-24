import SwiftUI
import os.log
import Sentry

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
                    dismiss()
                } catch {
                    Self.logger.error("Failed to save list: \(error)")
                    let appError = AppError.persistenceError(.saveListFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            }
        )
    }
}
