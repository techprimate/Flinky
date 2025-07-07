import SwiftUI

struct MainListItemRenderView: View {
    let item: LinkModel

    let editAction: () -> Void
    let deleteAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            Text(item.url.absoluteString)
                .lineLimit(1)
                .foregroundColor(.secondary)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                editAction()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
}

#Preview {
    let items: [LinkModel] = [
        LinkModel(title: "Example Link", url: URL(string: "https://example.com")!),
        LinkModel(title: "Another Link", url: URL(string: "https://another-example.com")!)
    ]
    List {
        ForEach(items) { item in
            MainListItemRenderView(item: item, editAction: {}, deleteAction: {})
        }
    }
}
