import os.log
import Sentry
import SwiftUI

struct LinkInfoContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.toaster) private var toaster

    @State private var name = ""
    @State private var url = ""
    @State private var color: ListColor = .defaultForLink
    @State private var symbol: ListSymbol = .defaultForLink

    let link: LinkModel

    var body: some View {
        LinkInfoRenderView(
            name: $name,
            url: $url,
            color: $color,
            symbol: $symbol,
            cancelAction: {
                dismiss()
            },
            saveAction: {
                guard let url = URL(string: url) else {
                    preconditionFailure("Validation of URL was not performed before saving")
                }
                link.name = name
                link.url = url
                link.color = color
                link.symbol = symbol
                link.updatedAt = Date()

                do {
                    try modelContext.save()
                    dismiss()
                } catch {
                    Self.logger.error("Failed to save link changes: \(error)")
                    let appError = AppError.persistenceError(.saveLinkChangesFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            }
        )
        .onAppear {
            name = link.name
            url = link.url.absoluteString
            color = link.color ?? .defaultForLink
            symbol = link.symbol ?? .defaultForLink
        }
    }
}
