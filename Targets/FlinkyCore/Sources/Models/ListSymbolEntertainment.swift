import SFSafeSymbols

public enum ListSymbolEntertainment {
    case theaterMasks
    case balloon
    case balloon2
    case partyPopper
    case dice
    case playButton
    case playRectangle
    case tvPlay
    case musicNote

    var sfsymbol: SFSymbol {
        switch self {
        case .theaterMasks:
            return .theatermasksFill
        case .balloon:
            return .balloonFill
        case .balloon2:
            return .balloon2Fill
        case .partyPopper:
            return .partyPopperFill
        case .dice:
            return .diceFill
        case .playButton:
            return .playFill
        case .playRectangle:
            return .playRectangleFill
        case .tvPlay:
            return .playTvFill
        case .musicNote:
            return .musicNote
        }
    }
}

extension ListSymbolEntertainment: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case "theater-masks":
            self = .theaterMasks
        case "balloon":
            self = .balloon
        case "balloon-2":
            self = .balloon2
        case "party-popper":
            self = .partyPopper
        case "dice":
            self = .dice
        case "play-button":
            self = .playButton
        case "play-rectangle":
            self = .playRectangle
        case "tv-play":
            self = .tvPlay
        case "music-note":
            self = .musicNote
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .theaterMasks:
            return "theater-masks"
        case .balloon:
            return "balloon"
        case .balloon2:
            return "balloon-2"
        case .partyPopper:
            return "party-popper"
        case .dice:
            return "dice"
        case .playButton:
            return "play-button"
        case .playRectangle:
            return "play-rectangle"
        case .tvPlay:
            return "tv-play"
        case .musicNote:
            return "music-note"
        }
    }
}

extension ListSymbolEntertainment: CaseIterable {
    public static var allCases: [ListSymbolEntertainment] {
        return [
            .theaterMasks, .balloon, .balloon2, .partyPopper, .dice, .playButton, .playRectangle, .tvPlay, .musicNote
        ]
    }
}
