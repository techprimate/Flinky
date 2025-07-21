import SwiftUI
import SFSafeSymbols

struct PinnedLinkListsRenderView<T: View>: View {
    let items: [LinkListDisplayItem]

    let editAction: (_ item: LinkListDisplayItem) -> Void
    let unpinAction: (_ item: LinkListDisplayItem) -> Void
    let deleteAction: (_ item: LinkListDisplayItem) -> Void

    let destination: (LinkListDisplayItem) -> T

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 8) {
            ForEach(items) { item in
                NavigationLink {
                    destination(item)
                } label: {
                    PinnedLinkListCardView(item: item)
                        .contextMenu {
                            Button {
                                editAction(item)
                            } label: {
                                Label("Edit List", systemSymbol: .pencil)
                            }
                            Button {
                                unpinAction(item)
                            } label: {
                                Label("Unpin List", systemSymbol: .pinSlashFill)
                            }
                            Button(role: .destructive) {
                                deleteAction(item)
                            } label: {
                                Label("Delete List", systemSymbol: .trash)
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        PinnedLinkListsRenderView(
            items: [
                .init(id: UUID(), title: "All", symbol: .backpack, color: .green, count: 5),
                .init(id: UUID(), title: "Favorites", symbol: .star, color: .yellow, count: 15),
                .init(id: UUID(), title: "WeAreDevelopers", symbol: .curlyBraces, color: .red, count: 2),
            ],
            editAction: { _ in },
            unpinAction: { _ in },
            deleteAction: { _ in },
        ) { list in
            Text(list.title)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
