import SFSafeSymbols

enum ListSymbolTransportation {
    case airplane
    case car
    case carSide
    case bus
    case tram
    case lightrail
    case cableCar
    case ferry
    case sailboat
    case bicycle
    case motorcycle
    case moped
    case scooter
    case skateboard
    case drone
    case fuelPump
    case steeringWheel
    case wheelchair
    case engineCombustion
    case truck

    var sfsymbol: SFSymbol {
        switch self {
        case .airplane:
            return .airplane
        case .car:
            return .carFill
        case .carSide:
            return .carSideFill
        case .bus:
            return .busFill
        case .tram:
            return .tramFill
        case .lightrail:
            return .lightrailFill
        case .cableCar:
            return .cablecarFill
        case .ferry:
            return .ferryFill
        case .sailboat:
            return .sailboatFill
        case .bicycle:
            return .bicycle
        case .motorcycle:
            return .motorcycleFill
        case .moped:
            return .mopedFill
        case .scooter:
            return .scooter
        case .skateboard:
            return .skateboardFill
        case .drone:
            return .droneFill
        case .fuelPump:
            return .fuelpumpFill
        case .steeringWheel:
            return .steeringwheel
        case .wheelchair:
            return .wheelchair
        case .engineCombustion:
            return .engineCombustionFill
        case .truck:
            return .truckBoxFill
        }
    }
}

extension ListSymbolTransportation: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "airplane":
            self = .airplane
        case "car":
            self = .car
        case "car-side":
            self = .carSide
        case "bus":
            self = .bus
        case "tram":
            self = .tram
        case "lightrail":
            self = .lightrail
        case "cable-car":
            self = .cableCar
        case "ferry":
            self = .ferry
        case "sailboat":
            self = .sailboat
        case "bicycle":
            self = .bicycle
        case "motorcycle":
            self = .motorcycle
        case "moped":
            self = .moped
        case "scooter":
            self = .scooter
        case "skateboard":
            self = .skateboard
        case "drone":
            self = .drone
        case "fuel-pump":
            self = .fuelPump
        case "steering-wheel":
            self = .steeringWheel
        case "wheelchair":
            self = .wheelchair
        case "engine-combustion":
            self = .engineCombustion
        case "truck":
            self = .truck
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .airplane:
            return "airplane"
        case .car:
            return "car"
        case .carSide:
            return "car-side"
        case .bus:
            return "bus"
        case .tram:
            return "tram"
        case .lightrail:
            return "lightrail"
        case .cableCar:
            return "cable-car"
        case .ferry:
            return "ferry"
        case .sailboat:
            return "sailboat"
        case .bicycle:
            return "bicycle"
        case .motorcycle:
            return "motorcycle"
        case .moped:
            return "moped"
        case .scooter:
            return "scooter"
        case .skateboard:
            return "skateboard"
        case .drone:
            return "drone"
        case .fuelPump:
            return "fuel-pump"
        case .steeringWheel:
            return "steering-wheel"
        case .wheelchair:
            return "wheelchair"
        case .engineCombustion:
            return "engine-combustion"
        case .truck:
            return "truck"
        }
    }
}

extension ListSymbolTransportation: CaseIterable {
    static var allCases: [ListSymbolTransportation] {
        return [
            .airplane, .car, .carSide, .bus, .tram, .lightrail, .cableCar, .ferry, .sailboat, .bicycle, .motorcycle, .moped, .scooter, .skateboard, .drone, .fuelPump, .steeringWheel, .wheelchair, .engineCombustion, .truck
        ]
    }
}
