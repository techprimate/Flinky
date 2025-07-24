import SFSafeSymbols
import SwiftUI

struct LinkListDetailRenderView: View {
    let list: LinkListsDisplayItem
    let links: [LinkListDetailDisplayItem]

    @Binding var searchText: String

    let editItem: (LinkListDetailDisplayItem) -> Void
    let deleteItem: (LinkListDetailDisplayItem) -> Void
    let deleteItems: (_ offsets: IndexSet) -> Void

    let presentCreateEditor: () -> Void
    let presentLinkDetail: (LinkListDetailDisplayItem) -> Void

    var body: some View {
        List {
            Section {
                ForEach(links) { link in
                    itemViewForLink(link)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .navigationTitle(list.name)
        .searchable(text: $searchText, prompt: L10n.Search.links)
        .overlay {
            if links.isEmpty {
                ContentUnavailableView(
                    L10n.LinkListDetail.noLinksTitle,
                    systemSymbol: .globe,
                    description: Text(L10n.LinkListDetail.noLinksDescription)
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    presentCreateEditor()
                } label: {
                    Label(L10n.LinkListDetail.newLink, systemSymbol: .plusCircleFill)
                        .bold()
                        .imageScale(.large)
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel(L10n.Shared.Button.NewLink.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.NewLink.Accessibility.label)
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
        }
    }

    private func itemViewForLink(_ link: LinkListDetailDisplayItem) -> some View {
        Button {
            presentLinkDetail(link)
        } label: {
            LinkListDetailItemView(
                item: link,
                editAction: {
                    editItem(link)
                },
                deleteAction: {
                    deleteItem(link)
                }
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationView {
        LinkListDetailRenderView(
            list: .init(
                id: UUID(),
                name: "Favorites",
                symbol: .communication(.star),
                color: .yellow,
                count: 4
            ),
            links: [
                .init(
                    id: UUID(),
                    title: "Apple",
                    url: URL(string: "https://apple.com")!,
                    symbol: .documentsReadingWriting(.backpack),
                    color: .green
                ),
                .init(
                    id: UUID(),
                    title: "SwiftUI",
                    url: URL(string: "https://developer.apple.com/swiftui/")!,
                    symbol: .sportRecreation(.americanFootball),
                    color: .blue
                ),
                .init(
                    id: UUID(),
                    title: "Flinky",
                    url: URL(string: "https://flinky.app")!,
                    symbol: .currency(.euro),
                    color: .blue
                )
            ],
            searchText: .constant(""),
            editItem: { _ in },
            deleteItem: { _ in },
            deleteItems: { _ in },
            presentCreateEditor: {},
            presentLinkDetail: { link in
                print("Presenting link detail for: \(link.title)")
            }
        )
    }
}
