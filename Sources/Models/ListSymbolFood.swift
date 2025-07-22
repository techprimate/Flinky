import SFSafeSymbols

enum ListSymbolFood {
    case popcorn
    case menuCard
    case forkKnife
    case wineGlass

    var sfsymbol: SFSymbol {
        switch self {
        case .popcorn:
            return .popcornFill
        case .menuCard:
            return .menucardFill
        case .forkKnife:
            return .forkKnife
        case .wineGlass:
            return .wineglassFill
        }
    }
}

extension ListSymbolFood: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "popcorn":
            self = .popcorn
        case "menu-card":
            self = .menuCard
        case "fork-knife":
            self = .forkKnife
        case "wine-glass":
            self = .wineGlass
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .popcorn:
            return "popcorn"
        case .menuCard:
            return "menu-card"
        case .forkKnife:
            return "fork-knife"
        case .wineGlass:
            return "wine-glass"
        }
    }
}

extension ListSymbolFood: CaseIterable {
    static var allCases: [ListSymbolFood] {
        return [
            .popcorn, .menuCard, .forkKnife, .wineGlass,
        ]
    }
}
