import SFSafeSymbols

enum ListSymbolCurrency {
    case dollar
    case euro
    case yen
    case pound
    case cent
    case bitcoin
    case australianDollar
    case austral
    case baht
    case brazilianReal
    case cedi
    case chineseYuan
    case colonCurrency
    case cruzeiro
    case danishKrone
    case dong
    case florin
    case franc
    case guarani
    case hryvnia
    case indianRupee
    case kip
    case lari
    case lira
    case malaysianRinggit
    case manat
    case mill
    case naira
    case norwegianKrone
    case peruvianSoles
    case peseta
    case peso
    case polishZloty
    case ruble
    case rupee
    case shekel
    case singaporeDollar
    case swedishKrona
    case tenge
    case tugrik
    case turkishLira
    case won

    var sfsymbol: SFSymbol {
        switch self {
        case .dollar:
            return .dollarsign
        case .euro:
            return .eurosign
        case .yen:
            return .yensign
        case .pound:
            return .sterlingsign
        case .cent:
            return .centsign
        case .bitcoin:
            return .bitcoinsign
        case .australianDollar:
            return .australiandollarsign
        case .austral:
            return .australsign
        case .baht:
            return .bahtsign
        case .brazilianReal:
            return .brazilianrealsign
        case .cedi:
            return .cedisign
        case .chineseYuan:
            return .chineseyuanrenminbisign
        case .colonCurrency:
            return .coloncurrencysign
        case .cruzeiro:
            return .cruzeirosign
        case .danishKrone:
            return .danishkronesign
        case .dong:
            return .dongsign
        case .florin:
            return .florinsign
        case .franc:
            return .francsign
        case .guarani:
            return .guaranisign
        case .hryvnia:
            return .hryvniasign
        case .indianRupee:
            return .indianrupeesign
        case .kip:
            return .kipsign
        case .lari:
            return .larisign
        case .lira:
            return .lirasign
        case .malaysianRinggit:
            return .malaysianringgitsign
        case .manat:
            return .manatsign
        case .mill:
            return .millsign
        case .naira:
            return .nairasign
        case .norwegianKrone:
            return .norwegiankronesign
        case .peruvianSoles:
            return .peruviansolessign
        case .peseta:
            return .pesetasign
        case .peso:
            return .pesosign
        case .polishZloty:
            return .polishzlotysign
        case .ruble:
            return .rublesign
        case .rupee:
            return .rupeesign
        case .shekel:
            return .shekelsign
        case .singaporeDollar:
            return .singaporedollarsign
        case .swedishKrona:
            return .swedishkronasign
        case .tenge:
            return .tengesign
        case .tugrik:
            return .tugriksign
        case .turkishLira:
            return .turkishlirasign
        case .won:
            return .wonsign
        }
    }
}

extension ListSymbolCurrency: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "dollar":
            self = .dollar
        case "euro":
            self = .euro
        case "yen":
            self = .yen
        case "pound":
            self = .pound
        case "cent":
            self = .cent
        case "bitcoin":
            self = .bitcoin
        case "australian-dollar":
            self = .australianDollar
        case "austral":
            self = .austral
        case "baht":
            self = .baht
        case "brazilian-real":
            self = .brazilianReal
        case "cedi":
            self = .cedi
        case "chinese-yuan":
            self = .chineseYuan
        case "colon-currency":
            self = .colonCurrency
        case "cruzeiro":
            self = .cruzeiro
        case "danish-krone":
            self = .danishKrone
        case "dong":
            self = .dong
        case "florin":
            self = .florin
        case "franc":
            self = .franc
        case "guarani":
            self = .guarani
        case "hryvnia":
            self = .hryvnia
        case "indian-rupee":
            self = .indianRupee
        case "kip":
            self = .kip
        case "lari":
            self = .lari
        case "lira":
            self = .lira
        case "malaysian-ringgit":
            self = .malaysianRinggit
        case "manat":
            self = .manat
        case "mill":
            self = .mill
        case "naira":
            self = .naira
        case "norwegian-krone":
            self = .norwegianKrone
        case "peruvian-soles":
            self = .peruvianSoles
        case "peseta":
            self = .peseta
        case "peso":
            self = .peso
        case "polish-zloty":
            self = .polishZloty
        case "ruble":
            self = .ruble
        case "rupee":
            self = .rupee
        case "shekel":
            self = .shekel
        case "singapore-dollar":
            self = .singaporeDollar
        case "swedish-krona":
            self = .swedishKrona
        case "tenge":
            self = .tenge
        case "tugrik":
            self = .tugrik
        case "turkish-lira":
            self = .turkishLira
        case "won":
            self = .won
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .dollar:
            return "dollar"
        case .euro:
            return "euro"
        case .yen:
            return "yen"
        case .pound:
            return "pound"
        case .cent:
            return "cent"
        case .bitcoin:
            return "bitcoin"
        case .australianDollar:
            return "australian-dollar"
        case .austral:
            return "austral"
        case .baht:
            return "baht"
        case .brazilianReal:
            return "brazilian-real"
        case .cedi:
            return "cedi"
        case .chineseYuan:
            return "chinese-yuan"
        case .colonCurrency:
            return "colon-currency"
        case .cruzeiro:
            return "cruzeiro"
        case .danishKrone:
            return "danish-krone"
        case .dong:
            return "dong"
        case .florin:
            return "florin"
        case .franc:
            return "franc"
        case .guarani:
            return "guarani"
        case .hryvnia:
            return "hryvnia"
        case .indianRupee:
            return "indian-rupee"
        case .kip:
            return "kip"
        case .lari:
            return "lari"
        case .lira:
            return "lira"
        case .malaysianRinggit:
            return "malaysian-ringgit"
        case .manat:
            return "manat"
        case .mill:
            return "mill"
        case .naira:
            return "naira"
        case .norwegianKrone:
            return "norwegian-krone"
        case .peruvianSoles:
            return "peruvian-soles"
        case .peseta:
            return "peseta"
        case .peso:
            return "peso"
        case .polishZloty:
            return "polish-zloty"
        case .ruble:
            return "ruble"
        case .rupee:
            return "rupee"
        case .shekel:
            return "shekel"
        case .singaporeDollar:
            return "singapore-dollar"
        case .swedishKrona:
            return "swedish-krona"
        case .tenge:
            return "tenge"
        case .tugrik:
            return "tugrik"
        case .turkishLira:
            return "turkish-lira"
        case .won:
            return "won"
        }
    }
}

extension ListSymbolCurrency: CaseIterable {
    static var allCases: [ListSymbolCurrency] {
        return [
            .dollar, .euro, .yen, .pound, .cent, .bitcoin, .australianDollar, .austral, .baht, .brazilianReal, .cedi, .chineseYuan, .colonCurrency, .cruzeiro, .danishKrone, .dong, .florin, .franc, .guarani, .hryvnia, .indianRupee, .kip, .lari, .lira, .malaysianRinggit, .manat, .mill, .naira, .norwegianKrone, .peruvianSoles, .peseta, .peso, .polishZloty, .ruble, .rupee, .shekel, .singaporeDollar, .swedishKrona, .tenge, .tugrik, .turkishLira, .won,
        ]
    }
}