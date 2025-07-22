@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolObject")
class ListSymbolObjectTests {
    private let symbolRawValuePairs: [(ListSymbolObject, String, SFSymbol)] = [
        (.key, "key", .keyFill),
        (.keyHorizontal, "key-horizontal", .keyHorizontalFill),
        (.keyCard, "key-card", .keyCardFill),
        (.lock, "lock", .lockFill),
        (.lockOpen, "lock-open", .lockOpenFill),
        (.hammer, "hammer", .hammerFill),
        (.screwdriver, "screwdriver", .screwdriverFill),
        (.ruler, "ruler", .rulerFill),
        (.paintbrush, "paintbrush", .paintbrushFill),
        (.paintbrushPointed, "paintbrush-pointed", .paintbrushPointedFill),
        (.eraser, "eraser", .eraserFill),
        (.paperclip, "paperclip", .paperclip),
        (.pin, "pin", .pinFill),
        (.tag, "tag", .tagFill),
        (.tray, "tray", .trayFill),
        (.washer, "washer", .washer),
        (.spigot, "spigot", .spigotFill),
        (.flashlight, "flashlight", .lightBeaconMaxFill),
        (.lamp, "lamp", .lampDeskFill),
        (.horn, "horn", .hornBlastFill),
        (.megaphone, "megaphone", .megaphoneFill),
        (.bell, "bell", .bellFill),
        (.wand, "wand", .wandAndRays),
        (.scope, "scope", .scope),
        (.binoculars, "binoculars", .binocularsFill),
        (.flask, "flask", .flaskFill),
        (.hourglass, "hourglass", .hourglass),
        (.gauge, "gauge", .gaugeWithDotsNeedle67percent),
        (.tachometer, "tachometer", .tachometer),
        (.tools, "tools", .wrenchAndScrewdriverFill),
        (.scissors, "scissors", .scissors),
        (.drawingCompass, "drawing-compass", .compassDrawing),
        (.briefcase, "briefcase", .briefcaseFill),
        (.suitcase, "suitcase", .suitcaseFill),
        (.archiveBox, "archive-box", .archiveboxFill),
        (.basket, "basket", .basketFill),
        (.cart, "cart", .cartFill),
        (.shoppingBag, "shopping-bag", .bagFill),
        (.shippingBox, "shipping-box", .shippingboxFill),
        (.umbrella, "umbrella", .umbrellaFill),
        (.tent, "tent", .tent),
        (.tent2, "tent-2", .tent2Fill),
        (.wallet, "wallet", .walletBifoldFill),
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
            #expect(ListSymbolObject(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolObject(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolObject.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolObject] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolObject.allCases == expected)
    }
} 