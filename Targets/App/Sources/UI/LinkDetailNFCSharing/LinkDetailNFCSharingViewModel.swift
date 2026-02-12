import CoreNFC
import FlinkyCore
import Foundation
import SentrySwift

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
            // Track NFC availability (not available)
            SentrySDK.metrics.gauge(
                key: "nfc.available",
                value: 0.0,
                unit: .generic("capability")
            )
            return
        }

        // Track NFC availability (available)
        SentrySDK.metrics.gauge(
            key: "nfc.available",
            value: 1.0,
            unit: .generic("capability")
        )

        // Track NFC share initiated
        SentryMetricsHelper.trackNFCShareInitiated()

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

                    // Analytics breadcrumbs and metrics for NFC success
                    let breadcrumb = Breadcrumb(level: .info, category: "link_sharing")
                    breadcrumb.message = "Link shared via NFC successfully"
                    breadcrumb.data = [
                        "link_id": self.link.id.uuidString,
                        "sharing_method": "nfc"
                    ]
                    SentrySDK.addBreadcrumb(breadcrumb)

                    // Track NFC-specific sharing and general sharing using metrics
                    SentryMetricsHelper.trackLinkSharedNFC(linkId: self.link.id.uuidString)
                    SentryMetricsHelper.trackLinkShared(sharingMethod: "nfc", linkId: self.link.id.uuidString)
                    SentryMetricsHelper.trackNFCShareSuccess()
                }
            },
            onError: { [weak self] errorMessage in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let localDescription = "Failed to share with tag: \(errorMessage)"
                    let appError = AppError.nfcError(localDescription)
                    self.errorHandler?(appError)
                    self.state = .error(errorMessage)
                    // Track NFC share failure
                    SentryMetricsHelper.trackNFCShareFailed(errorType: "tag_error")
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
