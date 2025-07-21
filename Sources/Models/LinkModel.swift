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
    var color: LinkColor?

    /// Symbol of the link.
    var symbol: LinkSymbol?

    /// Initializes a new instance of `LinkModel`.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the link. Defaults to a new UUID.
    ///   - createdAt: Date when the link was created. Defaults to the current date.
    ///   - updatedAt: Date when the link was last updated. Defaults to the current date.
    ///   - name: Title of the link.
    ///   - color: Optional color of the link.
    ///   - symbol: Optional symbol of the link.
    ///   - url: URL of the link.
    init(id: UUID, createdAt: Date, updatedAt: Date, title: String, color: LinkColor?, symbol: LinkSymbol?, url: URL) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        name = title
        self.color = color
        self.symbol = symbol
        self.url = url
    }
}
