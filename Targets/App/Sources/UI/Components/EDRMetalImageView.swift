import CoreImage.CIFilterBuiltins
import SwiftUI

struct EDRMetalImageView: View {
    @Environment(\.colorScheme) private var colorScheme

    let ciImage: CIImage
    let size: CGFloat
    var inset: CGFloat = 0

    var body: some View {
        EDRMetalView { contentScaleFactor, headroom in
            edrImage(scaleFactor: contentScaleFactor, headroom: headroom)
        }
    }

    private func edrImage(scaleFactor: CGFloat, headroom: CGFloat) -> CIImage? {
        let totalSize = size * scaleFactor
        let qrSize = (size - 2 * inset) * scaleFactor
        let insetPx = inset * scaleFactor

        let cropRect = CGRect(x: 0, y: 0, width: totalSize, height: totalSize)

        let scale = CGAffineTransform(
            scaleX: qrSize / ciImage.extent.width,
            y: qrSize / ciImage.extent.height
        )
        let scaledQR = ciImage
            .transformed(by: scale)
            .transformed(by: CGAffineTransform(translationX: insetPx, y: insetPx))

        let mask = scaledQR.composited(over: CIImage.white.cropped(to: cropRect))

        guard let colorSpace = CGColorSpace(name: CGColorSpace.extendedLinearSRGB) else {
            return nil
        }

        let foregroundBrightness: CGFloat
        let backgroundBrightness: CGFloat
        if colorScheme == .light {
            foregroundBrightness = headroom
            backgroundBrightness = 0
        } else {
            foregroundBrightness = 0
            backgroundBrightness = headroom
        }

        guard let foregroundColor = CIColor(
            red: foregroundBrightness, green: foregroundBrightness, blue: foregroundBrightness,
            colorSpace: colorSpace
        ),
            let backgroundColor = CIColor(
                red: backgroundBrightness, green: backgroundBrightness, blue: backgroundBrightness,
                colorSpace: colorSpace
            )
        else {
            return nil
        }

        let foreground = CIImage(color: foregroundColor)
        let background = CIImage(color: backgroundColor)

        let maskFilter = CIFilter.blendWithMask()
        maskFilter.inputImage = foreground
        maskFilter.backgroundImage = background
        maskFilter.maskImage = mask

        return maskFilter.outputImage?.cropped(to: cropRect)
    }
}
