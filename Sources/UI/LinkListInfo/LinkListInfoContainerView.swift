import os.log
import Sentry
import SwiftUI

struct LinkListInfoContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.toaster) private var toaster

    @State private var name = ""
    @State private var color: ListColor = .defaultForList
    @State private var symbol: ListSymbol = .defaultForList

    let list: LinkListModel

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
            color = list.color ?? .defaultForList
            symbol = list.symbol ?? .defaultForList
        }
    }
}
