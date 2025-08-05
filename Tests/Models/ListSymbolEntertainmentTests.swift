@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolEntertainment")
class ListSymbolEntertainmentTests {
    private let symbolRawValuePairs: [(ListSymbolEntertainment, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.theaterMasks, "theater-masks", .theatermasksFill),
        (.balloon, "balloon", .balloonFill),
        (.balloon2, "balloon-2", .balloon2Fill),
        (.partyPopper, "party-popper", .partyPopperFill),
        (.dice, "dice", .diceFill),
        (.playButton, "play-button", .playFill),
        (.playRectangle, "play-rectangle", .playRectangleFill),
        (.tvPlay, "tv-play", .playTvFill),
        (.musicNote, "music-note", .musicNote)
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
            #expect(ListSymbolEntertainment(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolEntertainment(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolEntertainment.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolEntertainment] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolEntertainment.allCases == expected)
    }
}
