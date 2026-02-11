import FlinkyCore
import SentrySPM
import SwiftUI
import os.log

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
                // Track color and symbol usage if they changed
                let isColorChanged = link.color != color
                let isSymbolChanged = link.symbol != symbol

                link.name = name
                link.url = url
                link.color = color
                link.symbol = symbol
                link.updatedAt = Date()

                do {
                    try modelContext.save()

                    // Track link update with change detection for UX insights
                    // Boolean flags help understand which customization features are used
                    let breadcrumb = Breadcrumb(level: .info, category: "link_management")
                    breadcrumb.message = "Link updated successfully"
                    breadcrumb.data = [
                        "link_id": link.id.uuidString,
                        "color": color.rawValue,
                        "symbol": symbol.rawValue,
                        "color_changed": isColorChanged,  // Track if users actually customize
                        "symbol_changed": isSymbolChanged
                    ]
                    SentrySDK.addBreadcrumb(breadcrumb)

                    // Track color selection only when changed to avoid noise
                    // Using metrics for better aggregate counts than individual events
                    if isColorChanged {
                        SentryMetricsHelper.trackColorSelected(color: color.rawValue, entityType: "link")
                    }

                    // Track symbol selection separately for granular customization analytics
                    if isSymbolChanged {
                        SentryMetricsHelper.trackSymbolSelected(symbol: symbol.rawValue, entityType: "link")
                    }

                    dismiss()
                } catch {
                    Self.logger.error("Failed to save link changes: \(error)")
                    let appError = AppError.persistenceError(
                        .saveLinkChangesFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            }
        )
        .sentryTrace("LINK_EDITOR_VIEW")
        .onAppear {
            name = link.name
            url = link.url.absoluteString
            color = link.color ?? .defaultForLink
            symbol = link.symbol ?? .defaultForLink
        }
    }
}
