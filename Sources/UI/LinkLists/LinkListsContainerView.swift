import SwiftUI
import SwiftData

struct LinkListsContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate { (list: LinkListModel) in list.isPinned == true },
        sort: \.name
    )
    private var pinnedLists: [LinkListModel]
    @Query(
        filter: #Predicate { (list: LinkListModel) in list.isPinned == false },
        sort: \.name
    )
    private var unpinnedLists: [LinkListModel]

    @State private var isCreateListPresented = false

    var body: some View {
        LinkListsRenderView(
            pinnedLists: pinnedListDisplayItems,
            lists: listDisplayItems,
            presentCreateList: {
                isCreateListPresented = true
            },
            pinListAction: { list in
                if let index = unpinnedLists.firstIndex(where: { $0.name == list.title }) {
                    unpinnedLists[index].isPinned = true
                }
            },
            unpinListAction: { list in
                if let index = pinnedLists.firstIndex(where: { $0.name == list.title }) {
                    pinnedLists[index].isPinned = false
                }
            }
        ) { listDisplayItem in
            LinkListContainerView(list: (pinnedLists + unpinnedLists).first { $0.name == listDisplayItem.title }!)
        }
        .sheet(isPresented: $isCreateListPresented) {
            NavigationStack {
                CreateListEditorContainerView()
            }
        }
    }

    var pinnedListDisplayItems: [LinkListDisplayItem] {
        pinnedLists.map { LinkListDisplayItem(title: $0.name, icon: .folder, color: .gray, count: $0.links.count) }
    }

    var listDisplayItems: [LinkListDisplayItem] {
        unpinnedLists.map { LinkListDisplayItem(title: $0.name, icon: .folder, color: .gray, count: $0.links.count) }
    }
}
