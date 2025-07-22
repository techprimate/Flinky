import SwiftUI
import os.log
import Sentry

struct LinkInfoContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.toaster) private var toaster

    @State private var name = ""
    @State private var color: ListColor = .default
    @State private var symbol: ListSymbol = .defaultForLink

    let link: LinkModel
    
    private static let logger = Logger(subsystem: "com.techprimate.Flinky", category: "LinkInfoContainerView")

    var body: some View {
        LinkInfoRenderView(
            name: $name,
            color: $color,
            symbol: $symbol,
            cancelAction: {
                dismiss()
            },
            saveAction: {
                link.name = name
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
            color = link.color ?? .default
            symbol = link.symbol ?? .defaultForLink
        }
    }
}
