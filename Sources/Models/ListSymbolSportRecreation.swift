import SFSafeSymbols

enum ListSymbolSportRecreation {
    case soccerBall
    case basketball
    case americanFootball
    case baseball
    case baseballDiamond
    case rugbyBall
    case tennisBall
    case tennisRacket
    case volleyball
    case hockeyPuck
    case surfboard
    case skis
    case snowboard
    case dumbBell
    case oars
    case medal
    case medalStar
    case trophy
    case running

    var sfsymbol: SFSymbol {
        switch self {
        case .soccerBall:
            return .soccerball
        case .basketball:
            return .basketballFill
        case .americanFootball:
            return .americanFootballFill
        case .baseball:
            return .baseballFill
        case .baseballDiamond:
            return .baseballDiamondBasesOutsIndicator
        case .rugbyBall:
            return .rugbyballFill
        case .tennisBall:
            return .tennisballFill
        case .tennisRacket:
            return .tennisRacket
        case .volleyball:
            return .volleyballFill
        case .hockeyPuck:
            return .hockeyPuckFill
        case .surfboard:
            return .surfboardFill
        case .skis:
            return .skisFill
        case .snowboard:
            return .snowboardFill
        case .dumbBell:
            return .dumbbellFill
        case .oars:
            return .oar2Crossed
        case .medal:
            return .medalFill
        case .medalStar:
            return .medalStarFill
        case .trophy:
            return .trophyFill
        case .running:
            return .figureRun
        }
    }
}

extension ListSymbolSportRecreation: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "soccer-ball":
            self = .soccerBall
        case "american-football":
            self = .americanFootball
        case "baseball":
            self = .baseball
        case "baseball-diamond":
            self = .baseballDiamond
        case "basketball":
            self = .basketball
        case "rugby-ball":
            self = .rugbyBall
        case "tennis-ball":
            self = .tennisBall
        case "tennis-racket":
            self = .tennisRacket
        case "volleyball":
            self = .volleyball
        case "hockey-puck":
            self = .hockeyPuck
        case "surfboard":
            self = .surfboard
        case "skis":
            self = .skis
        case "snowboard":
            self = .snowboard
        case "dumb-bell":
            self = .dumbBell
        case "oars":
            self = .oars
        case "medal":
            self = .medal
        case "medal-star":
            self = .medalStar
        case "trophy":
            self = .trophy
        case "running":
            self = .running
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .soccerBall:
            return "soccer-ball"
        case .basketball:
            return "basketball"
        case .americanFootball:
            return "american-football"
        case .baseball:
            return "baseball"
        case .baseballDiamond:
            return "baseball-diamond"
        case .rugbyBall:
            return "rugby-ball"
        case .tennisBall:
            return "tennis-ball"
        case .tennisRacket:
            return "tennis-racket"
        case .volleyball:
            return "volleyball"
        case .hockeyPuck:
            return "hockey-puck"
        case .surfboard:
            return "surfboard"
        case .skis:
            return "skis"
        case .snowboard:
            return "snowboard"
        case .dumbBell:
            return "dumb-bell"
        case .oars:
            return "oars"
        case .medal:
            return "medal"
        case .medalStar:
            return "medal-star"
        case .trophy:
            return "trophy"
        case .running:
            return "running"
        }
    }
}

extension ListSymbolSportRecreation: CaseIterable {
    static var allCases: [ListSymbolSportRecreation] {
        return [
            .soccerBall, .basketball, .americanFootball, .baseball, .baseballDiamond, .rugbyBall, .tennisBall, .tennisRacket, .volleyball, .hockeyPuck, .surfboard, .skis, .snowboard, .dumbBell, .oars, .medal, .medalStar, .trophy, .running
        ]
    }
}
