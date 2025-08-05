@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolAnimal")
class ListSymbolAnimalTests {
    private let symbolRawValuePairs: [(ListSymbolAnimal, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.ant, "ant", .antFill),
        (.bird, "bird", .birdFill),
        (.cat, "cat", .catFill),
        (.dog, "dog", .dogFill),
        (.fish, "fish", .fishFill),
        (.ladybug, "ladybug", .ladybugFill),
        (.lizard, "lizard", .lizardFill),
        (.tortoise, "tortoise", .tortoiseFill),
        (.hare, "hare", .hareFill),
        (.pawPrint, "paw-print", .pawprintFill),
        (.teddyBear, "teddy-bear", .teddybearFill)
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
            #expect(ListSymbolAnimal(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolAnimal(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolAnimal.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolAnimal] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolAnimal.allCases == expected)
    }
}
