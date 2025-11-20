import SFSafeSymbols
import SwiftUI

struct PinnedLinkListsRenderView<T: View>: View {
    let items: [LinkListsDisplayItem]

    let editAction: (_ item: LinkListsDisplayItem) -> Void
    let unpinAction: (_ item: LinkListsDisplayItem) -> Void
    let deleteAction: (_ item: LinkListsDisplayItem) -> Void

    let destination: (_ item: LinkListsDisplayItem) -> T

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(items) { item in
                itemViewForList(item)
            }
        }
    }

    private func itemViewForList(_ item: LinkListsDisplayItem) -> some View {
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

#Preview {
    NavigationStack {
        PinnedLinkListsRenderView(
            items: [
                .init(id: UUID(), name: "All", symbol: .documentsReadingWriting(.backpack), color: .green, count: 5),
                .init(id: UUID(), name: "Favorites", symbol: .communication(.star), color: .yellow, count: 15),
                .init(id: UUID(), name: "WeAreDevelopers", symbol: .communication(.link), color: .red, count: 2)
            ],
            editAction: { _ in },
            unpinAction: { _ in },
            deleteAction: { _ in }
        ) { list in  // swiftlint:disable:this multiple_closures_with_trailing_closure
            Text(list.name)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
