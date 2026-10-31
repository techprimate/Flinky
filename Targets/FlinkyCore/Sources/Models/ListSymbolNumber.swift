// swiftlint:disable file_length

public enum ListSymbolNumber {
    case number0
    case number1
    case number2
    case number3
    case number4
    case number5
    case number6
    case number7
    case number8
    case number9
    case number00
    case number01
    case number02
    case number03
    case number04
    case number05
    case number06
    case number07
    case number08
    case number09
    case number10
    case number11
    case number12
    case number13
    case number14
    case number15
    case number16
    case number17
    case number18
    case number19
    case number20
    case number21
    case number22
    case number23
    case number24
    case number25
    case number26
    case number27
    case number28
    case number29
    case number30
    case number31
    case number32
    case number33
    case number34
    case number35
    case number36
    case number37
    case number38
    case number39
    case number40
    case number41
    case number42
    case number43
    case number44
    case number45
    case number46
    case number47
    case number48
    case number49
    case number50

    var sfsymbol: SystemSymbol {
        switch self {
        case .number00:
            return .number00CircleFill
        case .number0:
            return .number0CircleFill
        case .number01:
            return .number01CircleFill
        case .number1:
            return .number1CircleFill
        case .number02:
            return .number02CircleFill
        case .number2:
            return .number2CircleFill
        case .number03:
            return .number03CircleFill
        case .number3:
            return .number3CircleFill
        case .number04:
            return .number04CircleFill
        case .number4:
            return .number4CircleFill
        case .number05:
            return .number05CircleFill
        case .number5:
            return .number5CircleFill
        case .number06:
            return .number06CircleFill
        case .number6:
            return .number6CircleFill
        case .number07:
            return .number07CircleFill
        case .number7:
            return .number7CircleFill
        case .number08:
            return .number08CircleFill
        case .number8:
            return .number8CircleFill
        case .number09:
            return .number09CircleFill
        case .number9:
            return .number9CircleFill
        case .number10:
            return .number10CircleFill
        case .number11:
            return .number11CircleFill
        case .number12:
            return .number12CircleFill
        case .number13:
            return .number13CircleFill
        case .number14:
            return .number14CircleFill
        case .number15:
            return .number15CircleFill
        case .number16:
            return .number16CircleFill
        case .number17:
            return .number17CircleFill
        case .number18:
            return .number18CircleFill
        case .number19:
            return .number19CircleFill
        case .number20:
            return .number20CircleFill
        case .number21:
            return .number21CircleFill
        case .number22:
            return .number22CircleFill
        case .number23:
            return .number23CircleFill
        case .number24:
            return .number24CircleFill
        case .number25:
            return .number25CircleFill
        case .number26:
            return .number26CircleFill
        case .number27:
            return .number27CircleFill
        case .number28:
            return .number28CircleFill
        case .number29:
            return .number29CircleFill
        case .number30:
            return .number30CircleFill
        case .number31:
            return .number31CircleFill
        case .number32:
            return .number32CircleFill
        case .number33:
            return .number33CircleFill
        case .number34:
            return .number34CircleFill
        case .number35:
            return .number35CircleFill
        case .number36:
            return .number36CircleFill
        case .number37:
            return .number37CircleFill
        case .number38:
            return .number38CircleFill
        case .number39:
            return .number39CircleFill
        case .number40:
            return .number40CircleFill
        case .number41:
            return .number41CircleFill
        case .number42:
            return .number42CircleFill
        case .number43:
            return .number43CircleFill
        case .number44:
            return .number44CircleFill
        case .number45:
            return .number45CircleFill
        case .number46:
            return .number46CircleFill
        case .number47:
            return .number47CircleFill
        case .number48:
            return .number48CircleFill
        case .number49:
            return .number49CircleFill
        case .number50:
            return .number50CircleFill
        }
    }

    var text: String? {
        return nil
    }

    var isEmoji: Bool {
        return false
    }
}

