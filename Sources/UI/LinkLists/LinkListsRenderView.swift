import SwiftUI

struct LinkListsRenderView<Destination: View>: View {
    let pinnedLists: [LinkListDisplayItem]
    let lists: [LinkListDisplayItem]

    let presentCreateList: () -> Void
    let pinListAction: (LinkListDisplayItem) -> Void
    let unpinListAction: (LinkListDisplayItem) -> Void

    let destination: (LinkListDisplayItem) -> Destination

    var body: some View {
        VStack(spacing: 0) {
            PinnedLinkListsRenderView(
                items: pinnedLists,
                unpinListAction: { item in
                    unpinListAction(item)
                },
                destination: destination
            )
            List {
                Section("My Lists") {
                    ForEach(lists, id: \.self) { list in
                        itemForList(list)
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Flinky")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    presentCreateList()
                }, label: {
                    Label(
                        "New List",
                        systemImage: "plus.circle.fill"
                    )
                    .bold()
                    .imageScale(.large)
                    .labelStyle(.titleAndIcon)
                })
                .buttonStyle(.borderless)
            }
        }
    }

    func itemForList(_ list: LinkListDisplayItem) -> some View {
        NavigationLink(destination: destination(list)) {
            LinkListItemView(item: list)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        pinListAction(list)
                    } label: {
                        Label("Pin List", systemSymbol: .pinSlashFill)
                    }
                    .tint(.blue)
                }
                .contextMenu {
                    Button {
                        pinListAction(list)
                    } label: {
                        Label("Pin List", systemSymbol: .pinFill)
                    }
                }
        }
    }
}

#Preview {
    NavigationStack {
        LinkListsRenderView(
            pinnedLists: [
                .init(title: "All", icon: .tray, color: .yellow, count: 5),
                .init(title: "Favorites", icon: .starFill, color: .yellow, count: 5),
                .init(title: "WeAreDevelopers", icon: .network, color: .yellow, count: 5),
            ],
            lists: [
                .init(title: "Personal", icon: .house, color: .red, count: 4),
                .init(title: "Work", icon: .suitcase, color: .blue, count: 4),
                .init(title: "Golf Club", icon: .figureGolf, color: .green, count: 4),
            ],
            presentCreateList: {},
            pinListAction: { _ in },
            unpinListAction: { _ in }
        ) { list in
                Text(list.title)
            }
    }
}
