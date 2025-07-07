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

    /// Title of the link.
    var title: String

    /// URL of the link.
    var url: URL

    /// Initializes a new instance of `LinkModel`.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the link. Defaults to a new UUID.
    ///   - createdAt: Date when the link was created. Defaults to the current date.
    ///   - updatedAt: Date when the link was last updated. Defaults to the current date.
    ///   - title: Title of the link.
    ///   - url: URL of the link.
    init(id: UUID = UUID(), createdAt: Date = Date(), updatedAt: Date = Date(), title: String, url: URL) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.title = title
        self.url = url
    }
}
