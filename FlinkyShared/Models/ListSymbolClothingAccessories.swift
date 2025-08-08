import SFSafeSymbols

public enum ListSymbolClothingAccessories {
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
    public init?(rawValue: String) {
        switch rawValue {
        case "hat":
            self = .hat
        case "tshirt":
            self = .tshirt
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .hat:
            return "hat"
        case .tshirt:
            return "tshirt"
        }
    }
}

extension ListSymbolClothingAccessories: CaseIterable {
    public static var allCases: [ListSymbolClothingAccessories] {
        return [.hat, .tshirt]
    }
}
