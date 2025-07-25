import os.log
import Sentry
import SwiftUI

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
                    dismiss()
                } catch {
                    Self.logger.error("Failed to save link: \(error)")
                    let appError = AppError.persistenceError(.saveLinkFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            }
        )
    }
}
