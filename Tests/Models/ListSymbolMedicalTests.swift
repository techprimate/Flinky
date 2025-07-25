@testable import Flinky
import Testing

private let symbolRawValuePairs: [(ListSymbolMedical, String)] = [
    (.thermometer, "thermometer"),
    (.thermometerMedium, "thermometer-medium"),
    (.thermometerVariable, "thermometer-variable"),
    (.syringe, "syringe"),
    (.inhaler, "inhaler"),
    (.bandage, "bandage"),
    (.stethoscope, "stethoscope"),
    (.lungs, "lungs"),
    (.brain, "brain"),
    (.eye, "eye"),
    (.eyes, "eyes"),
    (.ear, "ear"),
    (.nose, "nose"),
    (.faceMask, "face-mask"),
    (.cross, "cross"),
    (.crossCase, "cross-case"),
    (.starOfLife, "star-of-life"),
    (.medication, "medication"),
    (.doctor, "doctor"),
    (.degreeCelsius, "degree-celsius"),
    (.degreeFahrenheit, "degree-fahrenheit"),
    (.personBadgeShield, "person-badge-shield"),
    (.eyedropper, "eyedropper")
]

@Test
func testListSymbolMedicalRawValueAndInit() {
    for (symbol, rawValue) in symbolRawValuePairs {
        #expect(symbol.rawValue == rawValue)
        #expect(ListSymbolMedical(rawValue: rawValue) == symbol)
    }
}

@Test
func testListSymbolMedicalAllCasesContainsAllSymbols() {
    let allCases = Set(ListSymbolMedical.allCases)
    for (symbol, _) in symbolRawValuePairs {
        #expect(allCases.contains(symbol))
    }
}

@Test
func testListSymbolMedicalAllCasesOrder() {
    let expected: [ListSymbolMedical] = symbolRawValuePairs.map { $0.0 }
    let allCases = ListSymbolMedical.allCases
    for symbol in expected {
        #expect(allCases.contains(symbol))
    }
}
