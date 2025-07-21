import SwiftUI
import os.log
import Sentry

struct LinkListInfoContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.toaster) private var toaster

    @State private var name = ""
    @State private var color: ListColor = .default
    @State private var symbol: ListSymbol = .default

    let list: LinkListModel
    
    private static let logger = Logger(subsystem: "com.techprimate.Flinky", category: "LinkListInfoContainerView")

    var body: some View {
        LinkListInfoRenderView(
            name: $name,
            color: $color,
            symbol: $symbol,
            cancelAction: {
                dismiss()
            },
            saveAction: {
                list.name = name
                list.color = color
                list.symbol = symbol
                list.updatedAt = Date()

                do {
                    try modelContext.save()
                    dismiss()
                } catch {
                    Self.logger.error("Failed to save list changes: \(error)")
                    let appError = AppError.persistenceError(.saveListChangesFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            }
        )
        .onAppear {
            name = list.name
            color = list.color ?? .default
            symbol = list.symbol ?? .default
        }
    }
}
