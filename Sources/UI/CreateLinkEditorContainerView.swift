import SwiftUI

struct CreateLinkEditorContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        CreateLinkEditorRenderView { data in
            let newItem = LinkModel(title: data.title, url: data.url)
            modelContext.insert(newItem)
            dismiss()
        }
    }
}

#Preview {
    CreateLinkEditorContainerView()
        .modelContainer(for: LinkModel.self, inMemory: true)
}
