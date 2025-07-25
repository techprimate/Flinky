@testable import Flinky
import Testing

private let symbolRawValuePairs: [(ListSymbolFood, String)] = [
    (.popcorn, "popcorn"),
    (.menuCard, "menu-card"),
    (.forkKnife, "fork-knife"),
    (.wineGlass, "wine-glass")
]

@Test
func testListSymbolFoodRawValueAndInit() {
    for (symbol, rawValue) in symbolRawValuePairs {
        #expect(symbol.rawValue == rawValue)
        #expect(ListSymbolFood(rawValue: rawValue) == symbol)
    }
}

@Test
func testListSymbolFoodAllCasesContainsAllSymbols() {
    let allCases = Set(ListSymbolFood.allCases)
    for (symbol, _) in symbolRawValuePairs {
        #expect(allCases.contains(symbol))
    }
}

@Test
func testListSymbolFoodAllCasesOrder() {
    let expected: [ListSymbolFood] = symbolRawValuePairs.map { $0.0 }
    #expect(ListSymbolFood.allCases == expected)
}
