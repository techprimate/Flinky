import SFSafeSymbols

enum ListSymbolPlacesBuildings {
    case house
    case office
    case university
    case globe
    case map
    case mapPin
    case location
    case sofa
    case bathtub
    case chairLounge

    var sfsymbol: SFSymbol {
        switch self {
        case .house:
            return .houseFill
        case .office:
            return .building2Fill
        case .university:
            return .buildingColumnsFill
        case .globe:
            return .globeEuropeAfricaFill
        case .map:
            return .mapFill
        case .mapPin:
            return .mappin
        case .location:
            return .locationFill
        case .sofa:
            return .sofaFill
        case .bathtub:
            return .bathtubFill
        case .chairLounge:
            return .chairLoungeFill
        }
    }
}

extension ListSymbolPlacesBuildings: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "house":
            self = .house
        case "office":
            self = .office
        case "university":
            self = .university
        case "globe":
            self = .globe
        case "map":
            self = .map
        case "map-pin":
            self = .mapPin
        case "location":
            self = .location
        case "sofa":
            self = .sofa
        case "bathtub":
            self = .bathtub
        case "chair-lounge":
            self = .chairLounge
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .house:
            return "house"
        case .office:
            return "office"
        case .university:
            return "university"
        case .globe:
            return "globe"
        case .map:
            return "map"
        case .mapPin:
            return "map-pin"
        case .location:
            return "location"
        case .sofa:
            return "sofa"
        case .bathtub:
            return "bathtub"
        case .chairLounge:
            return "chair-lounge"
        }
    }
}

extension ListSymbolPlacesBuildings: CaseIterable {
    static var allCases: [ListSymbolPlacesBuildings] {
        return [
            .house, .office, .university, .globe, .map, .mapPin, .location, .sofa, .bathtub, .chairLounge
        ]
    }
}
