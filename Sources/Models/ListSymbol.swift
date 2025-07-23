import SFSafeSymbols

enum ListSymbol {
    case emoji(String)
    case listBullet

    case number(ListSymbolNumber)
    case letter(ListSymbolLetter)
    case basicShape(ListSymbolBasicShape)
    case arrows(ListSymbolArrow)
    case math(ListSymbolMath)
    case currency(ListSymbolCurrency)
    case technology(ListSymbolTechnology)
    case transportation(ListSymbolTransportation)
    case sportRecreation(ListSymbolSportRecreation)
    case figureSportsActivity(ListSymbolFigureSportsActivity)
    case animal(ListSymbolAnimal)
    case nature(ListSymbolNature)
    case medical(ListSymbolMedical)
    case food(ListSymbolFood)
    case object(ListSymbolObject)
    case communication(ListSymbolCommunication)
    case human(ListSymbolHuman)
    case placesBuildings(ListSymbolPlacesBuildings)
    case entertainment(ListSymbolEntertainment)
    case documentsReadingWriting(ListSymbolDocumentsReadingWriting)
    case clothingAccessories(ListSymbolClothingAccessories)

    var sfsymbol: SFSymbol {
        switch self {
        case .emoji:
            return .faceSmiling
        case .listBullet:
            return .listBullet
        case .number(let symbol):
            return symbol.sfsymbol
        case .letter(let symbol):
            return symbol.sfsymbol
        case .basicShape(let symbol):
            return symbol.sfsymbol
        case .arrows(let symbol):
            return symbol.sfsymbol
        case .math(let symbol):
            return symbol.sfsymbol
        case .currency(let symbol):
            return symbol.sfsymbol
        case .technology(let symbol):
            return symbol.sfsymbol
        case .transportation(let symbol):
            return symbol.sfsymbol
        case .sportRecreation(let symbol):
            return symbol.sfsymbol
        case .figureSportsActivity(let symbol):
            return symbol.sfsymbol
        case .animal(let symbol):
            return symbol.sfsymbol
        case .nature(let symbol):
            return symbol.sfsymbol
        case .medical(let symbol):
            return symbol.sfsymbol
        case .food(let symbol):
            return symbol.sfsymbol
        case .object(let symbol):
            return symbol.sfsymbol
        case .communication(let symbol):
            return symbol.sfsymbol
        case .human(let symbol):
            return symbol.sfsymbol
        case .placesBuildings(let symbol):
            return symbol.sfsymbol
        case .entertainment(let symbol):
            return symbol.sfsymbol
        case .documentsReadingWriting(let symbol):
            return symbol.sfsymbol
        case .clothingAccessories(let symbol):
            return symbol.sfsymbol
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

    static var defaultForList: Self {
        .listBullet
    }

    static var defaultForLink: Self {
        .communication(.link)
    }
}

extension ListSymbol: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case _ where rawValue.starts(with: "emoji."):
            self = .emoji(String(rawValue.dropFirst("emoji.".count)))
        case "list-bullet":
            self = .listBullet
        case _ where rawValue.starts(with: "number."):
            self = .number(ListSymbolNumber(rawValue: String(rawValue.dropFirst("number.".count)))!)
        case _ where rawValue.starts(with: "letter."):
            self = .letter(ListSymbolLetter(rawValue: String(rawValue.dropFirst("letter.".count)))!)
        case _ where rawValue.starts(with: "basic-shape."):
            self = .basicShape(ListSymbolBasicShape(rawValue: String(rawValue.dropFirst("basic-shape.".count)))!)
        case _ where rawValue.starts(with: "arrows."):
            self = .arrows(ListSymbolArrow(rawValue: String(rawValue.dropFirst("arrows.".count)))!)
        case _ where rawValue.starts(with: "math."):
            self = .math(ListSymbolMath(rawValue: String(rawValue.dropFirst("math.".count)))!)
        case _ where rawValue.starts(with: "currency."):
            self = .currency(ListSymbolCurrency(rawValue: String(rawValue.dropFirst("currency.".count)))!)
        case _ where rawValue.starts(with: "technology."):
            self = .technology(ListSymbolTechnology(rawValue: String(rawValue.dropFirst("technology.".count)))!)    
        case _ where rawValue.starts(with: "transportation."):
            self = .transportation(ListSymbolTransportation(rawValue: String(rawValue.dropFirst("transportation.".count)))!)
        case _ where rawValue.starts(with: "sport-recreation."):
            self = .sportRecreation(ListSymbolSportRecreation(rawValue: String(rawValue.dropFirst("sport-recreation.".count)))!)
        case _ where rawValue.starts(with: "figure-sports-activity."):
            self = .figureSportsActivity(ListSymbolFigureSportsActivity(rawValue: String(rawValue.dropFirst("figure-sports-activity.".count)))!)
        case _ where rawValue.starts(with: "animal."):
            self = .animal(ListSymbolAnimal(rawValue: String(rawValue.dropFirst("animal.".count)))!)
        case _ where rawValue.starts(with: "nature."):
            self = .nature(ListSymbolNature(rawValue: String(rawValue.dropFirst("nature.".count)))!)
        case _ where rawValue.starts(with: "medical."):
            self = .medical(ListSymbolMedical(rawValue: String(rawValue.dropFirst("medical.".count)))!)
        case _ where rawValue.starts(with: "food."):
            self = .food(ListSymbolFood(rawValue: String(rawValue.dropFirst("food.".count)))!)
        case _ where rawValue.starts(with: "object."):
            self = .object(ListSymbolObject(rawValue: String(rawValue.dropFirst("object.".count)))!)
        case _ where rawValue.starts(with: "communication."):
            self = .communication(ListSymbolCommunication(rawValue: String(rawValue.dropFirst("communication.".count)))!)
        case _ where rawValue.starts(with: "human."):
            self = .human(ListSymbolHuman(rawValue: String(rawValue.dropFirst("human.".count)))!)
        case _ where rawValue.starts(with: "places-buildings."):
            self = .placesBuildings(ListSymbolPlacesBuildings(rawValue: String(rawValue.dropFirst("places-buildings.".count)))!)
        case _ where rawValue.starts(with: "entertainment."):
            self = .entertainment(ListSymbolEntertainment(rawValue: String(rawValue.dropFirst("entertainment.".count)))!)
        case _ where rawValue.starts(with: "documents-reading-writing."):
            self = .documentsReadingWriting(ListSymbolDocumentsReadingWriting(rawValue: String(rawValue.dropFirst("documents-reading-writing.".count)))!)
        case _ where rawValue.starts(with: "clothing-accessories."):
            self = .clothingAccessories(ListSymbolClothingAccessories(rawValue: String(rawValue.dropFirst("clothing-accessories.".count)))!)
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
        case .number(let symbol):
            return "number." + symbol.rawValue
        case .letter(let symbol):
            return "letter." + symbol.rawValue
        case .basicShape(let symbol):
            return "basic-shape." + symbol.rawValue
        case .arrows(let symbol):
            return "arrows." + symbol.rawValue
        case .math(let symbol):
            return "math." + symbol.rawValue
        case .currency(let symbol):
            return "currency." + symbol.rawValue
        case .technology(let symbol):
            return "technology." + symbol.rawValue
        case .transportation(let symbol):
            return "transportation." + symbol.rawValue
        case .sportRecreation(let symbol):
            return "sport-recreation." + symbol.rawValue
        case .figureSportsActivity(let symbol):
            return "figure-sports-activity." + symbol.rawValue
        case .animal(let symbol):
            return "animal." + symbol.rawValue
        case .nature(let symbol):
            return "nature." + symbol.rawValue
        case .medical(let symbol):
            return "medical." + symbol.rawValue
        case .food(let symbol):
            return "food." + symbol.rawValue
        case .object(let symbol):
            return "object." + symbol.rawValue
        case .communication(let symbol):
            return "communication." + symbol.rawValue
        case .human(let symbol):
            return "human." + symbol.rawValue
        case .placesBuildings(let symbol):
            return "places-buildings." + symbol.rawValue
        case .entertainment(let symbol):
            return "entertainment." + symbol.rawValue
        case .documentsReadingWriting(let symbol):
            return "documents-reading-writing." + symbol.rawValue
        case .clothingAccessories(let symbol):
            return "clothing-accessories." + symbol.rawValue
        }
    }
}

