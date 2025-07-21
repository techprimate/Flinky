import SwiftUI

struct LinkListContainerView: View {
    @Environment(\.modelContext) private var modelContext

    let list: LinkListModel

    @State private var isCreateEditorPresented = false
    @State private var selectedLink: LinkModel?
    @State private var editingLink: LinkModel?

    var body: some View {
        LinkListRenderView(
            list: listDisplayItem,
            links: linkDisplayItems,
            editItem: { item in
                editingLink = list.links.first(where: { $0.id == item.id })
            },
            deleteItem: { item in
                print("Delete link: \(item.id)")
                guard let model = list.links.first(where: { $0.id == item.id }) else {
                    print("Delete link failed: not found")
                    return
                }
                modelContext.delete(model)
                do {
                    try modelContext.save()
                } catch {
                    print("Delete link failed: \(error)")
                }
            },
            deleteItems: { offsets in
                let models = offsets.map { links[$0] }
                for model in models {
                    modelContext.delete(model)
                }
                do {
                    try modelContext.save()
                } catch {
                    print("Delete links failed: \(error)")
                }
            },
            presentCreateEditor: {
                isCreateEditorPresented = true
            },
            presentLinkDetail: { linkDisplayItem in
                selectedLink = list.links.first { $0.id == linkDisplayItem.id }
            }
        )
        .sheet(isPresented: $isCreateEditorPresented) {
            NavigationStack {
                CreateLinkEditorContainerView(list: list)
            }
        }
        .sheet(item: $selectedLink) { link in
            NavigationStack {
                LinkDetailContainerView(item: link)
            }
        }
        .sheet(item: $editingLink) { link in
            NavigationStack {
                LinkInfoContainerView(link: link)
            }
        }
    }

    var listDisplayItem: LinkListDisplayItem {
        LinkListDisplayItem(id: list.id, title: list.name, symbol: .archiveBox, color: .gray, count: list.links.count)
    }

    var linkDisplayItems: [LinkListDetailDisplayItem] {
        links.map { link in
            LinkListDetailDisplayItem(
                id: link.id,
                title: link.name,
                url: link.url,
                symbol: link.symbol ?? .default,
                color: link.color ?? .default
            )
        }
    }

    var links: [LinkModel] {
        list.links
    }
}
