import CoreNFC
import os.log
import Photos
import Sentry
import SwiftUI

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
                    Self.logger.warning("URL can not be opened: \(url)")
                    let event = Event(level: .warning)
                    event.message = .init(formatted: "URL can not be opened")
                    event.context = [
                        "link": [
                            "url": url.absoluteString
                        ]
                    ]
                    toaster.warning(description: "URL can not be opened")
                    return
                }
                UIApplication.shared.open(url) { success in
                    if !success {
                        Self.logger.error("Failed to open URL in Safari: \(url)")
                        let error = AppError.failedToOpenURL(url)
                        SentrySDK.capture(error: error)
                        toaster.show(error: error)
                    }
                }
            },
            copyURLAction: {
                UIPasteboard.general.url = item.url
                toaster.success(
                    description: "Copied to clipboard"
                )
            },
            shareQRCodeImageAction: { image in
                imageToShare = .init(image: image)
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
        if let cachedImage = qrcodeCache.image(forContent: item.url.absoluteString) {
            image = .success(cachedImage)
            return
        }

        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(item.url.absoluteString.utf8)
        guard let outputImage = filter.outputImage else {
            Self.logger.error("Failed to generate QR code for URL")
            let error = AppError.qrCodeGenerationError("Failed to generate QR code for URL")
            SentrySDK.capture(error: error)
            image = .failure(error)
            return
        }
        let context = CIContext()

        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            Self.logger.error("Failed to create image from QR code")
            let error = AppError.qrCodeGenerationError("Failed to create image from QR code")
            SentrySDK.capture(error: error)
            image = .failure(error)
            return
        }
        let uiImage = UIImage(cgImage: cgImage)
        qrcodeCache.setImage(uiImage, forContent: item.url.absoluteString)

        image = .success(uiImage)
    }

    func saveImageToPhotos(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .authorized, .limited:
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            toaster.success(description: L10n.Shared.QrCode.SaveToPhotos.success)
                        } else {
                            let localDescription = "Failed to save QR code to Photos: \(error?.localizedDescription ?? "Unknown error")"
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