extension ListSymbolNumber: RawRepresentable {
    public init?(rawValue: String) {  // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch rawValue {
        case "number-0":
            self = .number0
        case "number-00":
            self = .number00
        case "number-01":
            self = .number01
        case "number-1":
            self = .number1
        case "number-02":
            self = .number02
        case "number-2":
            self = .number2
        case "number-03":
            self = .number03
        case "number-3":
            self = .number3
        case "number-04":
            self = .number04
        case "number-4":
            self = .number4
        case "number-05":
            self = .number05
        case "number-5":
            self = .number5
        case "number-06":
            self = .number06
        case "number-6":
            self = .number6
        case "number-07":
            self = .number07
        case "number-7":
            self = .number7
        case "number-08":
            self = .number08
        case "number-8":
            self = .number8
        case "number-09":
            self = .number09
        case "number-9":
            self = .number9
        case "number-10":
            self = .number10
        case "number-11":
            self = .number11
        case "number-12":
            self = .number12
        case "number-13":
            self = .number13
        case "number-14":
            self = .number14
        case "number-15":
            self = .number15
        case "number-16":
            self = .number16
        case "number-17":
            self = .number17
        case "number-18":
            self = .number18
        case "number-19":
            self = .number19
        case "number-20":
            self = .number20
        case "number-21":
            self = .number21
        case "number-22":
            self = .number22
        case "number-23":
            self = .number23
        case "number-24":
            self = .number24
        case "number-25":
            self = .number25
        case "number-26":
            self = .number26
        case "number-27":
            self = .number27
        case "number-28":
            self = .number28
        case "number-29":
            self = .number29
        case "number-30":
            self = .number30
        case "number-31":
            self = .number31
        case "number-32":
            self = .number32
        case "number-33":
            self = .number33
        case "number-34":
            self = .number34
        case "number-35":
            self = .number35
        case "number-36":
            self = .number36
        case "number-37":
            self = .number37
        case "number-38":
            self = .number38
        case "number-39":
            self = .number39
        case "number-40":
            self = .number40
        case "number-41":
            self = .number41
        case "number-42":
            self = .number42
        case "number-43":
            self = .number43
        case "number-44":
            self = .number44
        case "number-45":
            self = .number45
        case "number-46":
            self = .number46
        case "number-47":
            self = .number47
        case "number-48":
            self = .number48
        case "number-49":
            self = .number49
        case "number-50":
            self = .number50
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .number0:
            return "number-0"
        case .number00:
            return "number-00"
        case .number01:
            return "number-01"
        case .number1:
            return "number-1"
        case .number02:
            return "number-02"
        case .number2:
            return "number-2"
        case .number03:
            return "number-03"
        case .number3:
            return "number-3"
        case .number04:
            return "number-04"
        case .number4:
            return "number-4"
        case .number05:
            return "number-05"
        case .number5:
            return "number-5"
        case .number06:
            return "number-06"
        case .number6:
            return "number-6"
        case .number07:
            return "number-07"
        case .number7:
            return "number-7"
        case .number08:
            return "number-08"
        case .number8:
            return "number-8"
        case .number09:
            return "number-09"
        case .number9:
            return "number-9"
        case .number10:
            return "number-10"
        case .number11:
            return "number-11"
        case .number12:
            return "number-12"
        case .number13:
            return "number-13"
        case .number14:
            return "number-14"
        case .number15:
            return "number-15"
        case .number16:
            return "number-16"
        case .number17:
            return "number-17"
        case .number18:
            return "number-18"
        case .number19:
            return "number-19"
        case .number20:
            return "number-20"
        case .number21:
            return "number-21"
        case .number22:
            return "number-22"
        case .number23:
            return "number-23"
        case .number24:
            return "number-24"
        case .number25:
            return "number-25"
        case .number26:
            return "number-26"
        case .number27:
            return "number-27"
        case .number28:
            return "number-28"
        case .number29:
            return "number-29"
        case .number30:
            return "number-30"
        case .number31:
            return "number-31"
        case .number32:
            return "number-32"
        case .number33:
            return "number-33"
        case .number34:
            return "number-34"
        case .number35:
            return "number-35"
        case .number36:
            return "number-36"
        case .number37:
            return "number-37"
        case .number38:
            return "number-38"
        case .number39:
            return "number-39"
        case .number40:
            return "number-40"
        case .number41:
            return "number-41"
        case .number42:
            return "number-42"
        case .number43:
            return "number-43"
        case .number44:
            return "number-44"
        case .number45:
            return "number-45"
        case .number46:
            return "number-46"
        case .number47:
            return "number-47"
        case .number48:
            return "number-48"
        case .number49:
            return "number-49"
        case .number50:
            return "number-50"
        }
    }
}

extension ListSymbolNumber: CaseIterable {
    public static var allCases: [Self] {
        return [
            .number0, .number1, .number2, .number3, .number4, .number5, .number6, .number7, .number8, .number9,
            .number00, .number01, .number02, .number03, .number04, .number05, .number06, .number07, .number08,
            .number09, .number10,
            .number11, .number12, .number13, .number14, .number15, .number16, .number17, .number18, .number19,
            .number20,
            .number21, .number22, .number23, .number24, .number25, .number26, .number27, .number28, .number29,
            .number30,
            .number31, .number32, .number33, .number34, .number35, .number36, .number37, .number38, .number39,
            .number40,
            .number41, .number42, .number43, .number44, .number45, .number46, .number47, .number48, .number49,
            .number50
        ]
    }
}
