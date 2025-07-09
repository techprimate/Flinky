import SwiftUI

struct CreateListEditorContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        CreateListEditorRenderView { data in
            let newItem = LinkListModel(
                id: UUID(),
                createdAt: Date(),
                updatedAt: Date(),
                name: data.name,
                links: [],
                isPinned: false
            )
            modelContext.insert(newItem)
            dismiss()
        }
    }
}
