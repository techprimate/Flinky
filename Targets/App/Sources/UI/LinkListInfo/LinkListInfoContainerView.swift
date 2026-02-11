import FlinkyCore
import SentrySPM
import SwiftUI
import os.log

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
                // Track color and symbol usage if they changed
                let isColorChanged = list.color != color
                let isSymbolChanged = list.symbol != symbol

                list.name = name
                list.color = color
                list.symbol = symbol
                list.updatedAt = Date()

                do {
                    try modelContext.save()

                    // Track list update with customization change tracking
                    // Mirror link update pattern for consistent analytics across entity types
                    let breadcrumb = Breadcrumb(level: .info, category: "list_management")
                    breadcrumb.message = "List updated successfully"
                    breadcrumb.data = [
                        "list_id": list.id.uuidString,
                        "color": color.rawValue,
                        "symbol": symbol.rawValue,
                        "color_changed": isColorChanged,  // Track customization engagement
                        "symbol_changed": isSymbolChanged
                    ]
                    SentrySDK.addBreadcrumb(breadcrumb)

                    // Track list color selection for customization feature analytics
                    // Using metrics for better aggregate counts than individual events
                    if isColorChanged {
                        SentryMetricsHelper.trackColorSelected(color: color.rawValue, entityType: "list")
                    }

                    // Track list symbol selection with consistent structure
                    if isSymbolChanged {
                        SentryMetricsHelper.trackSymbolSelected(symbol: symbol.rawValue, entityType: "list")
                    }

                    dismiss()
                } catch {
                    Self.logger.error("Failed to save list changes: \(error)")
                    let appError = AppError.persistenceError(
                        .saveListChangesFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            }
        )
        .sentryTrace("LINK_LIST_EDITOR")
        .onAppear {
            name = list.name
            color = list.color ?? .defaultForList
            symbol = list.symbol ?? .defaultForList
        }
    }
}
