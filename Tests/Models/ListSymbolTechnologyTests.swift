@testable import Flinky
import Testing
import SFSafeSymbols

@Suite("ListSymbolTechnology")
class ListSymbolTechnologyTests {
    private let symbolRawValuePairs: [(ListSymbolTechnology, String, SFSymbol)] = [
        (.airPurifier, "air-purifier", .airPurifierFill),
        (.airpods, "airpods", .airpodsPro),
        (.alarm, "alarm", .alarmFill),
        (.terminal, "terminal", .appleTerminalFill),
        (.arcadeStick, "arcade-stick", .arcadeStickConsoleFill),
        (.phone, "phone", .phoneFill),
        (.printer, "printer", .printerFill),
        (.computerMouse, "computer-mouse", .computermouseFill),
        (.cpu, "cpu", .cpuFill),
        (.wifi, "wifi", .wifi),
        (.icloud, "icloud", .icloudFill),
        (.externalDrive, "external-drive", .externaldriveConnectedToLineBelowFill),
        (.powerOutletB, "power-outlet-b", .poweroutletTypeBFill),
        (.powerOutletF, "power-outlet-f", .poweroutletTypeFFill),
        (.powerOutletJ, "power-outlet-j", .poweroutletTypeJFill),
        (.powerPlug, "power-plug", .powerplugFill),
        (.powerPlugPortrait, "power-plug-portrait", .powerplugPortraitFill),
        (.speaker, "speaker", .speakerWave3Fill),
        (.hifiSpeaker, "hifi-speaker", .hifispeakerFill),
        (.headphones, "headphones", .headphones),
        (.headset, "headset", .headset),
        (.microphone, "microphone", .microphoneFill),
        (.musicMicrophone, "music-microphone", .musicMicrophone),
        (.recordingTape, "recording-tape", .recordingtape),
        (.playstation, "playstation", .playstationLogo),
        (.xbox, "xbox", .xboxLogo),
        (.video, "video", .videoFill),
        (.photo, "photo", .photo),
        (.photoAngled, "photo-angled", .photoOnRectangleAngled),
        (.camera, "camera", .cameraMacro),
        (.computer, "computer", .pc),
        (.gameController, "game-controller", .gamecontrollerFill),
        (.tv, "tv", .tv),
        (.headlightHighBeam, "headlight-high-beam", .headlightHighBeam),
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
            #expect(ListSymbolTechnology(rawValue: rawValue) == expectedSymbol)
        }
    }

    @Test
    func testInitWithRawValue_withInvalidRawValue_shouldReturnNil() {
        #expect(ListSymbolTechnology(rawValue: "invalid") == nil)
    }

    @Test
    func testSFSymbol_shouldReturnExpectedValue() {
        for (symbol, _, sfsymbol) in symbolRawValuePairs {
            #expect(symbol.sfsymbol == sfsymbol)
        }
    }

    @Test
    func testAllCases_shouldContainAllSymbols() {
        let allCases = Set(ListSymbolTechnology.allCases)
        for (symbol, _, _) in symbolRawValuePairs {
            #expect(allCases.contains(symbol))
        }
        // Assert no other symbols are present
        #expect(allCases.count == symbolRawValuePairs.count)
    }

    @Test
    func testAllCases_shouldMatchExpectedOrder() {
        let expected: [ListSymbolTechnology] = symbolRawValuePairs.map { $0.0 }
        #expect(ListSymbolTechnology.allCases == expected)
    }
} 
