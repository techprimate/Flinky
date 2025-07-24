import SFSafeSymbols
import SwiftUI

struct PinnedLinkListsRenderView<T: View>: View {
    let items: [LinkListDisplayItem]

    let editAction: (_ item: LinkListDisplayItem) -> Void
    let unpinAction: (_ item: LinkListDisplayItem) -> Void
    let deleteAction: (_ item: LinkListDisplayItem) -> Void

    let destination: (LinkListDisplayItem) -> T

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            ForEach(items) { item in
                NavigationLink {
                    destination(item)
                } label: {
                    PinnedLinkListCardView(item: item)
                }
                .contextMenu {
                    Button {
                        editAction(item)
                    } label: {
                        Label(L10n.Shared.Action.edit, systemSymbol: .pencil)
                    }
                    Button {
                        unpinAction(item)
                    } label: {
                        Label(L10n.Shared.Action.unpin, systemSymbol: .pinSlashFill)
                    }
                    Button(role: .destructive) {
                        deleteAction(item)
                    } label: {
                        Label(L10n.Shared.Action.delete, systemSymbol: .trash)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PinnedLinkListsRenderView(
            items: [
                .init(id: UUID(), title: "All", symbol: .documentsReadingWriting(.backpack), color: .green, count: 5),
                .init(
                    id: UUID(),
                    title: "Favorites",
                    symbol: .communication(.star),
                    color: .yellow,
                    count: 15
                ),
                .init(id: UUID(), title: "WeAreDevelopers", symbol: .communication(.link), color: .red, count: 2)
            ],
            editAction: { _ in
 },
            unpinAction: { _ in },
            deleteAction: { _ in }
        ) { list in
            Text(list.title)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
