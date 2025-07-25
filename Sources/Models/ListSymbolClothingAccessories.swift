import SFSafeSymbols

enum ListSymbolClothingAccessories {
    case hat
    case tshirt

    var sfsymbol: SFSymbol {
        switch self {
        case .hat:
            return .hatWidebrimFill
        case .tshirt:
            return .tshirtFill
        }
    }
}

extension ListSymbolClothingAccessories: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "hat":
            self = .hat
        case "tshirt":
            self = .tshirt
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .hat:
            return "hat"
        case .tshirt:
            return "tshirt"
        }
    }
}

extension ListSymbolClothingAccessories: CaseIterable {
    static var allCases: [ListSymbolClothingAccessories] {
        return [.hat, .tshirt]
    }
}
