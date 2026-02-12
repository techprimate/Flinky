import CoreNFC
import FlinkyCore
import Photos
import SentrySwift
import SwiftUI
import os.log

struct LinkDetailContainerView: View {
    private struct ImageBox: Identifiable {
        let id = UUID()
        let image: UIImage
    }

    private static let logger = Logger.forType(Self.self)

    @Environment(\.qrcodeCache) private var qrcodeCache
    @Environment(\.toaster) private var toaster

    let item: LinkModel

    @State private var image: Result<UIImage, Error>?
    @State private var isEditing = false

    @State private var imageToShare: ImageBox?
    @State private var isSharingViaNFCPresented = false

    var body: some View {
        LinkDetailRenderView(
            linkId: item.id,
            title: item.name,
            url: item.url,
            color: item.color ?? .defaultForLink,
            image: image,
            editAction: {
                isEditing = true
            },
            openInSafariAction: {
                let url = item.url
                guard UIApplication.shared.canOpenURL(url) else {
                    Self.logger.warning("URL can not be opened for link: \(item.id.uuidString)")
                    let event = Event(level: .warning)
                    event.message = .init(formatted: "URL can not be opened")
                    event.extra = [
                        "link_id": item.id.uuidString
                    ]
                    toaster.warning(description: "URL can not be opened")
                    return
                }
                UIApplication.shared.open(url) { success in
                    if !success {
                        Self.logger.error("Failed to open URL in Safari for link: \(item.id.uuidString)")
                        let error = AppError.unknownError("Failed to open URL for link: \(item.id.uuidString)")
                        SentrySDK.capture(error: error)
                        toaster.show(error: error)
                    } else {
                        // Track successful URL opening for user engagement analysis
                        // Uses "link_interaction" category to distinguish from sharing actions
                        let breadcrumb = Breadcrumb(level: .info, category: "link_interaction")
                        breadcrumb.message = "Link opened in Safari"
                        breadcrumb.data = [
                            "link_id": item.id.uuidString  // Enables correlation with link usage patterns
                        ]
                        SentrySDK.addBreadcrumb(breadcrumb)

                        // Track link opened using metrics
                        SentryMetricsHelper.trackLinkOpened(linkId: item.id.uuidString)
                    }
                }
            },
            copyURLAction: {
                UIPasteboard.general.url = item.url
                toaster.success(
                    description: "Copied to clipboard"
                )

                // Track URL copy action for debugging user interaction patterns
                // Link ID helps correlate with other actions on the same link
                let breadcrumb = Breadcrumb(level: .info, category: "link_sharing")
                breadcrumb.message = "Link URL copied to clipboard"
                breadcrumb.data = [
                    "link_id": item.id.uuidString,
                    "sharing_method": "copy_url"
                ]
                SentrySDK.addBreadcrumb(breadcrumb)

                // Track sharing using metrics - better for aggregate counts than individual events
                SentryMetricsHelper.trackLinkShared(sharingMethod: "copy_url", linkId: item.id.uuidString)
            },
            shareQRCodeImageAction: { image in
                imageToShare = .init(image: image)

                // Track QR code sharing via system share sheet
                // Distinguishes from QR code save-to-photos for usage pattern analysis
                let breadcrumb = Breadcrumb(level: .info, category: "link_sharing")
                breadcrumb.message = "QR code shared"
                breadcrumb.data = [
                    "link_id": item.id.uuidString,
                    "sharing_method": "qr_code_share"
                ]
                SentrySDK.addBreadcrumb(breadcrumb)

                // Track sharing using metrics - better for aggregate counts than individual events
                SentryMetricsHelper.trackLinkShared(sharingMethod: "qr_code_share", linkId: item.id.uuidString)
            },
            saveQRCodeImageToPhotos: { image in
                saveImageToPhotos(image)
            },
            isNFCSharingSupported: NFCReaderSession.readingAvailable,
            shareViaNFCAction: {
                isSharingViaNFCPresented = true
            }
        )
        .task(priority: .utility) {
            await createQRCodeImageInBackground()
        }
        // We add the Sentry trace view modifier after the task to ensure it captures the part of the task execution
        // which is performed on the main thread.
        .sentryTrace("LINK_DETAIL_VIEW")
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                LinkInfoContainerView(link: item)
            }
        }
        .sheet(item: $imageToShare) { image in
            ActivityViewController(activityItems: [image])
        }
        .sheet(isPresented: $isSharingViaNFCPresented) {
            LinkDetailNFCSharingContainerView(link: item)
        }
    }

    func createQRCodeImageInBackground() async {
        let startTime = CFAbsoluteTimeGetCurrent()

        if let cachedImage = qrcodeCache.image(forContent: item.url.absoluteString) {
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            let imageSize = "\(Int(cachedImage.size.width))x\(Int(cachedImage.size.height))"
            SentryMetricsHelper.trackQRCodeGenerationDuration(duration: duration, cacheHit: true, imageSize: imageSize)
            image = .success(cachedImage)
            return
        }

        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(item.url.absoluteString.utf8)
        guard let outputImage = filter.outputImage else {
            Self.logger.error("Failed to generate QR code for link: \(item.id.uuidString)")
            let error = AppError.qrCodeGenerationError("Failed to generate QR code for link: \(item.id.uuidString)")
            SentrySDK.capture(error: error)
            image = .failure(error)
            return
        }
        let context = CIContext()

        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            Self.logger.error("Failed to create image from QR code for link: \(item.id.uuidString)")
            let error = AppError.qrCodeGenerationError(
                "Failed to create image from QR code for link: \(item.id.uuidString)")
            SentrySDK.capture(error: error)
            image = .failure(error)
            return
        }
        let uiImage = UIImage(cgImage: cgImage)
        qrcodeCache.setImage(uiImage, forContent: item.url.absoluteString)

        let duration = CFAbsoluteTimeGetCurrent() - startTime
        let imageSize = "\(Int(uiImage.size.width))x\(Int(uiImage.size.height))"
        SentryMetricsHelper.trackQRCodeGenerationDuration(duration: duration, cacheHit: false, imageSize: imageSize)

        image = .success(uiImage)
    }

    func saveImageToPhotos(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .authorized, .limited:
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in  // swiftlint:disable:this multiple_closures_with_trailing_closure
                    DispatchQueue.main.async {
                        if success {
                            toaster.success(description: L10n.Shared.QrCode.SaveToPhotos.success)

                            // Track QR code save to Photos - different from sharing via share sheet
                            // This indicates user wants to keep QR code for later use
                            let breadcrumb = Breadcrumb(level: .info, category: "link_sharing")
                            breadcrumb.message = "QR code saved to Photos"
                            breadcrumb.data = [
                                "link_id": item.id.uuidString,
                                "sharing_method": "qr_code_save"
                            ]
                            SentrySDK.addBreadcrumb(breadcrumb)

                            // Track sharing using metrics - better for aggregate counts than individual events
                            SentryMetricsHelper.trackLinkShared(sharingMethod: "qr_code_save", linkId: item.id.uuidString)
                        } else {
                            let localDescription =
                                "Failed to save QR code to Photos: \(error?.localizedDescription ?? "Unknown error")"
                            let appError = AppError.unknownError(localDescription)
                            SentrySDK.capture(error: appError)
                            toaster.show(error: appError)
                        }
                    }
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    let localDescription = "Failed to save QR code to Photos: Photos access denied"
                    let appError = AppError.unknownError(localDescription)
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            case .notDetermined:
                DispatchQueue.main.async {
                    let localDescription = "Failed to save QR code to Photos: Photos access not determined"
                    let appError = AppError.unknownError(localDescription)
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            @unknown default:
                DispatchQueue.main.async {
                    let localDescription = "Failed to save QR code to Photos: Unknown authorization status"
                    let appError = AppError.unknownError(localDescription)
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            }
        }
    }
}
