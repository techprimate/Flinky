import SFSafeSymbols

enum LinkSymbol {
    case emoji(String)
    case listBullet
    case bookmark
    case mapPin
    case present
    case birthdayCake
    case graduationCap
    case backpack
    case pen
    case paper
    case book
    case archiveBox
    case creditcard
    case money
    case dumbBell
    case run
    case forkKnife
    case wineGlass
    case medication
    case doctor
    case chairLounge
    case house
    case office
    case university
    case tent
    case tv
    case musicNote
    case computer
    case joystick
    case headphones
    case leaf
    case carrot
    case person
    case person2
    case person3
    case pawPrint
    case teddyBear
    case fish
    case handcart
    case cart
    case shoppingBag
    case shippingBox
    case soccerBall
    case tennisBall
    case basketball
    case americanFootball
    case tennisRacket
    case tram
    case airplane
    case sailboat
    case car
    case umbrella
    case sun
    case moon
    case rainDrop
    case snowflake
    case flame
    case suitcase
    case tools
    case scissors
    case drawingCompass
    case curlyBraces
    case lightbulb
    case message
    case exclamataionmark
    case asteriks
    case square
    case circle
    case triangle
    case diamond
    case heart
    case star

    var sfsymbol: SFSymbol {
        switch self {
        case .emoji:
            return .faceSmiling
        case .listBullet:
            return .listBullet
        case .bookmark:
            return .bookmarkFill
        case .mapPin:
            return .mappin
        case .present:
            return .giftFill
        case .birthdayCake:
            return .birthdayCakeFill
        case .graduationCap:
            return .graduationcapFill
        case .backpack:
            return .backpackFill
        case .pen:
            return .pencilAndRuler
        case .paper:
            return .documentFill
        case .book:
            return .bookFill
        case .archiveBox:
            return .archiveboxFill
        case .creditcard:
            return .creditcardFill
        case .money:
            return .banknoteFill
        case .dumbBell:
            return .dumbbellFill
        case .run:
            return .figureRun
        case .forkKnife:
            return .forkKnife
        case .wineGlass:
            return .wineglassFill
        case .medication:
            return .pillsFill
        case .doctor:
            return ._2Brakesignal
        case .chairLounge:
            return .chairLoungeFill
        case .house:
            return .houseFill
        case .office:
            return .building2Fill
        case .university:
            return .buildingColumnsFill
        case .tent:
            return .tent
        case .tv:
            return .tv
        case .musicNote:
            return .musicNote
        case .computer:
            return .pc
        case .joystick:
            return .gamecontrollerFill
        case .headphones:
            return .headphones
        case .leaf:
            return .leaf
        case .carrot:
            return .carrot
        case .person:
            return .personFill
        case .person2:
            return .person2Fill
        case .person3:
            return .person3Fill
        case .pawPrint:
            return .pawprintFill
        case .teddyBear:
            return .teddybearFill
        case .fish:
            return .fish
        case .handcart:
            return .basketFill
        case .cart:
            return .cart
        case .shoppingBag:
            return .bagFill
        case .shippingBox:
            return .shippingboxFill
        case .soccerBall:
            return .soccerball
        case .tennisBall:
            return .tennisballFill
        case .basketball:
            return .basketball
        case .americanFootball:
            return .americanFootballFill
        case .tennisRacket:
            return .tennisRacket
        case .tram:
            return .tramFill
        case .airplane:
            return .airplane
        case .sailboat:
            return .sailboatFill
        case .car:
            return .carFill
        case .umbrella:
            return .umbrellaFill
        case .sun:
            return .sunMaxFill
        case .moon:
            return .moon
        case .rainDrop:
            return .dropFill
        case .snowflake:
            return .snowflake
        case .flame:
            return .flameFill
        case .suitcase:
            return .suitcaseFill
        case .tools:
            return .wrenchAndScrewdriverFill
        case .scissors:
            return .scissors
        case .drawingCompass:
            return .compassDrawing
        case .curlyBraces:
            return .curlybraces
        case .lightbulb:
            return .lightbulbFill
        case .message:
            return .messageFill
        case .exclamataionmark:
            return .exclamationmark2
        case .asteriks:
            return .asterisk
        case .square:
            return .squareFill
        case .circle:
            return .circleFill
        case .triangle:
            return .triangleFill
        case .diamond:
            return .diamondFill
        case .heart:
            return .heartFill
        case .star:
            return .starFill
        }
    }

