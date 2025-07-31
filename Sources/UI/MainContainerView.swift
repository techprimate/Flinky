import SentrySwiftUI
import SwiftData
import SwiftUI

struct MainContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var firstLaunchMyLinksId: UUID?
    @State private var isCheckingFirstLaunch = true

    var body: some View {
        NavigationStack {
            if isCheckingFirstLaunch {
                // Show loading while checking first launch
                ProgressView("Setting up your links...")
                    .onAppear {
                        checkFirstLaunchAndSeedData()
                    }
            } else if let myLinksId = firstLaunchMyLinksId {
                // First launch - navigate directly to "My Links" list
                if let myLinksList = findLinkList(by: myLinksId) {
                    LinkListDetailContainerView(list: myLinksList)
                } else {
                    // Fallback to normal lists view if list not found
                    LinkListsContainerView()
                }
            } else {
                // Normal app launch - show all lists
                LinkListsContainerView()
            }
        }
        .sentryTrace("MAIN_VIEW")
    }

    private func checkFirstLaunchAndSeedData() {
        // Perform first launch check and seeding on background queue
        DispatchQueue.global(qos: .userInitiated).async {
            let myLinksId = DataSeedingService.seedDataIfFirstLaunch(modelContext: modelContext)

            // Return to main queue for UI updates
            DispatchQueue.main.async {
                self.firstLaunchMyLinksId = myLinksId
                self.isCheckingFirstLaunch = false
            }
        }
    }

    private func findLinkList(by id: UUID) -> LinkListModel? {
        let descriptor = FetchDescriptor<LinkListModel>(
            predicate: #Predicate { list in list.id == id }
        )
        return try? modelContext.fetch(descriptor).first
    }
}

#Preview {
    MainContainerView()
        .modelContainer(for: LinkModel.self, inMemory: true)
        .modelContainer(for: LinkListModel.self, inMemory: true)
}
