import SFSafeSymbols
import SwiftUI

struct LinkListsRenderView<Destination: View>: View {
    let pinnedLists: [LinkListDisplayItem]
    let unpinnedLists: [LinkListDisplayItem]

    let presentCreateList: () -> Void
    let pinListAction: (LinkListDisplayItem) -> Void
    let unpinListAction: (LinkListDisplayItem) -> Void
    let deleteUnpinnedListAction: (LinkListDisplayItem) -> Void
    let deleteUnpinnedListsAction: (_ offsets: IndexSet) -> Void
    let editListAction: (LinkListDisplayItem) -> Void

    @ViewBuilder let destination: (LinkListDisplayItem) -> Destination

    var body: some View {
        VStack(spacing: 16) {
            if !pinnedLists.isEmpty {
                PinnedLinkListsRenderView(
                    items: pinnedLists,
                    editAction: { item in
                        editListAction(item)
                    },
                    unpinAction: { item in
                        unpinListAction(item)
                    },
                    deleteAction: { item in
                        deleteUnpinnedListAction(item)
                    },
                    destination: destination
                )
                .padding(.horizontal, 16)
            }
            List {
                Section {
                    ForEach(unpinnedLists, id: \.self) { list in
                        itemForList(list)
                    }
                    .onDelete(perform: deleteUnpinnedListsAction)
                } header: {
                    if !pinnedLists.isEmpty {
                        HStack {
                            Text(L10n.LinkLists.myListsSection)
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .headerProminence(.increased)
        .navigationTitle(L10n.App.title)
        .overlay {
            if pinnedLists.isEmpty && unpinnedLists.isEmpty {
                ContentUnavailableView(
                    L10n.LinkLists.noListsTitle,
                    systemSymbol: .trayFill,
                    description: Text(L10n.LinkLists.noListsDescription)
                )
            }
        }
        .toolbar {
            if !pinnedLists.isEmpty || !unpinnedLists.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    presentCreateList()
                }, label: {
                    Label(L10n.CreateList.title, systemSymbol: .plusCircleFill)
                        .bold()
                        .imageScale(.large)
                        .labelStyle(.titleAndIcon)
                })
                .buttonStyle(.borderless)
                .accessibilityLabel(L10n.Shared.Button.NewList.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.NewList.Accessibility.label)
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
        }
    }

    func itemForList(_ list: LinkListDisplayItem) -> some View {
        NavigationLink(destination: destination(list)) {
            LinkListItemView(
                item: list,
                editAction: { item in
                    editListAction(item)
                },
                pinAction: { item in
                    pinListAction(item)
                },
                deleteAction: { item in
                    deleteUnpinnedListAction(item)
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        LinkListsRenderView(
            pinnedLists: [
                .init(id: UUID(), title: "All", symbol: .object(.archiveBox), color: .yellow, count: 5),
                .init(id: UUID(), title: "Favorites", symbol: .communication(.star), color: .yellow, count: 5),
                .init(id: UUID(), title: "WeAreDevelopers", symbol: .communication(.link), color: .yellow, count: 5)
            ],
            unpinnedLists: [
                .init(id: UUID(), title: "Personal", symbol: .placesBuildings(.house), color: .red, count: 4),
                .init(id: UUID(), title: "Work", symbol: .object(.suitcase), color: .blue, count: 4),
                .init(id: UUID(), title: "Golf Club", symbol: .emoji("⛳️"), color: .green, count: 4)
            ],
            presentCreateList: {},
            pinListAction: { _ in },
            unpinListAction: { _ in },
            deleteUnpinnedListAction: { _ in },
            deleteUnpinnedListsAction: { _ in },
            editListAction: { _ in }
        ) { list in
            Text(list.title)
        }
    }
}
