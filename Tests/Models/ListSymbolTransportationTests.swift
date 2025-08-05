@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolTransportation")
class ListSymbolTransportationTests {
    private let symbolRawValuePairs: [(ListSymbolTransportation, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.airplane, "airplane", .airplane),
        (.car, "car", .carFill),
        (.carSide, "car-side", .carSideFill),
        (.bus, "bus", .busFill),
        (.tram, "tram", .tramFill),
        (.lightrail, "lightrail", .lightrailFill),
        (.cableCar, "cable-car", .cablecarFill),
        (.ferry, "ferry", .ferryFill),
        (.sailboat, "sailboat", .sailboatFill),
        (.bicycle, "bicycle", .bicycle),
        (.motorcycle, "motorcycle", .motorcycleFill),
        (.moped, "moped", .mopedFill),
        (.scooter, "scooter", .scooter),
        (.skateboard, "skateboard", .skateboardFill),
        (.drone, "drone", .droneFill),
        (.fuelPump, "fuel-pump", .fuelpumpFill),
        (.steeringWheel, "steering-wheel", .steeringwheel),
        (.wheelchair, "wheelchair", .wheelchair),
        (.engineCombustion, "engine-combustion", .engineCombustionFill),
        (.truck, "truck", .truckBoxFill)
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
            #expect(ListSymbolTransportation(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolTransportation(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolTransportation.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolTransportation] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolTransportation.allCases == expected)
    }
}
