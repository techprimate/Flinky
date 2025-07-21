import SwiftUI
import os.log
import Sentry

struct LinkDetailContainerView: View {
    @Environment(\.qrcodeCache) private var qrcodeCache

    let item: LinkModel

    @State private var image: Result<UIImage, Error>?
    @State private var isEditing = false
    
    private static let logger = Logger(subsystem: "com.techprimate.Flinky", category: "LinkDetailContainerView")

    var body: some View {
        LinkDetailRenderView(
            title: item.name,
            url: item.url,
            image: image,
            editAction: {
                isEditing = true
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
}
