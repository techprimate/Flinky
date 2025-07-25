import SFSafeSymbols

enum ListSymbolObject {
    case key
    case keyHorizontal
    case keyCard
    case lock
    case lockOpen
    case hammer
    case screwdriver
    case ruler
    case paintbrush
    case paintbrushPointed
    case eraser
    case paperclip
    case pin
    case tag
    case tray
    case washer
    case spigot
    case flashlight
    case lamp
    case horn
    case megaphone
    case bell
    case wand
    case scope
    case binoculars
    case flask
    case hourglass
    case gauge
    case tachometer
    case tools
    case scissors
    case drawingCompass
    case briefcase
    case suitcase
    case archiveBox
    case basket
    case cart
    case shoppingBag
    case shippingBox
    case umbrella
    case tent
    case tent2
    case wallet

    var sfsymbol: SFSymbol {
        switch self {
        case .key:
            return .keyFill
        case .keyHorizontal:
            return .keyHorizontalFill
        case .keyCard:
            return .keyCardFill
        case .lock:
            return .lockFill
        case .lockOpen:
            return .lockOpenFill
        case .hammer:
            return .hammerFill
        case .screwdriver:
            return .screwdriverFill
        case .ruler:
            return .rulerFill
        case .paintbrush:
            return .paintbrushFill
        case .paintbrushPointed:
            return .paintbrushPointedFill
        case .eraser:
            return .eraserFill
        case .paperclip:
            return .paperclip
        case .pin:
            return .pinFill
        case .tag:
            return .tagFill
        case .tray:
            return .trayFill
        case .washer:
            return .washer
        case .spigot:
            return .spigotFill
        case .flashlight:
            return .lightBeaconMaxFill
        case .lamp:
            return .lampDeskFill
        case .horn:
            return .hornBlastFill
        case .megaphone:
            return .megaphoneFill
        case .bell:
            return .bellFill
        case .wand:
            return .wandAndRays
        case .scope:
            return .scope
        case .binoculars:
            return .binocularsFill
        case .flask:
            return .flaskFill
        case .hourglass:
            return .hourglass
        case .gauge:
            return .gaugeWithDotsNeedle67percent
        case .tachometer:
            return .tachometer
        case .tools:
            return .wrenchAndScrewdriverFill
        case .scissors:
            return .scissors
        case .drawingCompass:
            return .compassDrawing
        case .briefcase:
            return .briefcaseFill
        case .suitcase:
            return .suitcaseFill
        case .archiveBox:
            return .archiveboxFill
        case .basket:
            return .basketFill
        case .cart:
            return .cartFill
        case .shoppingBag:
            return .bagFill
        case .shippingBox:
            return .shippingboxFill
        case .umbrella:
            return .umbrellaFill
        case .tent:
            return .tent
        case .tent2:
            return .tent2Fill
        case .wallet:
            return .walletBifoldFill
        }
    }
}

extension ListSymbolObject: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "key":
            self = .key
        case "key-horizontal":
            self = .keyHorizontal
        case "key-card":
            self = .keyCard
        case "lock":
            self = .lock
        case "lock-open":
            self = .lockOpen
        case "hammer":
            self = .hammer
        case "screwdriver":
            self = .screwdriver
        case "ruler":
            self = .ruler
        case "paintbrush":
            self = .paintbrush
        case "paintbrush-pointed":
            self = .paintbrushPointed
        case "eraser":
            self = .eraser
        case "paperclip":
            self = .paperclip
        case "pin":
            self = .pin
        case "tag":
            self = .tag
        case "tray":
            self = .tray
        case "washer":
            self = .washer
        case "spigot":
            self = .spigot
        case "flashlight":
            self = .flashlight
        case "lamp":
            self = .lamp
        case "horn":
            self = .horn
        case "megaphone":
            self = .megaphone
        case "bell":
            self = .bell
        case "wand":
            self = .wand
        case "scope":
            self = .scope
        case "binoculars":
            self = .binoculars
        case "flask":
            self = .flask
        case "hourglass":
            self = .hourglass
        case "gauge":
            self = .gauge
        case "tachometer":
            self = .tachometer
        case "tools":
            self = .tools
        case "scissors":
            self = .scissors
        case "drawing-compass":
            self = .drawingCompass
        case "briefcase":
            self = .briefcase
        case "suitcase":
            self = .suitcase
        case "archive-box":
            self = .archiveBox
        case "basket":
            self = .basket
        case "cart":
            self = .cart
        case "shopping-bag":
            self = .shoppingBag
        case "shipping-box":
            self = .shippingBox
        case "handcart":
            self = .basket
        case "handcart-2":
            self = .basket
        case "shopping-cart":
            self = .cart
        case "umbrella":
            self = .umbrella
        case "tent":
            self = .tent
        case "tent-2":
            self = .tent2
        case "wallet":
            self = .wallet
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .key:
            return "key"
        case .keyHorizontal:
            return "key-horizontal"
        case .keyCard:
            return "key-card"
        case .lock:
            return "lock"
        case .lockOpen:
            return "lock-open"
        case .hammer:
            return "hammer"
        case .screwdriver:
            return "screwdriver"
        case .ruler:
            return "ruler"
        case .paintbrush:
            return "paintbrush"
        case .paintbrushPointed:
            return "paintbrush-pointed"
        case .eraser:
            return "eraser"
        case .paperclip:
            return "paperclip"
        case .pin:
            return "pin"
        case .tag:
            return "tag"
        case .tray:
            return "tray"
        case .washer:
            return "washer"
        case .spigot:
            return "spigot"
        case .flashlight:
            return "flashlight"
        case .lamp:
            return "lamp"
        case .horn:
            return "horn"
        case .megaphone:
            return "megaphone"
        case .bell:
            return "bell"
        case .wand:
            return "wand"
        case .scope:
            return "scope"
        case .binoculars:
            return "binoculars"
        case .flask:
            return "flask"
        case .hourglass:
            return "hourglass"
        case .gauge:
            return "gauge"
        case .tachometer:
            return "tachometer"
        case .tools:
            return "tools"
        case .scissors:
            return "scissors"
        case .drawingCompass:
            return "drawing-compass"
        case .briefcase:
            return "briefcase"
        case .suitcase:
            return "suitcase"
        case .archiveBox:
            return "archive-box"
        case .basket:
            return "basket"
        case .cart:
            return "cart"
        case .shoppingBag:
            return "shopping-bag"
        case .shippingBox:
            return "shipping-box"
        case .umbrella:
            return "umbrella"
        case .tent:
            return "tent"
        case .tent2:
            return "tent-2"
        case .wallet:
            return "wallet"
        }
    }
}

extension ListSymbolObject: CaseIterable {
    static var allCases: [ListSymbolObject] {
        return [
            .key, .keyHorizontal, .keyCard, .lock, .lockOpen, .hammer, .screwdriver, .ruler, .paintbrush, .paintbrushPointed, .eraser, .paperclip, .pin, .tag, .tray, .washer, .spigot, .flashlight, .lamp, .horn, .megaphone, .bell, .wand, .scope, .binoculars, .flask, .hourglass, .gauge, .tachometer, .tools, .scissors, .drawingCompass, .briefcase, .suitcase, .archiveBox, .basket, .cart, .shoppingBag, .shippingBox, .umbrella, .tent, .tent2, .wallet
        ]
    }
}