    var text: String? {
        switch self {
        case let .emoji(emoji):
            return emoji
        default:
            return nil
        }
    }

    var isEmoji: Bool {
        guard case .emoji = self else {
            return false
        }
        return true
    }

    static var `default`: Self {
        .listBullet
    }
}

extension LinkSymbol: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case _ where rawValue.starts(with: "emoji."):
            self = .emoji(String(rawValue.dropFirst("emoji.".count)))
        case "list-bullet":
            self = .listBullet
        case "bookmark":
            self = .bookmark
        case "map-pin":
            self = .mapPin
        case "gift":
            self = .present
        case "birthday-cake":
            self = .birthdayCake
        case "graduation-cap":
            self = .graduationCap
        case "backpack":
            self = .backpack
        case "pencil-and-ruler":
            self = .pen
        case "document":
            self = .paper
        case "book":
            self = .book
        case "archive-box":
            self = .archiveBox
        case "creditcard":
            self = .creditcard
        case "banknote":
            self = .money
        case "dumb-bell":
            self = .dumbBell
        case "run":
            self = .run
        case "fork-knife":
            self = .forkKnife
        case "wine-glass":
            self = .wineGlass
        case "medication":
            self = .medication
        case "doctor":
            self = .doctor
        case "chair-lounge":
            self = .chairLounge
        case "house":
            self = .house
        case "office":
            self = .office
        case "university":
            self = .university
        case "tent":
            self = .tent
        case "tv":
            self = .tv
        case "music-note":
            self = .musicNote
        case "computer":
            self = .computer
        case "joystick":
            self = .joystick
        case "headphones":
            self = .headphones
        case "leaf":
            self = .leaf
        case "carrot":
            self = .carrot
        case "person":
            self = .person
        case "person-2":
            self = .person2
        case "person-3":
            self = .person3
        case "paw-print":
            self = .pawPrint
        case "teddy-bear":
            self = .teddyBear
        case "fish":
            self = .fish
        case "basket":
            self = .handcart
        case "cart":
            self = .cart
        case "shopping-bag":
            self = .shoppingBag
        case "shipping-box":
            self = .shippingBox
        case "soccer-ball":
            self = .soccerBall
        case "tennis-ball":
            self = .tennisBall
        case "basketball":
            self = .basketball
        case "american-football":
            self = .americanFootball
        case "tennis-racket":
            self = .tennisRacket
        case "tram":
            self = .tram
        case "airplane":
            self = .airplane
        case "sailboat":
            self = .sailboat
        case "car":
            self = .car
        case "umbrella":
            self = .umbrella
        case "sun":
            self = .sun
        case "moon":
            self = .moon
        case "rain-drop":
            self = .rainDrop
        case "snowflake":
            self = .snowflake
        case "flame":
            self = .flame
        case "suitcase":
            self = .suitcase
        case "tools":
            self = .tools
        case "scissors":
            self = .scissors
        case "drawing-compass":
            self = .drawingCompass
        case "curly-braces":
            self = .curlyBraces
        case "lightbulb":
            self = .lightbulb
        case "message":
            self = .message
        case "exclamation-mark":
            self = .exclamataionmark
        case "asterisk":
            self = .asteriks
        case "square":
            self = .square
        case "circle":
            self = .circle
        case "triangle":
            self = .triangle
        case "diamond":
            self = .diamond
        case "heart":
            self = .heart
        case "star":
            self = .star
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case let .emoji(emoji):
            return "emoji.\(emoji)"
        case .listBullet:
            return "list-bullet"
        case .bookmark:
            return "bookmark"
        case .mapPin:
            return "map-pin"
        case .present:
            return "gift"
        case .birthdayCake:
            return "birthday-cake"
        case .graduationCap:
            return "graduation-cap"
        case .backpack:
            return "backpack"
        case .pen:
            return "pencil-and-ruler"
        case .paper:
            return "document"
        case .book:
            return "book"
        case .archiveBox:
            return "archive-box"
        case .creditcard:
            return "creditcard"
        case .money:
            return "banknote"
        case .dumbBell:
            return "dumb-bell"
        case .run:
            return "run"
        case .forkKnife:
            return "fork-knife"
        case .wineGlass:
            return "wine-glass"
        case .medication:
            return "medication"
        case .doctor:
            return "doctor"
        case .chairLounge:
            return "chair-lounge"
        case .house:
            return "house"
        case .office:
            return "office"
        case .university:
            return "university"
        case .tent:
            return "tent"
        case .tv:
            return "tv"
        case .musicNote:
            return "music-note"
        case .computer:
            return "computer"
        case .joystick:
            return "joystick"
        case .headphones:
            return "headphones"
        case .leaf:
            return "leaf"
        case .carrot:
            return "carrot"
        case .person:
            return "person"
        case .person2:
            return "person-2"
        case .person3:
            return "person-3"
        case .pawPrint:
            return "paw-print"
        case .teddyBear:
            return "teddy-bear"
        case .fish:
            return "fish"
        case .handcart:
            return "basket"
        case .cart:
            return "cart"
        case .shoppingBag:
            return "shopping-bag"
        case .shippingBox:
            return "shipping-box"
        case .soccerBall:
            return "soccer-ball"
        case .tennisBall:
            return "tennis-ball"
        case .basketball:
            return "basketball"
        case .americanFootball:
            return "american-football"
        case .tennisRacket:
            return "tennis-racket"
        case .tram:
            return "tram"
        case .airplane:
            return "airplane"
        case .sailboat:
            return "sailboat"
        case .car:
            return "car"
        case .umbrella:
            return "umbrella"
        case .sun:
            return "sun"
        case .moon:
            return "moon"
        case .rainDrop:
            return "rain-drop"
        case .snowflake:
            return "snowflake"
        case .flame:
            return "flame"
        case .suitcase:
            return "suitcase"
        case .tools:
            return "tools"
        case .scissors:
            return "scissors"
        case .drawingCompass:
            return "drawing-compass"
        case .curlyBraces:
            return "curly-braces"
        case .lightbulb:
            return "lightbulb"
        case .message:
            return "message"
        case .exclamataionmark:
            return "exclamation-mark"
        case .asteriks:
            return "asterisk"
        case .square:
            return "square"
        case .circle:
            return "circle"
        case .triangle:
            return "triangle"
        case .diamond:
            return "diamond"
        case .heart:
            return "heart"
        case .star:
            return "star"
        }
    }
}

