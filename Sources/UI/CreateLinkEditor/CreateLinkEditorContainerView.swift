import SwiftUI

struct CreateLinkEditorContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let list: LinkListModel

    var body: some View {
        CreateLinkEditorRenderView { data in
            let newItem = LinkModel(
                id: UUID(),
                createdAt: Date(),
                updatedAt: Date(),
                title: data.title,
                url: data.url
            )
            modelContext.insert(newItem)
            list.links.append(newItem)
            dismiss()
        }
    }
}
