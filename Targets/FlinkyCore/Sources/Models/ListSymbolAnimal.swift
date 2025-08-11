import SFSafeSymbols

public enum ListSymbolAnimal {
    case ant
    case bird
    case cat
    case dog
    case fish
    case ladybug
    case lizard
    case tortoise
    case hare
    case pawPrint
    case teddyBear

    var sfsymbol: SFSymbol {
        switch self {
        case .ant:
            return .antFill
        case .bird:
            return .birdFill
        case .cat:
            return .catFill
        case .dog:
            return .dogFill
        case .fish:
            return .fishFill
        case .ladybug:
            return .ladybugFill
        case .lizard:
            return .lizardFill
        case .tortoise:
            return .tortoiseFill
        case .hare:
            return .hareFill
        case .pawPrint:
            return .pawprintFill
        case .teddyBear:
            return .teddybearFill
        }
    }
}

extension ListSymbolAnimal: RawRepresentable {
    public init?(rawValue: String) {  // swiftlint:disable:this cyclomatic_complexity
        switch rawValue {
        case "ant":
            self = .ant
        case "bird":
            self = .bird
        case "cat":
            self = .cat
        case "dog":
            self = .dog
        case "fish":
            self = .fish
        case "ladybug":
            self = .ladybug
        case "lizard":
            self = .lizard
        case "tortoise":
            self = .tortoise
        case "hare":
            self = .hare
        case "paw-print":
            self = .pawPrint
        case "teddy-bear":
            self = .teddyBear
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .ant:
            return "ant"
        case .bird:
            return "bird"
        case .cat:
            return "cat"
        case .dog:
            return "dog"
        case .fish:
            return "fish"
        case .ladybug:
            return "ladybug"
        case .lizard:
            return "lizard"
        case .tortoise:
            return "tortoise"
        case .hare:
            return "hare"
        case .pawPrint:
            return "paw-print"
        case .teddyBear:
            return "teddy-bear"
        }
    }
}

extension ListSymbolAnimal: CaseIterable {
    public static var allCases: [ListSymbolAnimal] {
        return [.ant, .bird, .cat, .dog, .fish, .ladybug, .lizard, .tortoise, .hare, .pawPrint, .teddyBear]
    }
}
