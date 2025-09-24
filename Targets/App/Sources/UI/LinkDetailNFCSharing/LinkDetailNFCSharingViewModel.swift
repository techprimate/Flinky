import CoreNFC
import FlinkyCore
import Foundation
import Sentry

final class LinkDetailNFCSharingViewModel: ObservableObject {
    @Published private(set) var state: NFCSharingState = .ready

    private let link: LinkModel
    private var nfcSession: NFCNDEFReaderSession?
    private var nfcDelegate: NFCDeviceDelegate?
    private var errorHandler: ((AppError) -> Void)?

    init(link: LinkModel) {
        self.link = link
    }

    func start(errorHandler: @escaping (AppError) -> Void) {
        self.errorHandler = errorHandler

        guard NFCNDEFReaderSession.readingAvailable else {
            let localDescription = "NFC reading not available on this device"
            let appError = AppError.nfcError(localDescription)
            self.errorHandler?(appError)
            state = .error("NFC not available on this device")
            return
        }

        state = .scanning

        let delegate = createDelegate()
        let session = NFCNDEFReaderSession(delegate: delegate, queue: nil, invalidateAfterFirstRead: false)
        session.alertMessage = L10n.LinkDetailNfcSharing.NfcSession.alertMessage
        session.begin()
        nfcSession = session
    }

    func createDelegate() -> NFCDeviceDelegate {
        let delegate = NFCDeviceDelegate(
            urlToShare: link.url.absoluteString,
            onSuccess: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.state = .success

                    // Analytics breadcrumbs and events for NFC success
                    let breadcrumb = Breadcrumb(level: .info, category: "link_sharing")
                    breadcrumb.message = "Link shared via NFC successfully"
                    breadcrumb.data = [
                        "link_id": self.link.id.uuidString,
                        "sharing_method": "nfc"
                    ]
                    SentrySDK.addBreadcrumb(breadcrumb)

                    let nfcEvent = Event(level: .info)
                    nfcEvent.message = SentryMessage(formatted: "link_shared_nfc")
                    nfcEvent.extra = [
                        "link_id": self.link.id.uuidString,
                        "sharing_method": "nfc"
                    ]
                    SentrySDK.capture(event: nfcEvent)

                    let shareEvent = Event(level: .info)
                    shareEvent.message = SentryMessage(formatted: "link_shared")
                    shareEvent.extra = [
                        "link_id": self.link.id.uuidString,
                        "sharing_method": "nfc"
                    ]
                    SentrySDK.capture(event: shareEvent)
                }
            },
            onError: { [weak self] errorMessage in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let localDescription = "Failed to share with tag: \(errorMessage)"
                    let appError = AppError.nfcError(localDescription)
                    self.errorHandler?(appError)
                    self.state = .error(errorMessage)
                }
            }
        )
        nfcDelegate = delegate
        return delegate
    }

    func stop() {
        nfcSession?.invalidate()
        nfcSession = nil
        nfcDelegate = nil
    }

    func retry() {
        guard let errorHandler = errorHandler else { return }
        stop()
        state = .ready
        start(errorHandler: errorHandler)
    }
}
