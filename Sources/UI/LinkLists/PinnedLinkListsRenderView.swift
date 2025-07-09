import SwiftUI

struct PinnedLinkListsRenderView<T: View>: View {
    let items: [LinkListDisplayItem]
    let unpinListAction: (LinkListDisplayItem) -> Void
    let destination: (LinkListDisplayItem) -> T

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 8) {
            ForEach(items) { item in
                NavigationLink {
                    destination(item)
                } label: {
                    PinnedLinkListCardView(item: item)
                        .contextMenu {
                            Button {
                                unpinListAction(item)
                            } label: {
                                Label("Unpin List", systemSymbol: .pinSlashFill)
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        PinnedLinkListsRenderView(items: [
            .init(title: "All", icon: .trayCircleFill, color: .black, count: 5),
            .init(title: "Favorites", icon: .starFill, color: .yellow, count: 15),
            .init(title: "WeAreDevelopers", icon: .network, color: .red, count: 2),
        ], unpinListAction: { _ in }) { list in
            Text(list.title)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
