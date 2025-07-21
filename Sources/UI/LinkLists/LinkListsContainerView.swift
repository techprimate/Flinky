import SFSafeSymbols
import SwiftData
import SwiftUI

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
    @State private var presentedInfoList: LinkListModel?

    var body: some View {
        LinkListsRenderView(
            pinnedLists: pinnedListDisplayItems,
            unpinnedLists: listDisplayItems,
            presentCreateList: {
                isCreateListPresented = true
            },
            pinListAction: { list in
                guard let model = unpinnedLists.first(where: { $0.id == list.id }) else {
                    print("List not found for pinning: \(list.title)")
                    return
                }
                model.isPinned = true

                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save pin change: \(error)")
                }
            },
            unpinListAction: { list in
                guard let model = pinnedLists.first(where: { $0.id == list.id }) else {
                    print("List not found for unpinning: \(list.title)")
                    return
                }
                model.isPinned = false

                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save unpin change: \(error)")
                }
            },
            deleteUnpinnedListAction: { list in
                guard let model = unpinnedLists.first(where: { $0.id == list.id }) else {
                    print("List not found for deletion: \(list.id)")
                    return
                }
                print("Deleting list: \(model.id)")
                modelContext.delete(model)

                do {
                    try modelContext.save()
                    print("Deleted list: \(model.id)")
                } catch {
                    print("Failed to delete list: \(error)")
                }
            },
            deleteUnpinnedListsAction: { offsets in
                // Map the indicies to the models first, as deleting models can cause indicies to be wrong
                let models = offsets.map { unpinnedLists[$0] }
                for model in models {
                    modelContext.delete(model)
                }
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save unpin change: \(error)")
                }
            },
            editListAction: { item in
                presentedInfoList = (pinnedLists + unpinnedLists).first { $0.id == item.id }
            }
        ) { listDisplayItem in
            LinkListContainerView(list: (pinnedLists + unpinnedLists).first { $0.id == listDisplayItem.id }!)
        }
        .sheet(isPresented: $isCreateListPresented) {
            NavigationStack {
                CreateLinkListEditorContainerView()
            }
        }
        .sheet(item: $presentedInfoList) { list in
            NavigationStack {
                LinkListInfoContainerView(list: list)
            }
        }
    }

    var pinnedListDisplayItems: [LinkListDisplayItem] {
        pinnedLists.map { list in
            mapToDisplayItem(list)
        }
    }

    var listDisplayItems: [LinkListDisplayItem] {
        unpinnedLists.map { list in
            mapToDisplayItem(list)
        }
    }

    func mapToDisplayItem(_ model: LinkListModel) -> LinkListDisplayItem {
        LinkListDisplayItem(
            id: model.id,
            title: model.name,
            symbol: model.symbol ?? .default,
            color: model.color ?? .default,
            count: model.links.count
        )
    }
}
