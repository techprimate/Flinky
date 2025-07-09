import SwiftUI

struct LinkDetailContainerView: View {
    @Environment(\.qrcodeCache) private var qrcodeCache

    let item: LinkModel

    @State private var image: Result<UIImage, Error>?

    var body: some View {
        LinkDetailRenderView(
            title: item.title,
            url: item.url,
            image: image,
            editAction: {
                // TODO: Action to edit the link can be implemented here
            }
        )
        .task(priority: .utility) {
            await createQRCodeImageInBackground()
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
            image = .failure(NSError(domain: "QR Code generation failed", code: 0, userInfo: nil))
            return
        }
        let context = CIContext()

        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            image = .failure(NSError(domain: "Failed to create CGImage", code: 0, userInfo: nil))
            return
        }
        let uiImage = UIImage(cgImage: cgImage)
        qrcodeCache.setImage(uiImage, forContent: item.url.absoluteString)

        image = .success(uiImage)
    }
}
