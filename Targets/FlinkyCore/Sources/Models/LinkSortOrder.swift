import Foundation

public enum LinkSortOrder: String, CaseIterable, Identifiable, Codable {
    case nameAscending
    case nameDescending
    case createdAtNewest
    case createdAtOldest
    case updatedAtNewest
    case updatedAtOldest

    public var id: RawValue { rawValue }

    public static var `default`: Self { .nameAscending }

    public var name: String {
        switch self {
        case .nameAscending:
            return L10n.Shared.SortOrder.nameAscending
        case .nameDescending:
            return L10n.Shared.SortOrder.nameDescending
        case .createdAtNewest:
            return L10n.Shared.SortOrder.createdAtNewest
        case .createdAtOldest:
            return L10n.Shared.SortOrder.createdAtOldest
        case .updatedAtNewest:
            return L10n.Shared.SortOrder.updatedAtNewest
        case .updatedAtOldest:
            return L10n.Shared.SortOrder.updatedAtOldest
        }
    }

    public func sorted(_ links: [LinkModel]) -> [LinkModel] {
        switch self {
        case .nameAscending:
            return links.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameDescending:
            return links.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .createdAtNewest:
            return links.sorted { $0.createdAt > $1.createdAt }
        case .createdAtOldest:
            return links.sorted { $0.createdAt < $1.createdAt }
        case .updatedAtNewest:
            return links.sorted { $0.updatedAt > $1.updatedAt }
        case .updatedAtOldest:
            return links.sorted { $0.updatedAt < $1.updatedAt }
        }
    }
}
