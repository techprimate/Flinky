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
                        "color_changed": isColorChanged, // Track customization engagement
                        "symbol_changed": isSymbolChanged
                    ]
                    SentrySDK.addBreadcrumb(breadcrumb)
                    
                    // Track list color selection for customization feature analytics
                    // Only fire when actually changed to reduce event volume
                    if isColorChanged {
                        let colorEvent = Event(level: .info)
                        colorEvent.message = SentryMessage(formatted: "list_color_selected")
                        colorEvent.extra = [
                            "color": color.rawValue, // Track which list colors are popular
                            "entity_type": "list" // Enables cross-entity color preference analysis
                        ]
                        SentrySDK.capture(event: colorEvent)
                    }
                    
                    // Track list symbol selection with consistent event structure
                    if isSymbolChanged {
                        let symbolEvent = Event(level: .info)
                        symbolEvent.message = SentryMessage(formatted: "list_symbol_selected")
                        symbolEvent.extra = [
                            "symbol": symbol.rawValue, // Measure symbol popularity for lists
                            "entity_type": "list" // Compare with link symbol usage patterns
                        ]
                        SentrySDK.capture(event: symbolEvent)
                    }
                    
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
