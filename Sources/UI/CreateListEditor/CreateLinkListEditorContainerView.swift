import SwiftUI

struct CreateLinkListEditorContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        CreateLinkListEditorRenderView { data in
            let newItem = LinkListModel(
                id: UUID(),
                createdAt: Date(),
                updatedAt: Date(),
                name: data.name,
                color: nil,
                symbol: nil,
                links: [],
                isPinned: false
            )
            modelContext.insert(newItem)
            
            do {
                try modelContext.save()
            } catch {
                print("Failed to save new list: \(error)")
            }
            
            dismiss()
        }
    }
}
