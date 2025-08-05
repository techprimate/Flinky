@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolNumber")
class ListSymbolNumberTests {
    private let symbolRawValuePairs: [(ListSymbolNumber, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.number0, "number-0", ._0CircleFill),
        (.number1, "number-1", ._1CircleFill),
        (.number2, "number-2", ._2CircleFill),
        (.number3, "number-3", ._3CircleFill),
        (.number4, "number-4", ._4CircleFill),
        (.number5, "number-5", ._5CircleFill),
        (.number6, "number-6", ._6CircleFill),
        (.number7, "number-7", ._7CircleFill),
        (.number8, "number-8", ._8CircleFill),
        (.number9, "number-9", ._9CircleFill),
        (.number00, "number-00", ._00CircleFill),
        (.number01, "number-01", ._01CircleFill),
        (.number02, "number-02", ._02CircleFill),
        (.number03, "number-03", ._03CircleFill),
        (.number04, "number-04", ._04CircleFill),
        (.number05, "number-05", ._05CircleFill),
        (.number06, "number-06", ._06CircleFill),
        (.number07, "number-07", ._07CircleFill),
        (.number08, "number-08", ._08CircleFill),
        (.number09, "number-09", ._09CircleFill),
        (.number10, "number-10", ._10CircleFill),
        (.number11, "number-11", ._11CircleFill),
        (.number12, "number-12", ._12CircleFill),
        (.number13, "number-13", ._13CircleFill),
        (.number14, "number-14", ._14CircleFill),
        (.number15, "number-15", ._15CircleFill),
        (.number16, "number-16", ._16CircleFill),
        (.number17, "number-17", ._17CircleFill),
        (.number18, "number-18", ._18CircleFill),
        (.number19, "number-19", ._19CircleFill),
        (.number20, "number-20", ._20CircleFill),
        (.number21, "number-21", ._21CircleFill),
        (.number22, "number-22", ._22CircleFill),
        (.number23, "number-23", ._23CircleFill),
        (.number24, "number-24", ._24CircleFill),
        (.number25, "number-25", ._25CircleFill),
        (.number26, "number-26", ._26CircleFill),
        (.number27, "number-27", ._27CircleFill),
        (.number28, "number-28", ._28CircleFill),
        (.number29, "number-29", ._29CircleFill),
        (.number30, "number-30", ._30CircleFill),
        (.number31, "number-31", ._31CircleFill),
        (.number32, "number-32", ._32CircleFill),
        (.number33, "number-33", ._33CircleFill),
        (.number34, "number-34", ._34CircleFill),
        (.number35, "number-35", ._35CircleFill),
        (.number36, "number-36", ._36CircleFill),
        (.number37, "number-37", ._37CircleFill),
        (.number38, "number-38", ._38CircleFill),
        (.number39, "number-39", ._39CircleFill),
        (.number40, "number-40", ._40CircleFill),
        (.number41, "number-41", ._41CircleFill),
        (.number42, "number-42", ._42CircleFill),
        (.number43, "number-43", ._43CircleFill),
        (.number44, "number-44", ._44CircleFill),
        (.number45, "number-45", ._45CircleFill),
        (.number46, "number-46", ._46CircleFill),
        (.number47, "number-47", ._47CircleFill),
        (.number48, "number-48", ._48CircleFill),
        (.number49, "number-49", ._49CircleFill),
        (.number50, "number-50", ._50CircleFill)
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
