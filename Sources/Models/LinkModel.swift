import Foundation
import SwiftData

@Model
final class LinkModel {
    /// Unique identifier for the link.
    var id: UUID

    /// Date when the link was created.
    var createdAt: Date

    /// Date when the link was last updated.
    var updatedAt: Date

    /// Name of the link.
    var name: String

    /// URL of the link.
    var url: URL

    /// Color of the link.
    var color: ListColor?

    /// Symbol of the link.
    var symbol: ListSymbol?

    /// Initializes a new instance of `LinkModel`.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the link.
    ///   - createdAt: Date when the link was created.
    ///   - updatedAt: Date when the link was last updated.
    ///   - name: Name of the link.
    ///   - color: Optional color of the link.
    ///   - symbol: Optional symbol of the link.
    ///   - url: URL of the link.
    init(id: UUID, createdAt: Date, updatedAt: Date, name: String, color: ListColor?, symbol: ListSymbol?, url: URL) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
        self.color = color
        self.symbol = symbol
        self.url = url
    }

    /// Convenience initializer with default values for `id`, `createdAt`, and `updatedAt`.
    convenience init(name: String, url: URL, color: ListColor? = nil, symbol: ListSymbol? = nil) {
        self.init(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            name: name,
            color: color,
            symbol: symbol,
            url: url
        )
    }
}
