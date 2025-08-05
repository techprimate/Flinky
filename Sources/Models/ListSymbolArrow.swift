import SFSafeSymbols

enum ListSymbolArrow {
    case arrowUp
    case arrowDown
    case arrowLeft
    case arrowRight
    case arrowUpCircle
    case arrowDownCircle
    case arrowLeftCircle
    case arrowRightCircle
    case arrowTurnUpLeft
    case arrowTurnUpRight

    var sfsymbol: SFSymbol {
        switch self {
        case .arrowUp:
            return .arrowshapeUpFill
        case .arrowDown:
            return .arrowshapeDownFill
        case .arrowLeft:
            return .arrowshapeLeftFill
        case .arrowRight:
            return .arrowshapeRightFill
        case .arrowUpCircle:
            return .arrowUpCircleFill
        case .arrowDownCircle:
            return .arrowDownCircleFill
        case .arrowLeftCircle:
            return .arrowLeftCircleFill
        case .arrowRightCircle:
            return .arrowRightCircleFill
        case .arrowTurnUpLeft:
            return .arrowshapeTurnUpLeftFill
        case .arrowTurnUpRight:
            return .arrowshapeTurnUpRightFill
        }
    }
}

extension ListSymbolArrow: RawRepresentable {
    init?(rawValue: String) {  // swiftlint:disable:this cyclomatic_complexity
        switch rawValue {
        case "arrow-up":
            self = .arrowUp
        case "arrow-down":
            self = .arrowDown
        case "arrow-left":
            self = .arrowLeft
        case "arrow-right":
            self = .arrowRight
        case "arrow-up-circle":
            self = .arrowUpCircle
        case "arrow-down-circle":
            self = .arrowDownCircle
        case "arrow-left-circle":
            self = .arrowLeftCircle
        case "arrow-right-circle":
            self = .arrowRightCircle
        case "arrow-turn-up-left":
            self = .arrowTurnUpLeft
        case "arrow-turn-up-right":
            self = .arrowTurnUpRight
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .arrowUp:
            return "arrow-up"
        case .arrowDown:
            return "arrow-down"
        case .arrowLeft:
            return "arrow-left"
        case .arrowRight:
            return "arrow-right"
        case .arrowUpCircle:
            return "arrow-up-circle"
        case .arrowDownCircle:
            return "arrow-down-circle"
        case .arrowLeftCircle:
            return "arrow-left-circle"
        case .arrowRightCircle:
            return "arrow-right-circle"
        case .arrowTurnUpLeft:
            return "arrow-turn-up-left"
        case .arrowTurnUpRight:
            return "arrow-turn-up-right"
        }
    }
}

extension ListSymbolArrow: CaseIterable {
    static var allCases: [ListSymbolArrow] {
        return [
            .arrowUp, .arrowDown, .arrowLeft, .arrowRight, .arrowUpCircle, .arrowDownCircle, .arrowLeftCircle,
            .arrowRightCircle, .arrowTurnUpLeft, .arrowTurnUpRight
        ]
    }
}
