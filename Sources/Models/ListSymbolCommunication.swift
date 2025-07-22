import SFSafeSymbols

enum ListSymbolCommunication {
    case network
    case link
    case checkmark
    case checkmarkSeal
    case checkmarkSealTextPage
    case questionMark
    case questionMarkTextPage
    case exclamationMark
    case exclamationMarkBubble
    case exclamationMarkShield
    case exclamationMarkTriangle
    case seal
    case shield
    case shieldLeftHalf
    case shieldPatternCheckered
    case crown
    case flag
    case flag2Crossed
    case checkerFlag
    case message
    case bubble
    case captionsBubble
    case heart
    case heartTextClipboard
    case star
    case asterisk
    case lightbulb
    case bolt
    case boltHeart
    case apple
    case swirl
    case swirlInverse
    case beziercurve
    case waveform
    case grid
    case circleHexagonPath
    case trash
    case gear
    case fireExtinguisher
    case noSign
    case noteText
    case number
    case calendar
    case chart
    case archiveArrow
    case wifi2
    case wrench

    var sfsymbol: SFSymbol {
        switch self {
        case .network:
            return .network
        case .link:
            return .link
        case .checkmark:
            return .checkmarkCircleFill
        case .checkmarkSeal:
            return .checkmarkSealFill
        case .checkmarkSealTextPage:
            return .checkmarkSealTextPageFill
        case .questionMark:
            return .questionmarkCircleFill
        case .questionMarkTextPage:
            return .questionmarkTextPageFill
        case .exclamationMark:
            return .exclamationmarkCircleFill
        case .exclamationMarkBubble:
            return .exclamationmarkBubbleFill
        case .exclamationMarkShield:
            return .exclamationmarkShieldFill
        case .exclamationMarkTriangle:
            return .exclamationmarkTriangleFill
        case .seal:
            return .sealFill
        case .shield:
            return .shieldFill
        case .shieldLeftHalf:
            return .shieldLefthalfFilled
        case .shieldPatternCheckered:
            return .shieldPatternCheckered
        case .crown:
            return .crownFill
        case .flag:
            return .flagFill
        case .flag2Crossed:
            return .flag2CrossedFill
        case .checkerFlag:
            return .flagPatternCheckered
        case .message:
            return .messageFill
        case .bubble:
            return .bubbleFill
        case .captionsBubble:
            return .captionsBubble
        case .heart:
            return .heartFill
        case .heartTextClipboard:
            return .heartTextClipboardFill
        case .star:
            return .starFill
        case .asterisk:
            return .asterisk
        case .lightbulb:
            return .lightbulbFill
        case .bolt:
            return .boltFill
        case .boltHeart:
            return .boltHeart
        case .apple:
            return .appleLogo
        case .swirl:
            return .swirlCircleRighthalfFilled
        case .swirlInverse:
            return .swirlCircleRighthalfFilledInverse
        case .beziercurve:
            return .beziercurve
        case .waveform:
            return .waveformPathEcg
        case .grid:
            return .circleGridCrossFill
        case .circleHexagonPath:
            return .circleHexagonpathFill
        case .trash:
            return .trashFill
        case .gear:
            return .gearshapeFill
        case .fireExtinguisher:
            return .fireExtinguisherFill
        case .noSign:
            return .nosign
        case .noteText:
            return .noteText
        case .number:
            return .number
        case .calendar:
            return .calendar
        case .chart:
            return .chartBarFill
        case .wifi2:
            return .wifi
        case .archiveArrow:
            return .arrowUpBin
        case .wrench:
            return .wrenchAdjustable
        }
    }
}

