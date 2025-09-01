import SFSafeSymbols

public enum ListSymbolNature {
    case tree
    case leaf
    case carrot
    case mountain
    case sun
    case sunHaze
    case moon
    case rainDrop
    case snowflake
    case flame
    case tornado
    case wind
    case smoke
    case heat
    case humidity
    case cloud
    case cloudBolt
    case cloudBoltRain
    case cloudSunBolt

    var sfsymbol: SFSymbol {
        switch self {
        case .tree:
            return .treeFill
        case .leaf:
            return .leafFill
        case .carrot:
            return .carrotFill
        case .mountain:
            return .mountain2Fill
        case .sun:
            return .sunMaxFill
        case .sunHaze:
            return .sunHazeFill
        case .moon:
            return .moonFill
        case .rainDrop:
            return .dropFill
        case .snowflake:
            return .snowflake
        case .flame:
            return .flameFill
        case .tornado:
            return .tornado
        case .wind:
            return .wind
        case .smoke:
            return .smokeFill
        case .heat:
            return .heatWaves
        case .humidity:
            return .humidityFill
        case .cloud:
            return .cloudFill
        case .cloudBolt:
            return .cloudBoltFill
        case .cloudBoltRain:
            return .cloudBoltRainFill
        case .cloudSunBolt:
            return .cloudSunBoltFill
        }
    }
}

extension ListSymbolNature: RawRepresentable {
    public init?(rawValue: String) {  // swiftlint:disable:this cyclomatic_complexity
        switch rawValue {
        case "tree":
            self = .tree
        case "leaf":
            self = .leaf
        case "carrot":
            self = .carrot
        case "mountain":
            self = .mountain
        case "sun":
            self = .sun
        case "sun-haze":
            self = .sunHaze
        case "moon":
            self = .moon
        case "rain-drop":
            self = .rainDrop
        case "snowflake":
            self = .snowflake
        case "flame":
            self = .flame
        case "tornado":
            self = .tornado
        case "wind":
            self = .wind
        case "smoke":
            self = .smoke
        case "heat":
            self = .heat
        case "humidity":
            self = .humidity
        case "cloud":
            self = .cloud
        case "cloud-bolt":
            self = .cloudBolt
        case "cloud-bolt-rain":
            self = .cloudBoltRain
        case "cloud-sun-bolt":
            self = .cloudSunBolt
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .tree:
            return "tree"
        case .leaf:
            return "leaf"
        case .carrot:
            return "carrot"
        case .mountain:
            return "mountain"
        case .sun:
            return "sun"
        case .sunHaze:
            return "sun-haze"
        case .moon:
            return "moon"
        case .rainDrop:
            return "rain-drop"
        case .snowflake:
            return "snowflake"
        case .flame:
            return "flame"
        case .tornado:
            return "tornado"
        case .wind:
            return "wind"
        case .smoke:
            return "smoke"
        case .heat:
            return "heat"
        case .humidity:
            return "humidity"
        case .cloud:
            return "cloud"
        case .cloudBolt:
            return "cloud-bolt"
        case .cloudBoltRain:
            return "cloud-bolt-rain"
        case .cloudSunBolt:
            return "cloud-sun-bolt"
        }
    }
}

extension ListSymbolNature: CaseIterable {
    public static var allCases: [ListSymbolNature] {
        return [
            .tree, .leaf, .carrot, .mountain, .sun, .sunHaze, .moon, .rainDrop, .snowflake, .flame, .tornado, .wind,
            .smoke, .heat, .humidity, .cloud, .cloudBolt, .cloudBoltRain, .cloudSunBolt
        ]
    }
}
