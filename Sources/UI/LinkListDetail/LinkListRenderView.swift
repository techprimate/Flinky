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
                    "No links available",
                    systemSymbol: .globe,
                    description: Text("Add a new link to get started")
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
                    Label("New Link", systemSymbol: .plusCircleFill)
                        .bold()
                        .imageScale(.large)
                        .labelStyle(.titleAndIcon)
                })
                .buttonStyle(.borderless)
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
                symbol: .star,
                color: .yellow,
                count: 4
            ),
            links: [
                .init(
                    id: UUID(),
                    title: "Apple",
                    url: URL(string: "https://apple.com")!,
                    symbol: .backpack,
                    color: .green
                ),
                .init(
                    id: UUID(),
                    title: "SwiftUI",
                    url: URL(string: "https://developer.apple.com/swiftui/")!,
                    symbol: .americanFootball,
                    color: .blue
                ),
                .init(
                    id: UUID(),
                    title: "Flinky",
                    url: URL(string: "https://flinky.app")!,
                    symbol: .creditcard,
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
