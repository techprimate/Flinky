@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolArrow")
class ListSymbolArrowTests {
    private let symbolRawValuePairs: [(ListSymbolArrow, String, SFSymbol)] = [
        (.arrowUp, "arrow-up", .arrowshapeUpFill),
        (.arrowDown, "arrow-down", .arrowshapeDownFill),
        (.arrowLeft, "arrow-left", .arrowshapeLeftFill),
        (.arrowRight, "arrow-right", .arrowshapeRightFill),
        (.arrowUpCircle, "arrow-up-circle", .arrowUpCircleFill),
        (.arrowDownCircle, "arrow-down-circle", .arrowDownCircleFill),
        (.arrowLeftCircle, "arrow-left-circle", .arrowLeftCircleFill),
        (.arrowRightCircle, "arrow-right-circle", .arrowRightCircleFill),
        (.arrowTurnUpLeft, "arrow-turn-up-left", .arrowshapeTurnUpLeftFill),
        (.arrowTurnUpRight, "arrow-turn-up-right", .arrowshapeTurnUpRightFill)
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
            #expect(ListSymbolArrow(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolArrow(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolArrow.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolArrow] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolArrow.allCases == expected)
    }
}
