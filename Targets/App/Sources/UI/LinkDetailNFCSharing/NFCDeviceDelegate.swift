import CoreNFC
import Foundation

final class NFCDeviceDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    private let urlToShare: String
    private let onSuccess: () -> Void
    private let onError: (String) -> Void

    init(urlToShare: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        self.urlToShare = urlToShare
        self.onSuccess = onSuccess
        self.onError = onError
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let nfcError = error as? NFCReaderError {
            switch nfcError.code {
            case .readerSessionInvalidationErrorUserCanceled:
                return
            case .readerSessionInvalidationErrorSystemIsBusy:
                onError("NFC system is busy, please try again")
            case .readerSessionInvalidationErrorSessionTimeout:
                onError("NFC session timed out")
            case .readerSessionInvalidationErrorSessionTerminatedUnexpectedly:
                onError("Connection lost with tag")
            case .readerSessionInvalidationErrorFirstNDEFTagRead:
                onError("NFC session completed after first tag read")
            default:
                onError("NFC session error: \(nfcError.localizedDescription)")
            }
        } else {
            onError("NFC session error: \(error.localizedDescription)")
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs _: [NFCNDEFMessage]) {}

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            onError("No NFC tag detected")
            return
        }

        if tags.count > 1 {
            session.alertMessage = "More than one tag detected. Please present only one tag."
            session.restartPolling()
            return
        }

        session.connect(to: tag) { [weak self] error in
            if let error = error {
                self?.onError("Failed to connect to tag: \(error.localizedDescription)")
                return
            }

            self?.writeURL(tag: tag, session: session)
        }
    }

    private func writeURL(tag: NFCNDEFTag, session: NFCNDEFReaderSession) {
        guard let url = URL(string: urlToShare), let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            onError("Failed to create sharing payload")
            return
        }

        let message = NFCNDEFMessage(records: [payload])

        tag.queryNDEFStatus { [weak self] status, capacity, error in
            if let error = error {
                self?.onError("Tag communication error: \(error.localizedDescription)")
                return
            }

            switch status {
            case .notSupported:
                self?.onError("This tag doesn't support NDEF.")
            case .readOnly:
                self?.onError("This tag is read-only and cannot be written.")
            case .readWrite:
                if message.length > capacity {
                    self?.onError("The URL is too large for this tag (capacity: \(capacity) bytes).")
                    return
                }
                self?.write(message: message, to: tag, session: session)
            @unknown default:
                self?.onError("Unknown tag capability")
            }
        }
    }

    private func write(message: NFCNDEFMessage, to tag: NFCNDEFTag, session: NFCNDEFReaderSession) {
        tag.writeNDEF(message) { [weak self] error in
            if let error = error {
                self?.onError("Failed to write to tag: \(error.localizedDescription)")
            } else {
                session.alertMessage = "Link successfully written to the tag!"
                session.invalidate()
                self?.onSuccess()
            }
        }
    }
}
