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
    ///   - links: Links in the list.
    init(id: UUID, createdAt: Date, updatedAt: Date, name: String, links: [LinkModel], isPinned: Bool) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
        self.links = links
        self.isPinned = isPinned
    }
}
