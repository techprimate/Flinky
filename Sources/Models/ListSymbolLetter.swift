import SFSafeSymbols

enum ListSymbolLetter {
    case letterA
    case letterB
    case letterC
    case letterD
    case letterE
    case letterF
    case letterG
    case letterH
    case letterI
    case letterJ
    case letterK
    case letterL
    case letterM
    case letterN
    case letterO
    case letterP
    case letterQ
    case letterR
    case letterS
    case letterT
    case letterU
    case letterV
    case letterW
    case letterX
    case letterY
    case letterZ

    var sfsymbol: SFSymbol {
        switch self {
        case .letterA:
            return .aCircleFill
        case .letterB:
            return .bCircleFill
        case .letterC:
            return .cCircleFill
        case .letterD:
            return .dCircleFill
        case .letterE:
            return .eCircleFill
        case .letterF:
            return .fCircleFill
        case .letterG:
            return .gCircleFill
        case .letterH:
            return .hCircleFill
        case .letterI:
            return .iCircleFill
        case .letterJ:
            return .jCircleFill
        case .letterK:
            return .kCircleFill
        case .letterL:
            return .lCircleFill
        case .letterM:
            return .mCircleFill
        case .letterN:
            return .nCircleFill
        case .letterO:
            return .oCircleFill
        case .letterP:
            return .pCircleFill
        case .letterQ:
            return .qCircleFill
        case .letterR:
            return .rCircleFill
        case .letterS:
            return .sCircleFill
        case .letterT:
            return .tCircleFill
        case .letterU:
            return .uCircleFill
        case .letterV:
            return .vCircleFill
        case .letterW:
            return .wCircleFill
        case .letterX:
            return .xCircleFill
        case .letterY:
            return .yCircleFill
        case .letterZ:
            return .zCircleFill
        }
    }
}

extension ListSymbolLetter: RawRepresentable {
    init?(rawValue: String) {  // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch rawValue {
        case "letter-a":
            self = .letterA
        case "letter-b":
            self = .letterB
        case "letter-c":
            self = .letterC
        case "letter-d":
            self = .letterD
        case "letter-e":
            self = .letterE
        case "letter-f":
            self = .letterF
        case "letter-g":
            self = .letterG
        case "letter-h":
            self = .letterH
        case "letter-i":
            self = .letterI
        case "letter-j":
            self = .letterJ
        case "letter-k":
            self = .letterK
        case "letter-l":
            self = .letterL
        case "letter-m":
            self = .letterM
        case "letter-n":
            self = .letterN
        case "letter-o":
            self = .letterO
        case "letter-p":
            self = .letterP
        case "letter-q":
            self = .letterQ
        case "letter-r":
            self = .letterR
        case "letter-s":
            self = .letterS
        case "letter-t":
            self = .letterT
        case "letter-u":
            self = .letterU
        case "letter-v":
            self = .letterV
        case "letter-w":
            self = .letterW
        case "letter-x":
            self = .letterX
        case "letter-y":
            self = .letterY
        case "letter-z":
            self = .letterZ
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .letterA:
            return "letter-a"
        case .letterB:
            return "letter-b"
        case .letterC:
            return "letter-c"
        case .letterD:
            return "letter-d"
        case .letterE:
            return "letter-e"
        case .letterF:
            return "letter-f"
        case .letterG:
            return "letter-g"
        case .letterH:
            return "letter-h"
        case .letterI:
            return "letter-i"
        case .letterJ:
            return "letter-j"
        case .letterK:
            return "letter-k"
        case .letterL:
            return "letter-l"
        case .letterM:
            return "letter-m"
        case .letterN:
            return "letter-n"
        case .letterO:
            return "letter-o"
        case .letterP:
            return "letter-p"
        case .letterQ:
            return "letter-q"
        case .letterR:
            return "letter-r"
        case .letterS:
            return "letter-s"
        case .letterT:
            return "letter-t"
        case .letterU:
            return "letter-u"
        case .letterV:
            return "letter-v"
        case .letterW:
            return "letter-w"
        case .letterX:
            return "letter-x"
        case .letterY:
            return "letter-y"
        case .letterZ:
            return "letter-z"
        }
    }
}

extension ListSymbolLetter: CaseIterable {
    static var allCases: [ListSymbolLetter] {
        return [
            .letterA, .letterB, .letterC, .letterD, .letterE, .letterF, .letterG, .letterH, .letterI, .letterJ,
            .letterK, .letterL, .letterM, .letterN, .letterO, .letterP, .letterQ, .letterR, .letterS, .letterT,
            .letterU, .letterV, .letterW, .letterX, .letterY, .letterZ
        ]
    }
}
