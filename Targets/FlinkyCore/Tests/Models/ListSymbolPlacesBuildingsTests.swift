@testable import FlinkyCore
import Testing
import SFSafeSymbols

@Suite("ListSymbolPlacesBuildings")
class ListSymbolPlacesBuildingsTests {
    private let symbolRawValuePairs: [(ListSymbolPlacesBuildings, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.house, "house", .houseFill),
        (.office, "office", .building2Fill),
        (.university, "university", .buildingColumnsFill),
        (.globe, "globe", .globeEuropeAfricaFill),
        (.map, "map", .mapFill),
        (.mapPin, "map-pin", .mappin),
        (.location, "location", .locationFill),
        (.sofa, "sofa", .sofaFill),
        (.bathtub, "bathtub", .bathtubFill),
        (.chairLounge, "chair-lounge", .chairLoungeFill)
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
            #expect(ListSymbolPlacesBuildings(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolPlacesBuildings(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolPlacesBuildings.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolPlacesBuildings] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolPlacesBuildings.allCases == expected)
    }
}
