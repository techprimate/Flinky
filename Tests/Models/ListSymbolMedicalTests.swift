@testable import FlinkyShared
import Testing
import SFSafeSymbols

@Suite("ListSymbolMedical")
class ListSymbolMedicalTests {
    private let symbolRawValuePairs: [(ListSymbolMedical, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.thermometer, "thermometer", .thermometer),
        (.thermometerMedium, "thermometer-medium", .thermometerMedium),
        (.thermometerVariable, "thermometer-variable", .thermometerVariable),
        (.syringe, "syringe", .syringe),
        (.inhaler, "inhaler", .inhaler),
        (.bandage, "bandage", .bandage),
        (.stethoscope, "stethoscope", .stethoscope),
        (.lungs, "lungs", .lungs),
        (.brain, "brain", .brain),
        (.eye, "eye", .eye),
        (.eyes, "eyes", .eyes),
        (.ear, "ear", .ear),
        (.nose, "nose", .nose),
        (.faceMask, "face-mask", .facemaskFill),
        (.cross, "cross", .cross),
        (.crossCase, "cross-case", .crossCase),
        (.starOfLife, "star-of-life", .staroflifeFill),
        (.medication, "medication", .pillsFill),
        (.doctor, "doctor", .personBadgeShieldExclamationmarkFill),
        (.degreeCelsius, "degree-celsius", .degreesignCelsius),
        (.degreeFahrenheit, "degree-fahrenheit", .degreesignFahrenheit),
        (.personBadgeShield, "person-badge-shield", .personBadgeShieldExclamationmarkFill),
        (.eyedropper, "eyedropper", .eyedropper)
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
            #expect(ListSymbolMedical(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolMedical(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolMedical.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolMedical] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolMedical.allCases == expected)
    }
}
