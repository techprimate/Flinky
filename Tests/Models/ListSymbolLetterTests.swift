@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolLetter")
class ListSymbolLetterTests {
    private let symbolRawValuePairs: [(ListSymbolLetter, String, SFSymbol)] = [
        (.letterA, "letter-a", .aCircleFill),
        (.letterB, "letter-b", .bCircleFill),
        (.letterC, "letter-c", .cCircleFill),
        (.letterD, "letter-d", .dCircleFill),
        (.letterE, "letter-e", .eCircleFill),
        (.letterF, "letter-f", .fCircleFill),
        (.letterG, "letter-g", .gCircleFill),
        (.letterH, "letter-h", .hCircleFill),
        (.letterI, "letter-i", .iCircleFill),
        (.letterJ, "letter-j", .jCircleFill),
        (.letterK, "letter-k", .kCircleFill),
        (.letterL, "letter-l", .lCircleFill),
        (.letterM, "letter-m", .mCircleFill),
        (.letterN, "letter-n", .nCircleFill),
        (.letterO, "letter-o", .oCircleFill),
        (.letterP, "letter-p", .pCircleFill),
        (.letterQ, "letter-q", .qCircleFill),
        (.letterR, "letter-r", .rCircleFill),
        (.letterS, "letter-s", .sCircleFill),
        (.letterT, "letter-t", .tCircleFill),
        (.letterU, "letter-u", .uCircleFill),
        (.letterV, "letter-v", .vCircleFill),
        (.letterW, "letter-w", .wCircleFill),
        (.letterX, "letter-x", .xCircleFill),
        (.letterY, "letter-y", .yCircleFill),
        (.letterZ, "letter-z", .zCircleFill)
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
            #expect(ListSymbolLetter(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolLetter(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolLetter.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolLetter] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolLetter.allCases == expected)
    }
}
