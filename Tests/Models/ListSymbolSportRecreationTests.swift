@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolSportRecreation")
class ListSymbolSportRecreationTests {
    private let symbolRawValuePairs: [(ListSymbolSportRecreation, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.soccerBall, "soccer-ball", .soccerball),
        (.basketball, "basketball", .basketballFill),
        (.americanFootball, "american-football", .americanFootballFill),
        (.baseball, "baseball", .baseballFill),
        (.baseballDiamond, "baseball-diamond", .baseballDiamondBasesOutsIndicator),
        (.rugbyBall, "rugby-ball", .rugbyballFill),
        (.tennisBall, "tennis-ball", .tennisballFill),
        (.tennisRacket, "tennis-racket", .tennisRacket),
        (.volleyball, "volleyball", .volleyballFill),
        (.hockeyPuck, "hockey-puck", .hockeyPuckFill),
        (.surfboard, "surfboard", .surfboardFill),
        (.skis, "skis", .skisFill),
        (.snowboard, "snowboard", .snowboardFill),
        (.dumbBell, "dumb-bell", .dumbbellFill),
        (.oars, "oars", .oar2Crossed),
        (.medal, "medal", .medalFill),
        (.medalStar, "medal-star", .medalStarFill),
        (.trophy, "trophy", .trophyFill),
        (.running, "running", .figureRun)
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
            #expect(ListSymbolSportRecreation(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolSportRecreation(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolSportRecreation.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolSportRecreation] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolSportRecreation.allCases == expected)
    }
}
