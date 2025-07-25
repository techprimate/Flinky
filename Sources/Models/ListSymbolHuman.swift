import SFSafeSymbols

enum ListSymbolHuman {
    case handRaised
    case handWave
    case thumbsUp
    case thumbsDown
    case person
    case person2
    case person3
    case personCropSquare
    case personTextRectangle
    case mustache

    var sfsymbol: SFSymbol {
        switch self {
        case .handRaised:
            return .handRaisedFill
        case .handWave:
            return .handWaveFill
        case .thumbsUp:
            return .handThumbsupFill
        case .thumbsDown:
            return .handThumbsdownFill
        case .person:
            return .personFill
        case .person2:
            return .person2Fill
        case .person3:
            return .person3Fill
        case .personCropSquare:
            return .personCropSquare
        case .personTextRectangle:
            return .personTextRectangleFill
        case .mustache:
            return .mustacheFill
        }
    }
}

extension ListSymbolHuman: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "hand-raised":
            self = .handRaised
        case "hand-wave":
            self = .handWave
        case "thumbs-up":
            self = .thumbsUp
        case "thumbs-down":
            self = .thumbsDown
        case "person":
            self = .person
        case "person-2":
            self = .person2
        case "person-3":
            self = .person3
        case "person-crop-square":
            self = .personCropSquare
        case "person-text-rectangle":
            self = .personTextRectangle
        case "mustache":
            self = .mustache
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .handRaised:
            return "hand-raised"
        case .handWave:
            return "hand-wave"
        case .thumbsUp:
            return "thumbs-up"
        case .thumbsDown:
            return "thumbs-down"
        case .person:
            return "person"
        case .person2:
            return "person-2"
        case .person3:
            return "person-3"
        case .personCropSquare:
            return "person-crop-square"
        case .personTextRectangle:
            return "person-text-rectangle"
        case .mustache:
            return "mustache"
        }
    }
}

extension ListSymbolHuman: CaseIterable {
    static var allCases: [ListSymbolHuman] {
        return [
            .handRaised, .handWave, .thumbsUp, .thumbsDown, .person, .person2, .person3, .personCropSquare, .personTextRectangle, .mustache
        ]
    }
}
