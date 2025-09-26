@testable import FlinkyCore
import Testing
import SFSafeSymbols

@Suite("ListSymbolDocumentsReadingWriting")
class ListSymbolDocumentsReadingWritingTests {
    private let symbolRawValuePairs: [(ListSymbolDocumentsReadingWriting, String, SFSymbol)] = [ // swiftlint:disable:this large_tuple
        (.bookmark, "bookmark", .bookmarkFill),
        (.book, "book", .bookFill),
        (.bookClosed, "book-closed", .bookClosedFill),
        (.booksVertical, "books-vertical", .booksVerticalFill),
        (.newspaper, "newspaper", .newspaperFill),
        (.folder, "folder", .folderFill),
        (.textDocument, "text-document", .textDocumentFill),
        (.document, "document", .documentFill),
        (.giftCard, "gift-card", .giftcardFill),
        (.clipboard, "clipboard", .listBulletClipboardFill),
        (.paperPlane, "paper-plane", .paperplaneFill),
        (.present, "present", .giftFill),
        (.birthdayCake, "birthday-cake", .birthdayCakeFill),
        (.graduationCap, "graduation-cap", .graduationcapFill),
        (.backpack, "backpack", .backpackFill),
        (.pen, "pen", .pencilAndRulerFill),
        (.pencil, "pencil", .pencil),
        (.pencilOutline, "pencil-outline", .pencilAndOutline),
        (.pencilScribble, "pencil-scribble", .pencilAndScribble),
        (.pencilRuler, "pencil-ruler", .pencilAndRulerFill),
        (.paper, "paper", .documentFill),
        (.creditcard, "creditcard", .creditcardFill),
        (.money, "money", .banknoteFill)
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
            #expect(ListSymbolDocumentsReadingWriting(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolDocumentsReadingWriting(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolDocumentsReadingWriting.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolDocumentsReadingWriting] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolDocumentsReadingWriting.allCases == expected)
    }
}