extension LinkSymbol: CaseIterable {
    static var allCases: [Self] {
        return [
            .listBullet,
            .bookmark,
            .mapPin,
            .present,
            .birthdayCake,
            .graduationCap,
            .backpack,
            .pen,
            .paper,
            .book,
            .archiveBox,
            .creditcard,
            .money,
            .dumbBell,
            .run,
            .forkKnife,
            .wineGlass,
            .medication,
            .doctor,
            .chairLounge,
            .house,
            .office,
            .university,
            .tent,
            .tv,
            .musicNote,
            .computer,
            .joystick,
            .headphones,
            .leaf,
            .carrot,
            .person,
            .person2,
            .person3,
            .pawPrint,
            .teddyBear,
            .fish,
            .handcart,
            .cart,
            .shoppingBag,
            .shippingBox,
            .soccerBall,
            .tennisBall,
            .basketball,
            .americanFootball,
            .tennisRacket,
            .tram,
            .airplane,
            .sailboat,
            .car,
            .umbrella,
            .sun,
            .moon,
            .rainDrop,
            .snowflake,
            .flame,
            .suitcase,
            .tools,
            .scissors,
            .drawingCompass,
            .curlyBraces,
            .lightbulb,
            .message,
            .exclamataionmark,
            .asteriks,
            .square,
            .circle,
            .triangle,
            .diamond,
            .heart,
            .star
        ]
    }
}

extension LinkSymbol: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let symbol = Self(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid link symbol raw value: \(rawValue)")
        }
        self = symbol
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension LinkSymbol: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension LinkSymbol: Hashable {
    func hash(into hasher: inout Hasher) {
        String(describing: Self.self).hash(into: &hasher)
        0.hash(into: &hasher)
        rawValue.hash(into: &hasher)
    }
}

extension LinkSymbol: Identifiable {
    var id: String {
        rawValue
    }
}
