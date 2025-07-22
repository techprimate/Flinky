import SFSafeSymbols
import SwiftUI

struct LinkListRenderView: View {
    let list: LinkListDisplayItem
    let links: [LinkListDetailDisplayItem]

    let editItem: (LinkListDetailDisplayItem) -> Void
    let deleteItem: (LinkListDetailDisplayItem) -> Void
    let deleteItems: (_ offsets: IndexSet) -> Void

    let presentCreateEditor: () -> Void
    let presentLinkDetail: (LinkListDetailDisplayItem) -> Void

    var body: some View {
        List {
            Section {
                ForEach(links) { link in
                    Button(action: {
                        presentLinkDetail(link)
                    }, label: {
                        LinkDetailItemView(item: link, editAction: {
                            editItem(link)
                        }, deleteAction: {
                            deleteItem(link)
                        })
                    })
                    .buttonStyle(.plain)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .overlay {
            if links.isEmpty {
                ContentUnavailableView(
                    L10n.Links.noLinksTitle,
                    systemSymbol: .globe,
                    description: Text(L10n.Links.noLinksDescription)
                )
            }
        }
        .navigationTitle(list.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    presentCreateEditor()
                }, label: {
                    Label(L10n.Links.newLink, systemSymbol: .plusCircleFill)
                        .bold()
                        .imageScale(.large)
                        .labelStyle(.titleAndIcon)
                })
                .buttonStyle(.borderless)
                .accessibilityLabel(L10n.Accessibility.Button.newLink)
                .accessibilityHint(L10n.Accessibility.Hint.addNewLinkToList)
            }
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationView {
        LinkListRenderView(
            list: .init(
                id: UUID(),
                title: "Favorites",
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
