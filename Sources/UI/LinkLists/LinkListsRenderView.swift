import SFSafeSymbols
import SwiftUI

struct LinkListsRenderView<Destination: View>: View {
    let pinnedLists: [LinkListDisplayItem]
    let unpinnedLists: [LinkListDisplayItem]

    let presentCreateList: () -> Void
    let pinListAction: (LinkListDisplayItem) -> Void
    let unpinListAction: (LinkListDisplayItem) -> Void
    let deleteUnpinnedListAction: (LinkListDisplayItem) -> Void
    let deleteUnpinnedListsAction: (_ offsets: IndexSet) -> Void
    let editListAction: (LinkListDisplayItem) -> Void

    let destination: (LinkListDisplayItem) -> Destination

    var body: some View {
        VStack(spacing: 0) {
            PinnedLinkListsRenderView(
                items: pinnedLists,
                editAction: { item in
                    editListAction(item)
                },
                unpinAction: { item in
                    unpinListAction(item)
                },
                deleteAction: { item in
                    deleteUnpinnedListAction(item)
                },
                destination: destination
            )
            List {
                Section(!unpinnedLists.isEmpty ? "My Lists" : "") {
                    ForEach(unpinnedLists, id: \.self) { list in
                        itemForList(list)
                    }
                    .onDelete(perform: deleteUnpinnedListsAction)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Flinky")
        .overlay {
            if pinnedLists.isEmpty && unpinnedLists.isEmpty {
                ContentUnavailableView(
                    "No lists available",
                    systemSymbol: .trayFill,
                    description: Text("Crteate a new list to get started")
                )
            }
        }
        .toolbar {
            if !pinnedLists.isEmpty || !unpinnedLists.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    presentCreateList()
                }, label: {
                    Label("New List", systemSymbol: .plusCircleFill)
                        .bold()
                        .imageScale(.large)
                        .labelStyle(.titleAndIcon)
                })
                .buttonStyle(.borderless)
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
        }
    }

    func itemForList(_ list: LinkListDisplayItem) -> some View {
        NavigationLink(destination: destination(list)) {
            LinkListItemView(
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
                .init(id: UUID(), title: "All", symbol: .archiveBox, color: .yellow, count: 5),
                .init(id: UUID(), title: "Favorites", symbol: .star, color: .yellow, count: 5),
                .init(id: UUID(), title: "WeAreDevelopers", symbol: .curlyBraces, color: .yellow, count: 5)
            ],
            unpinnedLists: [
                .init(id: UUID(), title: "Personal", symbol: .house, color: .red, count: 4),
                .init(id: UUID(), title: "Work", symbol: .suitcase, color: .blue, count: 4),
                .init(id: UUID(), title: "Golf Club", symbol: .emoji("⛳️"), color: .green, count: 4)
            ],
            presentCreateList: {},
            pinListAction: { _ in },
            unpinListAction: { _ in },
            deleteUnpinnedListAction: { _ in },
            deleteUnpinnedListsAction: { _ in },
            editListAction: { _ in }
        ) { list in
            Text(list.title)
        }
    }
}
