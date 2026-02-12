import FlinkyCore
import SentrySwift
import SwiftData
import SwiftUI

struct MainContainerView: View {
    var body: some View {
        NavigationStack {
            LinkListsContainerView()
        }
        .sentryTrace("MAIN_VIEW")
    }
}

#Preview {
    MainContainerView()
        .modelContainer(for: LinkModel.self, inMemory: true)
        .modelContainer(for: LinkListModel.self, inMemory: true)
}
