import SFSafeSymbols

public enum ListSymbolMedical {
    case thermometer
    case thermometerMedium
    case thermometerVariable
    case syringe
    case inhaler
    case bandage
    case stethoscope
    case lungs
    case brain
    case eye
    case eyes
    case ear
    case nose
    case faceMask
    case cross
    case crossCase
    case starOfLife
    case medication
    case doctor
    case degreeCelsius
    case degreeFahrenheit
    case personBadgeShield
    case eyedropper

    var sfsymbol: SFSymbol {
        switch self {
        case .thermometer:
            return .medicalThermometerFill
        case .thermometerMedium:
            return .thermometerMedium
        case .thermometerVariable:
            return .thermometerVariable
        case .syringe:
            return .syringeFill
        case .inhaler:
            return .inhalerFill
        case .bandage:
            return .bandageFill
        case .stethoscope:
            return .stethoscope
        case .lungs:
            return .lungsFill
        case .brain:
            return .brainFill
        case .eye:
            return .eyeFill
        case .eyes:
            return .eyes
        case .ear:
            return .ear
        case .nose:
            return .noseFill
        case .faceMask:
            return .facemaskFill
        case .cross:
            return .crossFill
        case .crossCase:
            return .crossCaseFill
        case .starOfLife:
            return .staroflifeFill
        case .medication:
            return .pillsFill
        case .doctor:
            return .personBadgeShieldExclamationmarkFill
        case .degreeCelsius:
            return .degreesignCelsius
        case .degreeFahrenheit:
            return .degreesignFahrenheit
        case .personBadgeShield:
            return .personBadgeShieldExclamationmarkFill
        case .eyedropper:
            return .eyedropperHalffull
        }
    }
}

extension ListSymbolMedical: RawRepresentable {
    public init?(rawValue: String) {  // swiftlint:disable:this cyclomatic_complexity
        switch rawValue {
        case "thermometer":
            self = .thermometer
        case "thermometer-medium":
            self = .thermometerMedium
        case "thermometer-variable":
            self = .thermometerVariable
        case "syringe":
            self = .syringe
        case "inhaler":
            self = .inhaler
        case "bandage":
            self = .bandage
        case "stethoscope":
            self = .stethoscope
        case "lungs":
            self = .lungs
        case "brain":
            self = .brain
        case "eye":
            self = .eye
        case "eyes":
            self = .eyes
        case "ear":
            self = .ear
        case "nose":
            self = .nose
        case "face-mask":
            self = .faceMask
        case "cross":
            self = .cross
        case "cross-case":
            self = .crossCase
        case "star-of-life":
            self = .starOfLife
        case "medication":
            self = .medication
        case "doctor":
            self = .doctor
        case "degree-celsius":
            self = .degreeCelsius
        case "degree-fahrenheit":
            self = .degreeFahrenheit
        case "person-badge-shield":
            self = .personBadgeShield
        case "eyedropper":
            self = .eyedropper
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .thermometer:
            return "thermometer"
        case .thermometerMedium:
            return "thermometer-medium"
        case .thermometerVariable:
            return "thermometer-variable"
        case .syringe:
            return "syringe"
        case .inhaler:
            return "inhaler"
        case .bandage:
            return "bandage"
        case .stethoscope:
            return "stethoscope"
        case .lungs:
            return "lungs"
        case .brain:
            return "brain"
        case .eye:
            return "eye"
        case .eyes:
            return "eyes"
        case .ear:
            return "ear"
        case .nose:
            return "nose"
        case .faceMask:
            return "face-mask"
        case .cross:
            return "cross"
        case .crossCase:
            return "cross-case"
        case .starOfLife:
            return "star-of-life"
        case .medication:
            return "medication"
        case .doctor:
            return "doctor"
        case .degreeCelsius:
            return "degree-celsius"
        case .degreeFahrenheit:
            return "degree-fahrenheit"
        case .personBadgeShield:
            return "person-badge-shield"
        case .eyedropper:
            return "eyedropper"
        }
    }
}

extension ListSymbolMedical: CaseIterable {
    public static var allCases: [ListSymbolMedical] {
        return [
            .thermometer, .thermometerMedium, .thermometerVariable, .syringe, .inhaler, .bandage, .stethoscope, .lungs,
            .brain, .eye, .eyes, .ear, .nose, .faceMask, .cross, .crossCase, .starOfLife, .medication, .doctor,
            .degreeCelsius, .degreeFahrenheit, .personBadgeShield, .eyedropper
        ]
    }
}