extension ListSymbolCommunication: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "network":
            self = .network
        case "link":
            self = .link
        case "wifi-2":
            self = .wifi2
        case "checkmark":
            self = .checkmark
        case "checkmark-seal":
            self = .checkmarkSeal
        case "checkmark-seal-text-page":
            self = .checkmarkSealTextPage
        case "question-mark":
            self = .questionMark
        case "question-mark-text-page":
            self = .questionMarkTextPage
        case "exclamation-mark":
            self = .exclamationMark
        case "exclamation-mark-bubble":
            self = .exclamationMarkBubble
        case "exclamation-mark-shield":
            self = .exclamationMarkShield
        case "exclamation-mark-triangle":
            self = .exclamationMarkTriangle
        case "seal":
            self = .seal
        case "shield":
            self = .shield
        case "shield-left-half":
            self = .shieldLeftHalf
        case "shield-pattern-checkered":
            self = .shieldPatternCheckered
        case "crown":
            self = .crown
        case "flag":
            self = .flag
        case "flag-2-crossed":
            self = .flag2Crossed
        case "checker-flag":
            self = .checkerFlag
        case "message":
            self = .message
        case "bubble":
            self = .bubble
        case "captions-bubble":
            self = .captionsBubble
        case "heart":
            self = .heart
        case "heart-text-clipboard":
            self = .heartTextClipboard
        case "star":
            self = .star
        case "asterisk":
            self = .asterisk
        case "lightbulb":
            self = .lightbulb
        case "bolt":
            self = .bolt
        case "bolt-heart":
            self = .boltHeart
        case "apple":
            self = .apple
        case "swirl":
            self = .swirl
        case "swirl-inverse":
            self = .swirlInverse
        case "beziercurve":
            self = .beziercurve
        case "waveform":
            self = .waveform
        case "grid":
            self = .grid
        case "circle-hexagon-path":
            self = .circleHexagonPath
        case "trash":
            self = .trash
        case "archive-arrow":
            self = .archiveArrow
        case "gear":
            self = .gear
        case "wrench":
            self = .wrench
        case "fire-extinguisher":
            self = .fireExtinguisher
        case "no-sign":
            self = .noSign
        case "note-text":
            self = .noteText
        case "number":
            self = .number
        case "calendar":
            self = .calendar
        case "chart":
            self = .chart
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .network:
            return "network"
        case .link:
            return "link"
        case .wifi2:
            return "wifi-2"
        case .checkmark:
            return "checkmark"
        case .checkmarkSeal:
            return "checkmark-seal"
        case .checkmarkSealTextPage:
            return "checkmark-seal-text-page"
        case .questionMark:
            return "question-mark"
        case .questionMarkTextPage:
            return "question-mark-text-page"
        case .exclamationMark:
            return "exclamation-mark"
        case .exclamationMarkBubble:
            return "exclamation-mark-bubble"
        case .exclamationMarkShield:
            return "exclamation-mark-shield"
        case .exclamationMarkTriangle:
            return "exclamation-mark-triangle"
        case .seal:
            return "seal"
        case .shield:
            return "shield"
        case .shieldLeftHalf:
            return "shield-left-half"
        case .shieldPatternCheckered:
            return "shield-pattern-checkered"
        case .crown:
            return "crown"
        case .flag:
            return "flag"
        case .flag2Crossed:
            return "flag-2-crossed"
        case .checkerFlag:
            return "checker-flag"
        case .message:
            return "message"
        case .bubble:
            return "bubble"
        case .captionsBubble:
            return "captions-bubble"
        case .heart:
            return "heart"
        case .heartTextClipboard:
            return "heart-text-clipboard"
        case .star:
            return "star"
        case .asterisk:
            return "asterisk"
        case .lightbulb:
            return "lightbulb"
        case .bolt:
            return "bolt"
        case .boltHeart:
            return "bolt-heart"
        case .apple:
            return "apple"
        case .swirl:
            return "swirl"
        case .swirlInverse:
            return "swirl-inverse"
        case .beziercurve:
            return "beziercurve"
        case .waveform:
            return "waveform"
        case .grid:
            return "grid"
        case .circleHexagonPath:
            return "circle-hexagon-path"
        case .trash:
            return "trash"
        case .archiveArrow:
            return "archive-arrow"
        case .gear:
            return "gear"
        case .fireExtinguisher:
            return "fire-extinguisher"
        case .noSign:
            return "no-sign"
        case .noteText:
            return "note-text"
        case .number:
            return "number"
        case .calendar:
            return "calendar"
        case .chart:
            return "chart"
        case .wrench:
            return "wrench"
        }
    }
}

extension ListSymbolCommunication: CaseIterable {
    static var allCases: [ListSymbolCommunication] {
        return [
            .network, .link, .checkmark, .checkmarkSeal, .checkmarkSealTextPage, .questionMark, .questionMarkTextPage, .exclamationMark, .exclamationMarkBubble, .exclamationMarkShield, .exclamationMarkTriangle, .seal, .shield, .shieldLeftHalf, .shieldPatternCheckered, .crown, .flag, .flag2Crossed, .checkerFlag, .message, .bubble, .captionsBubble, .heart, .heartTextClipboard, .star, .asterisk, .lightbulb, .bolt, .boltHeart, .apple, .swirl, .swirlInverse, .beziercurve, .waveform, .grid, .circleHexagonPath, .trash, .gear, .fireExtinguisher, .noSign, .noteText, .number, .calendar, .chart, .archiveArrow, .wifi2, .wrench
        ]
    }
}
