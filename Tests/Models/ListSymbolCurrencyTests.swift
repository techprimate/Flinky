@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolCurrency")
class ListSymbolCurrencyTests {
    private let symbolRawValuePairs: [(ListSymbolCurrency, String, SFSymbol)] = [
        (.dollar, "dollar", .dollarsign),
        (.euro, "euro", .eurosign),
        (.yen, "yen", .yensign),
        (.pound, "pound", .sterlingsign),
        (.cent, "cent", .centsign),
        (.bitcoin, "bitcoin", .bitcoinsign),
        (.australianDollar, "australian-dollar", .australiandollarsign),
        (.austral, "austral", .australsign),
        (.baht, "baht", .bahtsign),
        (.brazilianReal, "brazilian-real", .brazilianrealsign),
        (.cedi, "cedi", .cedisign),
        (.chineseYuan, "chinese-yuan", .chineseyuanrenminbisign),
        (.colonCurrency, "colon-currency", .coloncurrencysign),
        (.cruzeiro, "cruzeiro", .cruzeirosign),
        (.danishKrone, "danish-krone", .danishkronesign),
        (.dong, "dong", .dongsign),
        (.florin, "florin", .florinsign),
        (.franc, "franc", .francsign),
        (.guarani, "guarani", .guaranisign),
        (.hryvnia, "hryvnia", .hryvniasign),
        (.indianRupee, "indian-rupee", .indianrupeesign),
        (.kip, "kip", .kipsign),
        (.lari, "lari", .larisign),
        (.lira, "lira", .lirasign),
        (.malaysianRinggit, "malaysian-ringgit", .malaysianringgitsign),
        (.manat, "manat", .manatsign),
        (.mill, "mill", .millsign),
        (.naira, "naira", .nairasign),
        (.norwegianKrone, "norwegian-krone", .norwegiankronesign),
        (.peruvianSoles, "peruvian-soles", .peruviansolessign),
        (.peseta, "peseta", .pesetasign),
        (.peso, "peso", .pesosign),
        (.polishZloty, "polish-zloty", .polishzlotysign),
        (.ruble, "ruble", .rublesign),
        (.rupee, "rupee", .rupeesign),
        (.shekel, "shekel", .shekelsign),
        (.singaporeDollar, "singapore-dollar", .singaporedollarsign),
        (.swedishKrona, "swedish-krona", .swedishkronasign),
        (.tenge, "tenge", .tengesign),
        (.tugrik, "tugrik", .tugriksign),
        (.turkishLira, "turkish-lira", .turkishlirasign),
        (.won, "won", .wonsign),
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
            #expect(ListSymbolCurrency(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolCurrency(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolCurrency.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolCurrency] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolCurrency.allCases == expected)
    }
} 