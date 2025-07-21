import CoreImage.CIFilterBuiltins
import SFSafeSymbols
import SwiftUI

struct LinkDetailRenderView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let url: URL
    let image: Result<UIImage, Error>?

    let editAction: () -> Void

    var body: some View {
        VStack {
            Spacer()
            VStack {
                imageView
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(url.absoluteString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            HStack {
                ShareLink(item: url) {
                    Label("Share Link", systemSymbol: .squareAndArrowUp)
                        .padding(8)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .accentColor(.green)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    editAction()
                }) {
                    Label("Edit", systemSymbol: .ellipsisCircle)
                }
            }
        }
    }

    var imageView: some View {
        Group {
            if let image = image {
                switch image {
                case let .success(uiImage):
                    Image(uiImage: uiImage)
                        .resizable()
                        .interpolation(.none)
                        .aspectRatio(contentMode: .fit)
                case let .failure(error):
                    Text("Error creating QRCode: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .frame(maxWidth: 200, maxHeight: 200)
        .padding()
    }
}

#Preview("QRCode Loaded") {
    Color.gray.sheet(isPresented: .constant(true)) {
        NavigationStack {
            LinkDetailRenderView(
                title: "Sample Link",
                url: URL(string: "https://example.com")!,
                image: .success(UIImage(systemName: "qrcode")!), // Placeholder image
                editAction: {}
            )
        }
    }
    .modelContainer(for: LinkModel.self, inMemory: true)
}

#Preview("QRCode Loading") {
    Color.gray.sheet(isPresented: .constant(true)) {
        NavigationStack {
            LinkDetailRenderView(
                title: "Sample Link",
                url: URL(string: "https://example.com")!,
                image: nil,
                editAction: {}
            )
        }
    }
    .modelContainer(for: LinkModel.self, inMemory: true)
}

#Preview("QRCode Failed") {
    Color.gray.sheet(isPresented: .constant(true)) {
        NavigationStack {
            LinkDetailRenderView(
                title: "Sample Link",
                url: URL(string: "https://example.com")!,
                image: .failure(NSError(domain: "QR Code generation failed", code: 0, userInfo: nil)),
                editAction: {}
            )
        }
    }
    .modelContainer(for: LinkModel.self, inMemory: true)
}
