import CoreNFC
import os.log
import Sentry
import SwiftUI

struct LinkDetailNFCSharingContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.toaster) private var toaster

    let link: LinkModel

    @State private var nfcState: NFCSharingState = .ready
    @State private var nfcSession: NFCNDEFReaderSession?

    var body: some View {
        LinkDetailNFCSharingRenderView(
            state: nfcState,
            linkTitle: link.name,
            retryAction: {
                startNFCSession()
            }
        )
        .onAppear {
            startNFCSession()
        }
        .onDisappear {
            stopNFCSession()
        }
    }

    private func startNFCSession() {
        guard NFCNDEFReaderSession.readingAvailable else {
            Self.logger.error("NFC reading not available on this device")
            let localDescription = "NFC reading not available on this device"
            let appError = AppError.nfcError(localDescription)
            SentrySDK.capture(error: appError)
            toaster.show(error: appError)
            nfcState = .error("NFC not available on this device")
            return
        }

        nfcState = .scanning
        nfcSession = NFCNDEFReaderSession(delegate: NFCDeviceDelegate(
            urlToShare: link.url.absoluteString,
            onSuccess: {
                DispatchQueue.main.async {
                    nfcState = .success
                }
            },
            onError: { error in
                DispatchQueue.main.async {
                    let localDescription = "Failed to share with device: \(error)"
                    let appError = AppError.nfcError(localDescription)
                    Self.logger.error("\(localDescription)")
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                    nfcState = .error(error)
                }
            }
        ), queue: nil, invalidateAfterFirstRead: false)

        nfcSession?.alertMessage = L10n.LinkDetailNfcSharing.NfcSession.alertMessage
        nfcSession?.begin()
    }

    private func stopNFCSession() {
        nfcSession?.invalidate()
        nfcSession = nil
    }
}

enum NFCSharingState {
    case ready
    case scanning
    case success
    case error(String)
}

private class NFCDeviceDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    private let urlToShare: String
    private let onSuccess: () -> Void
    private let onError: (String) -> Void

    init(urlToShare: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        self.urlToShare = urlToShare
        self.onSuccess = onSuccess
        self.onError = onError
    }

    func readerSession(_: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let nfcError = error as? NFCReaderError {
            switch nfcError.code {
            case .readerSessionInvalidationErrorUserCanceled:
                // User canceled, don't show error
                return
            case .readerSessionInvalidationErrorSystemIsBusy:
                onError("NFC system is busy, please try again")
            case .readerSessionInvalidationErrorSessionTimeout:
                onError("NFC session timed out")
            case .readerSessionInvalidationErrorSessionTerminatedUnexpectedly:
                onError("Connection lost with device")
            case .readerSessionInvalidationErrorFirstNDEFTagRead:
                onError("Connection established but sharing failed")
            default:
                onError("NFC session error: \(nfcError.localizedDescription)")
            }
        } else {
            onError("NFC session error: \(error.localizedDescription)")
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs _: [NFCNDEFMessage]) {
        // For device-to-device sharing, we might receive a response here
        // indicating successful transmission
        session.alertMessage = "Link shared successfully!"
        session.invalidate()
        onSuccess()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            onError("No NFC device detected")
            return
        }

        session.connect(to: tag) { [weak self] error in
            if let error = error {
                self?.onError("Failed to connect to device: \(error.localizedDescription)")
                return
            }

            guard let self = self else { return }

            // For device-to-device sharing, we try to write the URL as an NDEF message
            // The receiving device should be able to process this
            self.shareURLWithDevice(tag: tag, session: session)
        }
    }

    private func shareURLWithDevice(tag: NFCNDEFTag, session: NFCNDEFReaderSession) {
        guard let url = URL(string: urlToShare),
              let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url)
        else {
            onError("Failed to create sharing payload")
            return
        }

        let message = NFCNDEFMessage(records: [payload])

        // First check if the device/tag supports NDEF
        tag.queryNDEFStatus { [weak self] status, _, error in
            if let error = error {
                self?.onError("Device communication error: \(error.localizedDescription)")
                return
            }

            switch status {
            case .notSupported:
                self?.onError("The other device doesn't support URL sharing")
            case .readOnly:
                // For device-to-device, we can still try to "broadcast" the URL
                // even if we can't write to the device's storage
                self?.broadcastURLToDevice(tag: tag, session: session, message: message)
            case .readWrite:
                // Device supports full NDEF, try to write
                self?.writeURLToDevice(tag: tag, session: session, message: message)
            @unknown default:
                self?.onError("Unknown device capability")
            }
        }
    }

    private func writeURLToDevice(tag: NFCNDEFTag, session: NFCNDEFReaderSession, message: NFCNDEFMessage) {
        tag.writeNDEF(message) { [weak self] error in
            if let error = error {
                // Writing failed, but we can still try broadcasting
                let appError = AppError.nfcError(error.localizedDescription)
                SentrySDK.capture(error: appError)
                self?.broadcastURLToDevice(tag: tag, session: session, message: message)
            } else {
                session.alertMessage = "Link successfully shared with device!"
                session.invalidate()
                self?.onSuccess()
            }
        }
    }

    private func broadcastURLToDevice(tag: NFCNDEFTag, session: NFCNDEFReaderSession, message: NFCNDEFMessage) {
        // For device-to-device sharing, directly attempt to write the NDEF message
        // The target device may be receive-only, so we don't need to read first
        tag.writeNDEF(message) { [weak self] error in
            if let error = error {
                self?.onError("Failed to share link: \(error.localizedDescription)")
            } else {
                session.alertMessage = "Link successfully shared with device!"
                session.invalidate()
                self?.onSuccess()
            }
        }
    }
}
