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
                color: nil,
                symbol: nil,
                url: data.url
            )
            modelContext.insert(newItem)
            list.links.append(newItem)
            
            // Save the context to persist the new link
            do {
                try modelContext.save()
            } catch {
                print("Failed to save new link: \(error)")
            }
            
            dismiss()
        }
    }
}
