import SFSafeSymbols

enum ListSymbolTechnology {
    case airPurifier
    case airpods
    case alarm
    case terminal
    case arcadeStick
    case phone
    case printer
    case computerMouse
    case cpu
    case wifi
    case icloud
    case externalDrive
    case powerOutletB
    case powerOutletF
    case powerOutletJ
    case powerPlug
    case powerPlugPortrait
    case speaker
    case hifiSpeaker
    case headphones
    case headset
    case microphone
    case musicMicrophone
    case recordingTape
    case playstation
    case xbox
    case video
    case photo
    case photoAngled
    case camera
    case computer
    case gameController
    case tv  // swiftlint:disable:this identifier_name
    case headlightHighBeam

    var sfsymbol: SFSymbol {
        switch self {
        case .airPurifier:
            return .airPurifierFill
        case .airpods:
            return .airpodsPro
        case .alarm:
            return .alarmFill
        case .terminal:
            return .appleTerminalFill
        case .arcadeStick:
            return .arcadeStickConsoleFill
        case .phone:
            return .phoneFill
        case .printer:
            return .printerFill
        case .computerMouse:
            return .computermouseFill
        case .cpu:
            return .cpuFill
        case .wifi:
            return .wifi
        case .icloud:
            return .icloudFill
        case .externalDrive:
            return .externaldriveConnectedToLineBelowFill
        case .powerOutletB:
            return .poweroutletTypeBFill
        case .powerOutletF:
            return .poweroutletTypeFFill
        case .powerOutletJ:
            return .poweroutletTypeJFill
        case .powerPlug:
            return .powerplugFill
        case .powerPlugPortrait:
            return .powerplugPortraitFill
        case .speaker:
            return .speakerWave3Fill
        case .hifiSpeaker:
            return .hifispeakerFill
        case .headphones:
            return .headphones
        case .headset:
            return .headset
        case .microphone:
            return .microphoneFill
        case .musicMicrophone:
            return .musicMicrophone
        case .recordingTape:
            return .recordingtape
        case .playstation:
            return .playstationLogo
        case .xbox:
            return .xboxLogo
        case .video:
            return .videoFill
        case .photo:
            return .photo
        case .photoAngled:
            return .photoOnRectangleAngled
        case .camera:
            return .cameraMacro
        case .tv:
            return .tv
        case .headlightHighBeam:
            return .headlightHighBeam
        case .computer:
            return .pc
        case .gameController:
            return .gamecontrollerFill
        }
    }
}

extension ListSymbolTechnology: RawRepresentable {
    init?(rawValue: String) {  // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch rawValue {
        case "air-purifier":
            self = .airPurifier
        case "airpods":
            self = .airpods
        case "alarm":
            self = .alarm
        case "terminal":
            self = .terminal
        case "arcade-stick":
            self = .arcadeStick
        case "phone":
            self = .phone
        case "printer":
            self = .printer
        case "computer":
            self = .computer
        case "computer-mouse":
            self = .computerMouse
        case "cpu":
            self = .cpu
        case "wifi":
            self = .wifi
        case "icloud":
            self = .icloud
        case "external-drive":
            self = .externalDrive
        case "power-outlet-b":
            self = .powerOutletB
        case "power-outlet-f":
            self = .powerOutletF
        case "power-outlet-j":
            self = .powerOutletJ
        case "power-plug":
            self = .powerPlug
        case "power-plug-portrait":
            self = .powerPlugPortrait
        case "speaker":
            self = .speaker
        case "hifi-speaker":
            self = .hifiSpeaker
        case "headphones":
            self = .headphones
        case "headset":
            self = .headset
        case "microphone":
            self = .microphone
        case "music-microphone":
            self = .musicMicrophone
        case "recording-tape":
            self = .recordingTape
        case "playstation":
            self = .playstation
        case "xbox":
            self = .xbox
        case "video":
            self = .video
        case "photo":
            self = .photo
        case "photo-angled":
            self = .photoAngled
        case "camera":
            self = .camera
        case "tv":
            self = .tv
        case "game-controller":
            self = .gameController
        case "headlight-high-beam":
            self = .headlightHighBeam
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .airPurifier:
            return "air-purifier"
        case .airpods:
            return "airpods"
        case .alarm:
            return "alarm"
        case .terminal:
            return "terminal"
        case .arcadeStick:
            return "arcade-stick"
        case .phone:
            return "phone"
        case .printer:
            return "printer"
        case .computerMouse:
            return "computer-mouse"
        case .cpu:
            return "cpu"
        case .wifi:
            return "wifi"
        case .icloud:
            return "icloud"
        case .externalDrive:
            return "external-drive"
        case .powerOutletB:
            return "power-outlet-b"
        case .powerOutletF:
            return "power-outlet-f"
        case .powerOutletJ:
            return "power-outlet-j"
        case .powerPlug:
            return "power-plug"
        case .powerPlugPortrait:
            return "power-plug-portrait"
        case .speaker:
            return "speaker"
        case .hifiSpeaker:
            return "hifi-speaker"
        case .headphones:
            return "headphones"
        case .headset:
            return "headset"
        case .microphone:
            return "microphone"
        case .musicMicrophone:
            return "music-microphone"
        case .recordingTape:
            return "recording-tape"
        case .playstation:
            return "playstation"
        case .xbox:
            return "xbox"
        case .video:
            return "video"
        case .photo:
            return "photo"
        case .photoAngled:
            return "photo-angled"
        case .camera:
            return "camera"
        case .tv:
            return "tv"
        case .headlightHighBeam:
            return "headlight-high-beam"
        case .computer:
            return "computer"
        case .gameController:
            return "game-controller"
        }
    }
}

extension ListSymbolTechnology: CaseIterable {
    static var allCases: [ListSymbolTechnology] {
        return [
            .airPurifier,
            .airpods,
            .alarm,
            .terminal,
            .arcadeStick,
            .phone,
            .printer,
            .computerMouse,
            .cpu,
            .wifi,
            .icloud,
            .externalDrive,
            .powerOutletB,
            .powerOutletF,
            .powerOutletJ,
            .powerPlug,
            .powerPlugPortrait,
            .speaker,
            .hifiSpeaker,
            .headphones,
            .headset,
            .microphone,
            .musicMicrophone,
            .recordingTape,
            .playstation,
            .xbox,
            .video,
            .photo,
            .photoAngled,
            .camera,
            .computer,
            .gameController,
            .tv,
            .headlightHighBeam
        ]
    }
}
