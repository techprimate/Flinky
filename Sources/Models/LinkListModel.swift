import Foundation
import SwiftData

@Model
final class LinkListModel {
    /// Unique identifier for the link.
    var id: UUID

    /// Date when the link was created.
    var createdAt: Date

    /// Date when the link was last updated.
    var updatedAt: Date

    /// Name of the list.
    var name: String

    /// Color of the list.
    var color: ListColor?

    /// Symbol of the list.
    var symbol: ListSymbol?

    /// Links in the list.
    var links: [LinkModel]

    /// Flag to indicate that the list is pinned
    var isPinned: Bool

    /// Initializes a new instance of `LinkListModel`.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the link list.
    ///   - createdAt: Date when the link list was created.
    ///   - updatedAt: Date when the link list was last updated.
    ///   - name: Name of the list.
    ///   - color: Optional color of the list.
    ///   - symbol: Optional symbol of the list.
    ///   - links: Links in the list.
    ///   - isPinned: Flag to indicate that the list is pinned.
    init(
        id: UUID,
        createdAt: Date,
        updatedAt: Date,
        name: String,
        color: ListColor?,
        symbol: ListSymbol?,
        links: [LinkModel],
        isPinned: Bool
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
        self.color = color
        self.symbol = symbol
        self.links = links
        self.isPinned = isPinned
    }

    /// Convenience initializer with default values for `id`, `createdAt`, and `updatedAt`.
    convenience init(name: String, color: ListColor? = nil, symbol: ListSymbol? = nil, isPinned: Bool = false) {
        self.init(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            name: name,
            color: color,
            symbol: symbol,
            links: [],
            isPinned: isPinned
        )
    }
}
