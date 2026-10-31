@testable import FlinkyCore
import Testing

@Suite("ListSymbolNumber")
class ListSymbolNumberTests {
    private let symbolRawValuePairs: [(ListSymbolNumber, String, SystemSymbol)] = [ // swiftlint:disable:this large_tuple
        (.number0, "number-0", .number0CircleFill),
        (.number1, "number-1", .number1CircleFill),
        (.number2, "number-2", .number2CircleFill),
        (.number3, "number-3", .number3CircleFill),
        (.number4, "number-4", .number4CircleFill),
        (.number5, "number-5", .number5CircleFill),
        (.number6, "number-6", .number6CircleFill),
        (.number7, "number-7", .number7CircleFill),
        (.number8, "number-8", .number8CircleFill),
        (.number9, "number-9", .number9CircleFill),
        (.number00, "number-00", .number00CircleFill),
        (.number01, "number-01", .number01CircleFill),
        (.number02, "number-02", .number02CircleFill),
        (.number03, "number-03", .number03CircleFill),
        (.number04, "number-04", .number04CircleFill),
        (.number05, "number-05", .number05CircleFill),
        (.number06, "number-06", .number06CircleFill),
        (.number07, "number-07", .number07CircleFill),
        (.number08, "number-08", .number08CircleFill),
        (.number09, "number-09", .number09CircleFill),
        (.number10, "number-10", .number10CircleFill),
        (.number11, "number-11", .number11CircleFill),
        (.number12, "number-12", .number12CircleFill),
        (.number13, "number-13", .number13CircleFill),
        (.number14, "number-14", .number14CircleFill),
        (.number15, "number-15", .number15CircleFill),
        (.number16, "number-16", .number16CircleFill),
        (.number17, "number-17", .number17CircleFill),
        (.number18, "number-18", .number18CircleFill),
        (.number19, "number-19", .number19CircleFill),
        (.number20, "number-20", .number20CircleFill),
        (.number21, "number-21", .number21CircleFill),
        (.number22, "number-22", .number22CircleFill),
        (.number23, "number-23", .number23CircleFill),
        (.number24, "number-24", .number24CircleFill),
        (.number25, "number-25", .number25CircleFill),
        (.number26, "number-26", .number26CircleFill),
        (.number27, "number-27", .number27CircleFill),
        (.number28, "number-28", .number28CircleFill),
        (.number29, "number-29", .number29CircleFill),
        (.number30, "number-30", .number30CircleFill),
        (.number31, "number-31", .number31CircleFill),
        (.number32, "number-32", .number32CircleFill),
        (.number33, "number-33", .number33CircleFill),
        (.number34, "number-34", .number34CircleFill),
        (.number35, "number-35", .number35CircleFill),
        (.number36, "number-36", .number36CircleFill),
        (.number37, "number-37", .number37CircleFill),
        (.number38, "number-38", .number38CircleFill),
        (.number39, "number-39", .number39CircleFill),
        (.number40, "number-40", .number40CircleFill),
        (.number41, "number-41", .number41CircleFill),
        (.number42, "number-42", .number42CircleFill),
        (.number43, "number-43", .number43CircleFill),
        (.number44, "number-44", .number44CircleFill),
        (.number45, "number-45", .number45CircleFill),
        (.number46, "number-46", .number46CircleFill),
        (.number47, "number-47", .number47CircleFill),
        (.number48, "number-48", .number48CircleFill),
        (.number49, "number-49", .number49CircleFill),
        (.number50, "number-50", .number50CircleFill)
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
            #expect(ListSymbolNumber(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolNumber(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolNumber.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolNumber] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolNumber.allCases == expected)
    }
}
