@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolNature")
class ListSymbolNatureTests {
    private let symbolRawValuePairs: [(ListSymbolNature, String, SFSymbol)] = [
        (.tree, "tree", .treeFill),
        (.leaf, "leaf", .leafFill),
        (.carrot, "carrot", .carrotFill),
        (.mountain, "mountain", .mountain2Fill),
        (.sun, "sun", .sunMaxFill),
        (.sunHaze, "sun-haze", .sunHazeFill),
        (.moon, "moon", .moonFill),
        (.rainDrop, "rain-drop", .dropFill),
        (.snowflake, "snowflake", .snowflake),
        (.flame, "flame", .flameFill),
        (.tornado, "tornado", .tornado),
        (.wind, "wind", .wind),
        (.smoke, "smoke", .smokeFill),
        (.heat, "heat", .heatWaves),
        (.humidity, "humidity", .humidityFill),
        (.cloud, "cloud", .cloudFill),
        (.cloudBolt, "cloud-bolt", .cloudBoltFill),
        (.cloudBoltRain, "cloud-bolt-rain", .cloudBoltRainFill),
        (.cloudSunBolt, "cloud-sun-bolt", .cloudSunBoltFill)
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
            #expect(ListSymbolNature(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolNature(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolNature.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolNature] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolNature.allCases == expected)
    }
}