extension ListSymbol: CaseIterable {
    static var allCases: [ListSymbol] {
        var result: [ListSymbol] = []
        result += ListSymbolEntertainment.allCases.map { .entertainment($0) }
        result += ListSymbolTransportation.allCases.map { .transportation($0) }
        result += ListSymbolHuman.allCases.map { .human($0) }
        result += ListSymbolTechnology.allCases.map { .technology($0) }
        result += ListSymbolSportRecreation.allCases.map { .sportRecreation($0) }
        result += ListSymbolFigureSportsActivity.allCases.map { .figureSportsActivity($0) }
        result += ListSymbolAnimal.allCases.map { .animal($0) }
        result += ListSymbolNature.allCases.map { .nature($0) }
        result += ListSymbolMedical.allCases.map { .medical($0) }
        result += ListSymbolFood.allCases.map { .food($0) }
        result += ListSymbolObject.allCases.map { .object($0) }
        result += ListSymbolCommunication.allCases.map { .communication($0) }
        result += ListSymbolPlacesBuildings.allCases.map { .placesBuildings($0) }
        result += ListSymbolDocumentsReadingWriting.allCases.map { .documentsReadingWriting($0) }
        result += ListSymbolClothingAccessories.allCases.map { .clothingAccessories($0) }
        result += ListSymbolCurrency.allCases.map { .currency($0) }
        result += ListSymbolBasicShape.allCases.map { .basicShape($0) }
        result += ListSymbolArrow.allCases.map { .arrows($0) }
        result += ListSymbolMath.allCases.map { .math($0) }
        result += ListSymbolNumber.allCases.map { .number($0) }
        result += ListSymbolLetter.allCases.map { .letter($0) }
        return result
    }
}

extension ListSymbol: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let symbol = Self(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid list symbol raw value: \(rawValue)")
        }
        self = symbol
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension ListSymbol: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension ListSymbol: Hashable {
    func hash(into hasher: inout Hasher) {
        String(describing: Self.self).hash(into: &hasher)
        0.hash(into: &hasher)
        rawValue.hash(into: &hasher)
    }
}

extension ListSymbol: Identifiable {
    var id: String {
        rawValue
    }
}
