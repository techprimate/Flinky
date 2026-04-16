import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    enum Item {
        case image(UIImage)

        var value: Any {
            switch self {
            case .image(let image): image
            }
        }
    }

    let activityItems: [Item]

    func makeUIViewController(context _: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems.map(\.value), applicationActivities: nil)
    }

    func updateUIViewController(_: UIActivityViewController, context _: Context) {
        // No updates needed
    }
}
