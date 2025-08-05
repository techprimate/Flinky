@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolHuman")
class ListSymbolHumanTests {
    private let symbolRawValuePairs: [(ListSymbolHuman, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.handRaised, "hand-raised", .handRaisedFill),
        (.handWave, "hand-wave", .handWaveFill),
        (.thumbsUp, "thumbs-up", .handThumbsupFill),
        (.thumbsDown, "thumbs-down", .handThumbsdownFill),
        (.person, "person", .personFill),
        (.person2, "person-2", .person2Fill),
        (.person3, "person-3", .person3Fill),
        (.personCropSquare, "person-crop-square", .personCropSquare),
        (.personTextRectangle, "person-text-rectangle", .personTextRectangleFill),
        (.mustache, "mustache", .mustacheFill)
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
            #expect(ListSymbolHuman(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolHuman(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolHuman.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolHuman] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolHuman.allCases == expected)
    }
}
