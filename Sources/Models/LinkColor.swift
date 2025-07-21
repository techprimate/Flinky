import SwiftUI

enum LinkColor: String, CaseIterable, Identifiable, Codable {
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

    static var `default`: Self {
        .gray
    }
}
