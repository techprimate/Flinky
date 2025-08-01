import SFSafeSymbols
import SwiftUI

struct LinkListsRenderView<Destination: View>: View {
    let pinnedLists: [LinkListsDisplayItem]
    let unpinnedLists: [LinkListsDisplayItem]

    @Binding var searchText: String

    let presentCreateList: () -> Void
    let presentCreateLink: () -> Void

    let pinListAction: (LinkListsDisplayItem) -> Void
    let unpinListAction: (LinkListsDisplayItem) -> Void
    let deleteUnpinnedListAction: (LinkListsDisplayItem) -> Void
    let deleteUnpinnedListsAction: (_ offsets: IndexSet) -> Void
    let editListAction: (LinkListsDisplayItem) -> Void

    @ViewBuilder let destination: (LinkListsDisplayItem) -> Destination

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
                .accessibilityIdentifier("link-lists.pinned-section.container")
            }
            List {
                Section {
                    ForEach(unpinnedLists, id: \.self) { list in
                        itemViewForList(list)
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
            .accessibilityIdentifier("link-lists.unpinned-section.container")
        }
        .background(Color(UIColor.systemGroupedBackground))
        .headerProminence(.increased)
        .navigationTitle(L10n.App.title)
        .searchable(text: $searchText, prompt: L10n.Search.listsAndLinks)
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
                Button(
                    action: {
                        presentCreateLink()
                    },
                    label: {
                        Label(L10n.LinkLists.CreateLink.title, systemSymbol: .plusCircleFill)
                            .bold()
                            .imageScale(.large)
                            .labelStyle(.titleAndIcon)
                    }
                )
                .buttonStyle(.borderless)
                .accessibilityLabel(L10n.LinkLists.CreateLink.Accessibility.label)
                .accessibilityHint(L10n.LinkLists.CreateLink.Accessibility.hint)
                .accessibilityIdentifier("link-lists.create-link.button")
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            ToolbarItem(placement: .bottomBar) {
                Button(
                    action: {
                        presentCreateList()
                    },
                    label: {
                        Label(L10n.LinkLists.CreateList.title, systemSymbol: .plusCircleFill)
                            .imageScale(.large)
                            .labelStyle(.titleOnly)
                    }
                )
                .buttonStyle(.borderless)
                .accessibilityLabel(L10n.LinkLists.CreateList.Accessibility.label)
                .accessibilityHint(L10n.LinkLists.CreateList.Accessibility.hint)
                .accessibilityIdentifier("link-lists.create-list.button")
            }
        }
    }

    func itemViewForList(_ list: LinkListsDisplayItem) -> some View {
        NavigationLink(destination: destination(list)) {
            LinkListsItemView(
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
                .init(id: UUID(), name: "All", symbol: .object(.archiveBox), color: .yellow, count: 5),
                .init(id: UUID(), name: "Favorites", symbol: .communication(.star), color: .yellow, count: 5),
                .init(id: UUID(), name: "WeAreDevelopers", symbol: .communication(.link), color: .yellow, count: 5)
            ],
            unpinnedLists: [
                .init(id: UUID(), name: "Personal", symbol: .placesBuildings(.house), color: .red, count: 4),
                .init(id: UUID(), name: "Work", symbol: .object(.suitcase), color: .blue, count: 4),
                .init(id: UUID(), name: "Golf Club", symbol: .emoji("⛳️"), color: .green, count: 4)
            ],
            searchText: .constant(""),
            presentCreateList: {},
            presentCreateLink: {},
            pinListAction: { _ in },
            unpinListAction: { _ in },
            deleteUnpinnedListAction: { _ in },
            deleteUnpinnedListsAction: { _ in },
            editListAction: { _ in }
        ) { list in
            Text(list.name)
        }
    }
}
