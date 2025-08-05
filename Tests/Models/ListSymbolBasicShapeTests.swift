@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolBasicShape")
class ListSymbolBasicShapeTests {
    private let symbolRawValuePairs: [(ListSymbolBasicShape, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.circle, "circle", .circleFill),
        (.square, "square", .squareFill),
        (.triangle, "triangle", .triangleFill),
        (.diamond, "diamond", .diamondFill),
        (.hexagon, "hexagon", .hexagonFill),
        (.pentagon, "pentagon", .pentagonFill),
        (.octagon, "octagon", .octagonFill),
        (.oval, "oval", .ovalFill),
        (.rhombus, "rhombus", .rhombusFill),
        (.rectangle, "rectangle", .rectangleFill)
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
            #expect(ListSymbolBasicShape(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolBasicShape(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolBasicShape.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolBasicShape] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolBasicShape.allCases == expected)
    }
}
