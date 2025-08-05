@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolCommunication")
class ListSymbolCommunicationTests {
    private let symbolRawValuePairs: [(ListSymbolCommunication, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.network, "network", .network),
        (.link, "link", .link),
        (.checkmark, "checkmark", .checkmarkCircleFill),
        (.checkmarkSeal, "checkmark-seal", .checkmarkSealFill),
        (.checkmarkSealTextPage, "checkmark-seal-text-page", .checkmarkSealTextPageFill),
        (.questionMark, "question-mark", .questionmarkCircleFill),
        (.questionMarkTextPage, "question-mark-text-page", .questionmarkTextPageFill),
        (.exclamationMark, "exclamation-mark", .exclamationmarkCircleFill),
        (.exclamationMarkBubble, "exclamation-mark-bubble", .exclamationmarkBubbleFill),
        (.exclamationMarkShield, "exclamation-mark-shield", .exclamationmarkShieldFill),
        (.exclamationMarkTriangle, "exclamation-mark-triangle", .exclamationmarkTriangleFill),
        (.seal, "seal", .sealFill),
        (.shield, "shield", .shieldFill),
        (.shieldLeftHalf, "shield-left-half", .shieldLefthalfFilled),
        (.shieldPatternCheckered, "shield-pattern-checkered", .shieldPatternCheckered),
        (.crown, "crown", .crownFill),
        (.flag, "flag", .flagFill),
        (.flag2Crossed, "flag-2-crossed", .flag2CrossedFill),
        (.checkerFlag, "checker-flag", .flagPatternCheckered),
        (.message, "message", .messageFill),
        (.bubble, "bubble", .bubbleFill),
        (.captionsBubble, "captions-bubble", .captionsBubble),
        (.heart, "heart", .heartFill),
        (.heartTextClipboard, "heart-text-clipboard", .heartTextClipboardFill),
        (.star, "star", .starFill),
        (.asterisk, "asterisk", .asterisk),
        (.lightbulb, "lightbulb", .lightbulbFill),
        (.bolt, "bolt", .boltFill),
        (.boltHeart, "bolt-heart", .boltHeart),
        (.apple, "apple", .appleLogo),
        (.swirl, "swirl", .swirlCircleRighthalfFilled),
        (.swirlInverse, "swirl-inverse", .swirlCircleRighthalfFilledInverse),
        (.beziercurve, "beziercurve", .beziercurve),
        (.waveform, "waveform", .waveformPathEcg),
        (.grid, "grid", .circleGridCrossFill),
        (.circleHexagonPath, "circle-hexagon-path", .circleHexagonpathFill),
        (.trash, "trash", .trashFill),
        (.gear, "gear", .gearshapeFill),
        (.fireExtinguisher, "fire-extinguisher", .fireExtinguisherFill),
        (.noSign, "no-sign", .nosign),
        (.noteText, "note-text", .noteText),
        (.number, "number", .number),
        (.calendar, "calendar", .calendar),
        (.chart, "chart", .chartBarFill),
        (.archiveArrow, "archive-arrow", .arrowUpBin),
        (.wifi2, "wifi-2", .wifi),
        (.wrench, "wrench", .wrenchAdjustable)
    ]

    @Test
    func testRawValue_shouldReturnExpectedValue() {
        for (symbol, expectedRawValue, _) in symbolRawValuePairs {
            #expect(symbol.rawValue == expectedRawValue)
        }
    }

    @Test
    func testInitWithRawValue_withValidRawValue_shouldReturnExpectedSymbol() {
        for (expectedSymbol, rawValue, _) in symbolRawValuePairs {
            #expect(ListSymbolCommunication(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolCommunication(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolCommunication.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolCommunication] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolCommunication.allCases == expected)
    }
}
