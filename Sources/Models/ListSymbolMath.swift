import SFSafeSymbols

enum ListSymbolMath {
    case plus
    case minus
    case multiply
    case divide
    case equal
    case percent
    case function
    case squareRoot
    case sum
    case plusForwardSlashMinus

    var sfsymbol: SFSymbol {
        switch self {
        case .plus:
            return .plus
        case .minus:
            return .minus
        case .multiply:
            return .multiply
        case .divide:
            return .divide
        case .equal:
            return .equal
        case .percent:
            return .percent
        case .function:
            return .function
        case .squareRoot:
            return .squareroot
        case .sum:
            return .sum
        case .plusForwardSlashMinus:
            return .plusForwardslashMinus
        }
    }
}

extension ListSymbolMath: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "plus":
            self = .plus
        case "minus":
            self = .minus
        case "multiply":
            self = .multiply
        case "divide":
            self = .divide
        case "equal":
            self = .equal
        case "function":
            self = .function
        case "square-root":
            self = .squareRoot
        case "sum":
            self = .sum
        case "percent":
            self = .percent
        case "plus-forward-slash-minus":
            self = .plusForwardSlashMinus
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .plus:
            return "plus"
        case .minus:
            return "minus"
        case .multiply:
            return "multiply"
        case .divide:
            return "divide"
        case .equal:
            return "equal"
        case .percent:
            return "percent"
        case .function:
            return "function"
        case .squareRoot:
            return "square-root"
        case .sum:
            return "sum"
        case .plusForwardSlashMinus:
            return "plus-forward-slash-minus"
        }
    }
}

extension ListSymbolMath: CaseIterable {
    static var allCases: [ListSymbolMath] {
        return [
            .plus, .minus, .multiply, .divide, .equal, .percent, .function, .squareRoot, .sum, .plusForwardSlashMinus
        ]
    }
}
