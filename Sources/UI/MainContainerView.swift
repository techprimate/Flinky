import SwiftUI
import SwiftData

struct MainContainerView: View {
    @State private var isCreateEditorPresented = false
    @State private var presentedDetailItem: LinkModel?

    var body: some View {
        NavigationStack {
            MainListContainerView(
                presentedDetailItem: $presentedDetailItem,
                isCreateEditorPresented: $isCreateEditorPresented
            )
        }
        .sheet(isPresented: $isCreateEditorPresented) {
            NavigationStack {
                CreateLinkEditorContainerView()
            }
        }
        .sheet(item: $presentedDetailItem) { item in
            NavigationStack {
                DetailContainerView(item: item)
            }
        }
    }
}




#Preview {
    MainContainerView()
        .modelContainer(for: LinkModel.self, inMemory: true)
}
