import Sentry
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
                    // Separate events for color/symbol enable customization feature analysis
                    if isColorChanged {
                        let colorEvent = Event(level: .info)
                        colorEvent.message = SentryMessage(formatted: "link_color_selected")
                        colorEvent.extra = [
                            "color": color.rawValue,  // Track which colors are popular
                            "entity_type": "link"  // Enables comparison with list color usage
                        ]
                        SentrySDK.capture(event: colorEvent)
                    }

                    // Track symbol selection separately for granular customization analytics
                    if isSymbolChanged {
                        let symbolEvent = Event(level: .info)
                        symbolEvent.message = SentryMessage(formatted: "link_symbol_selected")
                        symbolEvent.extra = [
                            "symbol": symbol.rawValue,  // Track symbol popularity
                            "entity_type": "link"  // Cross-entity symbol usage comparison
                        ]
                        SentrySDK.capture(event: symbolEvent)
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
        .onAppear {
            name = link.name
            url = link.url.absoluteString
            color = link.color ?? .defaultForLink
            symbol = link.symbol ?? .defaultForLink
        }
    }
}
