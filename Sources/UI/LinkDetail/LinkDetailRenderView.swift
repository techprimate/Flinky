import CoreImage.CIFilterBuiltins
import Photos
import Sentry
import SFSafeSymbols
import SwiftUI

struct LinkDetailRenderView: View {
    @Environment(\.dismiss) private var dismiss

    let linkId: UUID

    let title: String
    let url: URL
    let color: ListColor
    let image: Result<UIImage, Error>?

    let editAction: () -> Void
    let openInSafariAction: () -> Void
    let copyURLAction: () -> Void

    let shareQRCodeImageAction: (_ image: UIImage) -> Void
    let saveQRCodeImageToPhotos: (_ image: UIImage) -> Void

    let isNFCSharingSupported: Bool
    let shareViaNFCAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topSectionView
            bottomSectionView
        }
        .background(Color(UIColor.systemGroupedBackground))
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Menu {
                    Button {
                        openInSafariAction()
                    } label: {
                        Label(L10n.LinkDetail.OpenInSafari.label, systemSymbol: .safari)
                            .tint(color.color)
                    }
                    Button {
                        openInSafariAction()
                    } label: {
                        Label(L10n.LinkDetail.EditLink.label, systemSymbol: .pencil)
                            .tint(color.color)
                    }
                } label: {
                    Label(L10n.LinkDetail.MoreMenu.label, systemSymbol: .ellipsisCircleFill)
                        .accessibilityLabel(L10n.LinkDetail.MoreMenu.Accessibility.label)
                        .accessibilityHint(L10n.LinkDetail.MoreMenu.Accessibility.hint)
                }
                .tint(.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Text(L10n.Shared.Button.Done.label)
                }
                .tint(.white)
                .fontWeight(.bold)
                .accessibilityLabel(L10n.Shared.Button.Done.Accessibility.label)
            }
        }
    }

    var topSectionView: some View {
        ZStack {
            VStack(spacing: 24) {
                imageView
                VStack {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    Button {
                        copyURLAction()
                    } label: {
                        Text(url.absoluteString)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundGradient.edgesIgnoringSafeArea(.top))
    }

    var bottomSectionView: some View {
        VStack(spacing: 12) {
            if isNFCSharingSupported {
                HStack {
                    Button {
                        shareViaNFCAction()
                    } label: {
                        Label(L10n.LinkDetail.ShareViaNfc.label, systemSymbol: .dotRadiowavesRight)
                            .padding(8)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .accentColor(.gray)
                    .accessibilityLabel(L10n.LinkDetail.ShareViaNfc.Accessibility.label(title))
                    .accessibilityHint(L10n.LinkDetail.ShareViaNfc.Accessibility.hint)
                }
                .frame(maxWidth: .infinity)
            }
            HStack {
                ShareLink(item: url, subject: Text(title)) {
                    Label(L10n.LinkDetail.ShareLink.label, systemSymbol: .squareAndArrowUp)
                        .padding(8)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .accentColor(.green)
                .accessibilityLabel(L10n.LinkDetail.ShareLink.Accessibility.label(url.absoluteString))
                .accessibilityHint(L10n.LinkDetail.ShareLink.Accessibility.hint)
                .simultaneousGesture(
                    // Use simultaneousGesture instead of onTapGesture to ensure tracking occurs
                    // without interfering with ShareLink's built-in tap handling
                    TapGesture().onEnded { _ in
                        // Track system share sheet usage for debugging user interaction patterns
                        let breadcrumb = Breadcrumb(level: .info, category: "link_sharing")
                        breadcrumb.message = "System share sheet opened"
                        breadcrumb.data = [
                            "link_id": linkId.uuidString,
                            "sharing_method": "system_share"
                        ]
                        SentrySDK.addBreadcrumb(breadcrumb)
                        
                        // Track sharing event for analytics - using detailed Event object
                        // to capture structured data for better analytics queries
                        let event = Event(level: .info)
                        event.message = SentryMessage(formatted: "link_shared")
                        event.extra = [
                            "link_id": linkId.uuidString,
                            "sharing_method": "system_share"
                        ]
                        SentrySDK.capture(event: event)
                    }
                )
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }

    var imageView: some View {
        VStack {
            if let image = image {
                switch image {
                case let .success(uiImage):
                    QRCodeImageView(
                        uiImage: uiImage,
                        url: url,
                        shareQRCodeImageAction: shareQRCodeImageAction,
                        saveQRCodeImageToPhotos: saveQRCodeImageToPhotos
                    )
                case let .failure(error):
                    Text(AppError.failedToGenerateQRCode(reason: error).localizedDescription)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .accessibilityLabel(L10n.Shared.QrCode.GenerationFailed.Accessibility.label)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .accessibilityLabel(L10n.Shared.QrCode.Generating.Accessibility.label)
            }
        }
        .frame(maxWidth: 200, maxHeight: 200)
        .padding()
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
        .shadow(radius: 12, x: 0, y: 6)
    }

    var backgroundGradient: some View {
        RadialGradient(colors: [
            color.color.mix(with: Color.white, by: 0.3),
            color.color
        ], center: .init(x: 0.25, y: 0.25), startRadius: 50, endRadius: 300)
    }
}

extension LinkDetailRenderView {
    struct QRCodeImageView: View {
        @Environment(\.colorScheme) var colorScheme

        let uiImage: UIImage
        let url: URL

        let shareQRCodeImageAction: (_ image: UIImage) -> Void
        let saveQRCodeImageToPhotos: (_ image: UIImage) -> Void

        var body: some View {
            image
                .aspectRatio(contentMode: .fit)
                .accessibilityLabel(L10n.Shared.QrCode.Accessibility.label(url.absoluteString))
                .accessibilityHint(L10n.Shared.QrCode.Accessibility.hint)
                .onTapGesture {
                    // Haptic feedback for tap
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()

                    shareQRCodeImageAction(uiImage)
                }
                .contextMenu {
                    Button {
                        // Haptic feedback for share action
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()

                        shareQRCodeImageAction(uiImage)
                    } label: {
                        Label(L10n.Shared.QrCode.ShareAsImage.label, systemSymbol: .squareAndArrowUp)
                    }
                    .accessibilityLabel(L10n.Shared.QrCode.ShareAsImage.Accessibility.label)
                    .accessibilityHint(L10n.Shared.QrCode.ShareAsImage.Accessibility.hint)

                    Button {
                        // Haptic feedback for save action
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()

                        saveQRCodeImageToPhotos(uiImage)
                    } label: {
                        Label(L10n.Shared.QrCode.SaveToPhotos.label, systemSymbol: .squareAndArrowDownOnSquare)
                    }
                    .accessibilityLabel(L10n.Shared.QrCode.SaveToPhotos.Accessibility.label)
                    .accessibilityHint(L10n.Shared.QrCode.SaveToPhotos.Accessibility.hint)
                }
        }

        @ViewBuilder private var image: some View {
            if colorScheme == .light {
                Image(uiImage: uiImage)
                    .resizable()
                    .interpolation(.none)
            } else {
                Image(uiImage: uiImage)
                    .resizable()
                    .interpolation(.none)
                    .colorInvert() // Invert colors for dark mode
            }
        }
    }
}

#Preview("QRCode Loaded") {
    Color.gray.sheet(isPresented: .constant(true)) {
        NavigationStack {
            LinkDetailRenderView(
                linkId: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                title: "Sample Link",
                url: URL(string: "https://example.com")!,
                color: .blue,
                image: .success(UIImage(data: Data(base64Encoded: "/9j/4AAQSkZJRgABAQAASABIAAD/4QCARXhpZgAATU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAABIAAAAAQAAAEgAAAABAAKgAgAEAAAAAQAAABugAwAEAAAAAQAAABsAAAAA/+0AOFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAAOEJJTQQlAAAAAAAQ1B2M2Y8AsgTpgAmY7PhCfv/AABEIABsAGwMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2wBDABsbGxsbGy8bGy9CLy8vQllCQkJCWXBZWVlZWXCIcHBwcHBwiIiIiIiIiIijo6Ojo6O+vr6+vtXV1dXV1dXV1dX/2wBDASEjIzYyNl0yMl3fl3yX39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39//3QAEAAL/2gAMAwEAAhEDEQA/AEnncPIBJgDzcnzSGDAttAXcPQdqtTzyyLI28oyFtmDgYViMnBOeAcgjnHA4NV5Gu5blwCwjRnO4F1XC9s5x1znOOmAwGMWGkmaTyUZW37nUDABBY9VON2VzyDjv/tUAV7iaVQNj5bC8PJt6s+7oU7gDpkDsK2rJg1vkNuG5wCTngMcc9+Kx1mZpI/PO0uMhUYgMWYfdAI9+SeSc8qM1sWMrz2qSuck554554PBOD6j1oA//0HTXJSR41wGIkYYDdFZifmDgjJXnApfvtJFbnEm9kAZ1b5O4CHtx0wO3OK2GsrdgwO7DZJAdgOevGcc1J5EW4sRuzuHzEnhsZHPbjpQBzAWOFRdJE6YOTJjA2uGx0OOQQOAMHuK6SzcyW4dgASWzgFRkE54PPX1qN9Ps5JPNZPmzu4Yjn14PXirUcaRJsTpyeST1OTyaAP/Z")!)!),
                editAction: {},
                openInSafariAction: {},
                copyURLAction: {},
                shareQRCodeImageAction: { _ in },
                saveQRCodeImageToPhotos: { _ in },
                isNFCSharingSupported: true,
                shareViaNFCAction: {}
            )
        }
    }
    .modelContainer(for: LinkModel.self, inMemory: true)
}

#Preview("QRCode Loading") {
    Color.gray.sheet(isPresented: .constant(true)) {
        NavigationStack {
            LinkDetailRenderView(
                linkId: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                title: "Sample Link",
                url: URL(string: "https://example.com")!,
                color: .blue,
                image: nil,
                editAction: {},
                openInSafariAction: {},
                copyURLAction: {},
                shareQRCodeImageAction: { _ in },
                saveQRCodeImageToPhotos: { _ in },
                isNFCSharingSupported: true,
                shareViaNFCAction: {}
            )
        }
    }
    .modelContainer(for: LinkModel.self, inMemory: true)
}

#Preview("QRCode Failed") {
    Color.gray.sheet(isPresented: .constant(true)) {
        NavigationStack {
            LinkDetailRenderView(
                linkId: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                title: "Sample Link",
                url: URL(string: "https://example.com")!,
                color: .blue,
                image: .failure(NSError(domain: "QR Code generation failed", code: 0, userInfo: nil)),
                editAction: {},
                openInSafariAction: {},
                copyURLAction: {},
                shareQRCodeImageAction: { _ in },
                saveQRCodeImageToPhotos: { _ in },
                isNFCSharingSupported: true,
                shareViaNFCAction: {}
            )
        }
    }
    .modelContainer(for: LinkModel.self, inMemory: true)
}

#Preview("NFC not available") {
    Color.gray.sheet(isPresented: .constant(true)) {
        NavigationStack {
            LinkDetailRenderView(
                linkId: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                title: "Sample Link",
                url: URL(string: "https://example.com")!,
                color: .blue,
                image: .success(UIImage(data: Data(base64Encoded: "/9j/4AAQSkZJRgABAQAASABIAAD/4QCARXhpZgAATU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAABIAAAAAQAAAEgAAAABAAKgAgAEAAAAAQAAABugAwAEAAAAAQAAABsAAAAA/+0AOFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAAOEJJTQQlAAAAAAAQ1B2M2Y8AsgTpgAmY7PhCfv/AABEIABsAGwMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2wBDABsbGxsbGy8bGy9CLy8vQllCQkJCWXBZWVlZWXCIcHBwcHBwiIiIiIiIiIijo6Ojo6O+vr6+vtXV1dXV1dXV1dX/2wBDASEjIzYyNl0yMl3fl3yX39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39/f39//3QAEAAL/2gAMAwEAAhEDEQA/AEnncPIBJgDzcnzSGDAttAXcPQdqtTzyyLI28oyFtmDgYViMnBOeAcgjnHA4NV5Gu5blwCwjRnO4F1XC9s5x1znOOmAwGMWGkmaTyUZW37nUDABBY9VON2VzyDjv/tUAV7iaVQNj5bC8PJt6s+7oU7gDpkDsK2rJg1vkNuG5wCTngMcc9+Kx1mZpI/PO0uMhUYgMWYfdAI9+SeSc8qM1sWMrz2qSuck554554PBOD6j1oA//0HTXJSR41wGIkYYDdFZifmDgjJXnApfvtJFbnEm9kAZ1b5O4CHtx0wO3OK2GsrdgwO7DZJAdgOevGcc1J5EW4sRuzuHzEnhsZHPbjpQBzAWOFRdJE6YOTJjA2uGx0OOQQOAMHuK6SzcyW4dgASWzgFRkE54PPX1qN9Ps5JPNZPmzu4Yjn14PXirUcaRJsTpyeST1OTyaAP/Z")!)!),
                editAction: {},
                openInSafariAction: {},
                copyURLAction: {},
                shareQRCodeImageAction: { _ in },
                saveQRCodeImageToPhotos: { _ in },
                isNFCSharingSupported: false,
                shareViaNFCAction: {}
            )
        }
    }
    .modelContainer(for: LinkModel.self, inMemory: true)
}
