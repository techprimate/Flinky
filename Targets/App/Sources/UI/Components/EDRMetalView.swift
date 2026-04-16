import CoreImage
import Metal
import MetalKit
import SwiftUI

struct EDRMetalView: UIViewRepresentable {
    let imageProvider: (_ contentScaleFactor: CGFloat, _ headroom: CGFloat) -> CIImage?

    func makeUIView(context: Context) -> MTKView {
        guard let renderer = context.coordinator.renderer else {
            return MTKView()
        }

        let view = MTKView(frame: .zero, device: renderer.device)
        view.preferredFramesPerSecond = 10
        view.framebufferOnly = false
        view.delegate = renderer

        if let layer = view.layer as? CAMetalLayer {
            layer.wantsExtendedDynamicRangeContent = true
            layer.colorspace = CGColorSpace(name: CGColorSpace.extendedLinearDisplayP3)
            view.colorPixelFormat = .rgba16Float
        }

        return view
    }

    func updateUIView(_ view: MTKView, context: Context) {
        guard let renderer = context.coordinator.renderer else { return }
        renderer.imageProvider = imageProvider
        view.delegate = renderer
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(imageProvider: imageProvider)
    }
}

extension EDRMetalView {
    final class Coordinator {
        let renderer: Renderer?

        init(imageProvider: @escaping (_ contentScaleFactor: CGFloat, _ headroom: CGFloat) -> CIImage?) {
            self.renderer = Renderer(imageProvider: imageProvider)
        }
    }

    final class Renderer: NSObject, MTKViewDelegate {
        let device: MTLDevice
        let commandQueue: MTLCommandQueue
        let renderContext: CIContext
        private let renderQueue = DispatchSemaphore(value: 3)

        var imageProvider: (_ contentScaleFactor: CGFloat, _ headroom: CGFloat) -> CIImage?

        init?(imageProvider: @escaping (_ contentScaleFactor: CGFloat, _ headroom: CGFloat) -> CIImage?) {
            guard let device = MTLCreateSystemDefaultDevice(),
                  let commandQueue = device.makeCommandQueue()
            else {
                return nil
            }
            self.device = device
            self.commandQueue = commandQueue
            self.renderContext = CIContext(
                mtlCommandQueue: commandQueue,
                options: [
                    .cacheIntermediates: true,
                    .allowLowPower: true
                ]
            )
            self.imageProvider = imageProvider
            super.init()
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

        func draw(in view: MTKView) {
            _ = renderQueue.wait(timeout: .distantFuture)

            guard let commandBuffer = commandQueue.makeCommandBuffer() else {
                renderQueue.signal()
                return
            }
            commandBuffer.addCompletedHandler { [weak self] _ in
                self?.renderQueue.signal()
            }

            guard let drawable = view.currentDrawable else { return }

            let drawSize = view.drawableSize
            let contentScaleFactor = view.contentScaleFactor
            let headroom = view.window?.screen.currentEDRHeadroom ?? 1.0

            guard var image = imageProvider(contentScaleFactor, headroom) else { return }

            let destination = CIRenderDestination(
                width: Int(drawSize.width),
                height: Int(drawSize.height),
                pixelFormat: view.colorPixelFormat,
                commandBuffer: commandBuffer,
                mtlTextureProvider: { drawable.texture }
            )

            let iRect = image.extent
            let backBounds = CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height)
            let shiftX = round((backBounds.width + iRect.origin.x - iRect.width) * 0.5)
            let shiftY = round((backBounds.height + iRect.origin.y - iRect.height) * 0.5)
            image = image.transformed(by: CGAffineTransform(translationX: shiftX, y: shiftY))

            _ = try? renderContext.startTask(
                toRender: image,
                from: backBounds,
                to: destination,
                at: .zero
            )

            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}
