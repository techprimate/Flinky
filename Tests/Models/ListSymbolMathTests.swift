@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolMath")
class ListSymbolMathTests {
    private let symbolRawValuePairs: [(ListSymbolMath, String, SFSymbol)] = [
        (.plus, "plus", .plus),
        (.minus, "minus", .minus),
        (.multiply, "multiply", .multiply),
        (.divide, "divide", .divide),
        (.equal, "equal", .equal),
        (.percent, "percent", .percent),
        (.function, "function", .function),
        (.squareRoot, "square-root", .squareroot),
        (.sum, "sum", .sum),
        (.plusForwardSlashMinus, "plus-forward-slash-minus", .plusForwardslashMinus)
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
            #expect(ListSymbolMath(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolMath(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolMath.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolMath] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolMath.allCases == expected)
    }
}
