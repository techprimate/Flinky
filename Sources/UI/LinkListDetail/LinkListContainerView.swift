import SwiftUI

struct LinkListContainerView: View {
    @Environment(\.modelContext) private var modelContext

    let list: LinkListModel

    @State private var isCreateEditorPresented = false

    var body: some View {
        LinkListRenderView(
            list: listDisplayItem,
            links: linkDisplayItems,
            deleteItems: { offsets in },
            presentCreateEditor: {
                isCreateEditorPresented = true
            }
        ) { item in
            LinkDetailContainerView(item: list.links.first { $0.id == item.id }!)
        }
        .sheet(isPresented: $isCreateEditorPresented) {
            NavigationStack {
                CreateLinkEditorContainerView(list: list)
            }
        }
    }

    var listDisplayItem: LinkListDisplayItem {
        LinkListDisplayItem(title: list.name, icon: .folder, color: .gray, count: list.links.count)
    }

    var linkDisplayItems: [LinkListDetailDisplayItem] {
        list.links.map { link in
            LinkListDetailDisplayItem(id: link.id, title: link.title, url: link.url, icon: .star, color: .gray)
        }
    }
}
