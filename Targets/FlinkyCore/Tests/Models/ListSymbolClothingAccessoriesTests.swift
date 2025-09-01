@testable import FlinkyCore
import Testing
import SFSafeSymbols

@Suite("ListSymbolClothingAccessories")
class ListSymbolClothingAccessoriesTests {
    private let symbolRawValuePairs: [(ListSymbolClothingAccessories, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.hat, "hat", .hatWidebrimFill),
        (.tshirt, "tshirt", .tshirtFill)
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
            #expect(ListSymbolClothingAccessories(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolClothingAccessories(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolClothingAccessories.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolClothingAccessories] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolClothingAccessories.allCases == expected)
    }
}
