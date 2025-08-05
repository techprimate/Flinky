@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolFigureSportsActivity")
class ListSymbolFigureSportsActivityTests {
    private let symbolRawValuePairs: [(ListSymbolFigureSportsActivity, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.figure, "figure", .figure),
        (.figure2ArmsOpen, "figure-2-arms-open", .figure2ArmsOpen),
        (.figureAmericanFootball, "figure-american-football", .figureAmericanFootball),
        (.figureArchery, "figure-archery", .figureArchery),
        (.figureAustralianFootball, "figure-australian-football", .figureAustralianFootball),
        (.figureBadminton, "figure-badminton", .figureBadminton),
        (.figureBarre, "figure-barre", .figureBarre),
        (.figureBaseball, "figure-baseball", .figureBaseball),
        (.figureBasketball, "figure-basketball", .figureBasketball),
        (.figureBowling, "figure-bowling", .figureBowling),
        (.figureBoxing, "figure-boxing", .figureBoxing),
        (.figureClimbing, "figure-climbing", .figureClimbing),
        (.figureCooldown, "figure-cooldown", .figureCooldown),
        (.figureCoreTraining, "figure-core-training", .figureCoreTraining),
        (.figureCricket, "figure-cricket", .figureCricket),
        (.figureCrossTraining, "figure-cross-training", .figureCrossTraining),
        (.figureCurling, "figure-curling", .figureCurling),
        (.figureDance, "figure-dance", .figureDance),
        (.figureDiscSports, "figure-disc-sports", .figureDiscSports),
        (.figureElliptical, "figure-elliptical", .figureElliptical),
        (.figureEquestrianSports, "figure-equestrian-sports", .figureEquestrianSports),
        (.figureFall, "figure-fall", .figureFall),
        (.figureFencing, "figure-fencing", .figureFencing),
        (.figureFieldHockey, "figure-field-hockey", .figureFieldHockey),
        (.figureFishing, "figure-fishing", .figureFishing),
        (.figureFlexibility, "figure-flexibility", .figureFlexibility),
        (.figureGolf, "figure-golf", .figureGolf),
        (.figureGymnastics, "figure-gymnastics", .figureGymnastics),
        (.figureHandCycling, "figure-hand-cycling", .figureHandCycling),
        (.figureHandball, "figure-handball", .figureHandball),
        (.figureHighIntensityIntervalTraining, "figure-high-intensity-interval-training", .figureHighintensityIntervaltraining),
        (.figureHiking, "figure-hiking", .figureHiking),
        (.figureHockey, "figure-hockey", .figureHockey),
        (.figureHunting, "figure-hunting", .figureHunting),
        (.figureIceHockey, "figure-ice-hockey", .figureIceHockey),
        (.figureIceSkating, "figure-ice-skating", .figureIceSkating),
        (.figureIndoorCycle, "figure-indoor-cycle", .figureIndoorCycle),
        (.figureIndoorRowing, "figure-indoor-rowing", .figureIndoorRowing),
        (.figureIndoorSoccer, "figure-indoor-soccer", .figureIndoorSoccer),
        (.figureJumprope, "figure-jumprope", .figureJumprope),
        (.figureKickboxing, "figure-kickboxing", .figureKickboxing),
        (.figureLacrosse, "figure-lacrosse", .figureLacrosse),
        (.figureMartialArts, "figure-martial-arts", .figureMartialArts),
        (.figureMindAndBody, "figure-mind-and-body", .figureMindAndBody),
        (.figureOpenWaterSwim, "figure-open-water-swim", .figureOpenWaterSwim),
        (.figureOutdoorCycle, "figure-outdoor-cycle", .figureOutdoorCycle),
        (.figureOutdoorRowing, "figure-outdoor-rowing", .figureOutdoorRowing),
        (.figureOutdoorSoccer, "figure-outdoor-soccer", .figureOutdoorSoccer),
        (.figurePickleball, "figure-pickleball", .figurePickleball),
        (.figurePilates, "figure-pilates", .figurePilates),
        (.figurePlay, "figure-play", .figurePlay),
        (.figurePoolSwim, "figure-pool-swim", .figurePoolSwim),
        (.figureRacquetball, "figure-racquetball", .figureRacquetball),
        (.figureRoll, "figure-roll", .figureRoll),
        (.figureRollRunningPace, "figure-roll-running-pace", .figureRollRunningpace),
        (.figureRolling, "figure-rolling", .figureRolling),
        (.figureRugby, "figure-rugby", .figureRugby),
        (.figureRun, "figure-run", .figureRun),
        (.figureRunTreadmill, "figure-run-treadmill", .figureRunTreadmill),
        (.figureSkiingCrosscountry, "figure-skiing-crosscountry", .figureSkiingCrosscountry),
        (.figureSkiingDownhill, "figure-skiing-downhill", .figureSkiingDownhill),
        (.figureSocialDance, "figure-social-dance", .figureSocialdance),
        (.figureSoftball, "figure-softball", .figureSoftball),
        (.figureSquash, "figure-squash", .figureSquash),
        (.figureStairStepper, "figure-stair-stepper", .figureStairStepper),
        (.figureStairs, "figure-stairs", .figureStairs),
        (.figureStand, "figure-stand", .figureStand),
        (.figureStandDress, "figure-stand-dress", .figureStandDress),
        (.figureStepTraining, "figure-step-training", .figureStepTraining),
        (.figureStrengthTrainingFunctional, "figure-strength-training-functional", .figureStrengthtrainingFunctional),
        (.figureStrengthTrainingTraditional, "figure-strength-training-traditional", .figureStrengthtrainingTraditional),
        (.figureSurfing, "figure-surfing", .figureSurfing),
        (.figureTableTennis, "figure-table-tennis", .figureTableTennis),
        (.figureTaichi, "figure-taichi", .figureTaichi),
        (.figureTennis, "figure-tennis", .figureTennis),
        (.figureTrackAndField, "figure-track-and-field", .figureTrackAndField),
        (.figureVolleyball, "figure-volleyball", .figureVolleyball),
        (.figureWalk, "figure-walk", .figureWalk),
        (.figureWalkDiamond, "figure-walk-diamond", .figureWalkDiamondFill),
        (.figureWalkTriangle, "figure-walk-triangle", .figureWalkTriangleFill),
        (.figureWaterFitness, "figure-water-fitness", .figureWaterFitness),
        (.figureWaterpolo, "figure-waterpolo", .figureWaterpolo),
        (.figureWave, "figure-wave", .figureWave),
        (.figureWrestling, "figure-wrestling", .figureWrestling),
        (.figureYoga, "figure-yoga", .figureYoga)
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
            #expect(ListSymbolFigureSportsActivity(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolFigureSportsActivity(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolFigureSportsActivity.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolFigureSportsActivity] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolFigureSportsActivity.allCases == expected)
    }
}
