import SFSafeSymbols
import SwiftUI

struct LinkListsRenderView<Destination: View>: View {
    let pinnedLists: [LinkListsDisplayItem]
    let unpinnedLists: [LinkListsDisplayItem]

    @Binding var searchText: String

    let presentCreateList: () -> Void
    let presentCreateLink: () -> Void

    let pinListAction: (LinkListsDisplayItem) -> Void
    let unpinListAction: (LinkListsDisplayItem) -> Void
    let deleteUnpinnedListAction: (LinkListsDisplayItem) -> Void
    let deleteUnpinnedListsAction: (_ offsets: IndexSet) -> Void
    let editListAction: (LinkListsDisplayItem) -> Void

    @ViewBuilder let destination: (LinkListsDisplayItem) -> Destination

    var body: some View {
        UIKitLinkListsRenderView(
            pinnedLists: pinnedLists,
            unpinnedLists: unpinnedLists,
            presentCreateList: presentCreateList,
            presentCreateLink: presentCreateLink,
            pinListAction: pinListAction,
            unpinListAction: unpinListAction,
            deleteUnpinnedListAction: deleteUnpinnedListAction,
            editListAction: editListAction,
            destination: destination
        )
    }

    // Keep the itemViewForList method for backwards compatibility in case it's used elsewhere
    func itemViewForList(_ list: LinkListsDisplayItem) -> some View {
        NavigationLink(destination: destination(list)) {
            LinkListsItemView(
                item: list,
                editAction: { item in
                    editListAction(item)
                },
                pinAction: { item in
                    pinListAction(item)
                },
                deleteAction: { item in
                    deleteUnpinnedListAction(item)
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        LinkListsRenderView(
            pinnedLists: [
                .init(id: UUID(), name: "All", symbol: .object(.archiveBox), color: .yellow, count: 5),
                .init(id: UUID(), name: "Favorites", symbol: .communication(.star), color: .yellow, count: 5),
                .init(id: UUID(), name: "WeAreDevelopers", symbol: .communication(.link), color: .yellow, count: 5)
            ],
            unpinnedLists: [
                .init(id: UUID(), name: "Personal", symbol: .placesBuildings(.house), color: .red, count: 4),
                .init(id: UUID(), name: "Work", symbol: .object(.suitcase), color: .blue, count: 4),
                .init(id: UUID(), name: "Golf Club", symbol: .emoji("⛳️"), color: .green, count: 4)
            ],
            searchText: .constant(""),
            presentCreateList: {},
            presentCreateLink: {},
            pinListAction: { _ in },
            unpinListAction: { _ in },
            deleteUnpinnedListAction: { _ in },
            deleteUnpinnedListsAction: { _ in },
            editListAction: { _ in }
        ) { list in
            Text(list.name)
        }
    }
}
