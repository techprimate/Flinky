import SwiftUI
import SwiftData

struct MainContainerView: View {
    var body: some View {
        NavigationStack {
            LinkListsContainerView()
        }
    }
}

#Preview {
    MainContainerView()
        .modelContainer(for: LinkModel.self, inMemory: true)
        .modelContainer(for: LinkListModel.self, inMemory: true)
}
