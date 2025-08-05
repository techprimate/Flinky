import SFSafeSymbols

enum ListSymbolBasicShape {
    case circle
    case square
    case triangle
    case diamond
    case hexagon
    case pentagon
    case octagon
    case oval
    case rhombus
    case rectangle

    var sfsymbol: SFSymbol {
        switch self {
        case .circle:
            return .circleFill
        case .square:
            return .squareFill
        case .triangle:
            return .triangleFill
        case .diamond:
            return .diamondFill
        case .hexagon:
            return .hexagonFill
        case .pentagon:
            return .pentagonFill
        case .octagon:
            return .octagonFill
        case .oval:
            return .ovalFill
        case .rhombus:
            return .rhombusFill
        case .rectangle:
            return .rectangleFill
        }
    }
}

extension ListSymbolBasicShape: RawRepresentable {
    init?(rawValue: String) {  // swiftlint:disable:this cyclomatic_complexity
        switch rawValue {
        case "circle":
            self = .circle
        case "square":
            self = .square
        case "triangle":
            self = .triangle
        case "diamond":
            self = .diamond
        case "hexagon":
            self = .hexagon
        case "pentagon":
            self = .pentagon
        case "octagon":
            self = .octagon
        case "oval":
            self = .oval
        case "rhombus":
            self = .rhombus
        case "rectangle":
            self = .rectangle
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .circle:
            return "circle"
        case .square:
            return "square"
        case .triangle:
            return "triangle"
        case .diamond:
            return "diamond"
        case .hexagon:
            return "hexagon"
        case .pentagon:
            return "pentagon"
        case .octagon:
            return "octagon"
        case .oval:
            return "oval"
        case .rhombus:
            return "rhombus"
        case .rectangle:
            return "rectangle"
        }
    }
}

extension ListSymbolBasicShape: CaseIterable {
    static var allCases: [ListSymbolBasicShape] {
        return [
            .circle, .square, .triangle, .diamond, .hexagon, .pentagon, .octagon, .oval, .rhombus, .rectangle
        ]
    }
}
