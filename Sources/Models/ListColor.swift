import SwiftUI

enum ListColor: String, CaseIterable, Identifiable, Codable {
    case red
    case orange
    case yellow
    case green
    case lightBlue
    case blue
    case indigo
    case pink
    case purple
    case brown
    case gray
    case mint

    var color: Color {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .lightBlue:
            return .cyan
        case .blue:
            return .blue
        case .indigo:
            return .indigo
        case .pink:
            return .pink
        case .purple:
            return .purple
        case .brown:
            return .brown
        case .gray:
            return .gray
        case .mint:
            return .mint
        }
    }

    var gradient: LinearGradient {
        LinearGradient(
            colors: [
                color.mix(with: Color.white, by: 0.4),
                color
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var id: RawValue {
        rawValue
    }

    var name: String {
        switch self {
        case .blue: return L10n.Shared.Color.blue
        case .lightBlue: return L10n.Shared.Color.lightBlue
        case .green: return L10n.Shared.Color.green
        case .red: return L10n.Shared.Color.red
        case .orange: return L10n.Shared.Color.orange
        case .yellow: return L10n.Shared.Color.yellow
        case .purple: return L10n.Shared.Color.purple
        case .pink: return L10n.Shared.Color.pink
        case .gray: return L10n.Shared.Color.gray
        case .brown: return L10n.Shared.Color.brown
        case .indigo: return L10n.Shared.Color.indigo
        case .mint: return L10n.Shared.Color.mint
        }
    }

    static var defaultForList: Self {
        .gray
    }

    static var defaultForLink: Self {
        .blue
    }
}
