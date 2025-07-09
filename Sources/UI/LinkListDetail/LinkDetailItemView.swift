import SwiftUI
import SFSafeSymbols

struct LinkDetailItemView: View {
    let item: LinkListDetailDisplayItem

    let editAction: () -> Void
    let deleteAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Label(item.title, systemSymbol: item.icon)
                .labelStyle(RoundedIconLabelStyle(color: item.color))
                .foregroundStyle(.primary)
            Text(item.url.absoluteString)
                .lineLimit(1)
                .foregroundColor(.secondary)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
            Button {
                editAction()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }

    }
}

#Preview {
    let items = [
        LinkListDetailDisplayItem(
            id: UUID(),
            title: "Example Link",
            url: URL(string: "https://example.com")!,
            icon: .link,
            color: .blue
        ),
        LinkListDetailDisplayItem(
            id: UUID(),
            title: "Another Link",
            url: URL(string: "https://another-example.com")!,
            icon: .figureGolf,
            color: .green
        )
    ]
    List {
        ForEach(items) { item in
            LinkDetailItemView(item: item, editAction: {}, deleteAction: {})
        }
    }
}
