import SwiftUI

struct LinkListRenderView<Destination: View>: View {
    let list: LinkListDisplayItem
    let links: [LinkListDetailDisplayItem]

    let deleteItems: (_ offsets: IndexSet) -> Void
    let presentCreateEditor: () -> Void

    let destination: (LinkListDetailDisplayItem) -> Destination

    var body: some View {
        List {
            Section {
                ForEach(links) { link in
                    NavigationLink(destination: {
                        destination(link)
                    }, label: {
                        LinkDetailItemView(item: link, editAction: {

                        }, deleteAction: {

                        })
                    })
                }
                .onDelete(perform: deleteItems)
            }
        }
        .overlay {
            if links.isEmpty {
                ContentUnavailableView(
                    "No links available",
                    systemImage: "globe",
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
                    Label(
                        "New Link",
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
}

#Preview {
    NavigationView {
        LinkListRenderView(
            list: .init(title: "Favorites", icon: .starFill, color: .yellow, count: 4),
            links: [
                .init(
                    id: UUID(),
                    title: "Apple",
                    url: URL(string: "https://apple.com")!,
                    icon: .appleLogo,
                    color: .black
                ),
                .init(
                    id: UUID(),
                    title: "SwiftUI",
                    url: URL(string: "https://developer.apple.com/swiftui/")!,
                    icon: .swift,
                    color: .orange
                ),
                .init(
                    id: UUID(),
                    title: "Flinky",
                    url: URL(string: "https://flinky.app")!,
                    icon: .network,
                    color: .blue
                )
            ],
            deleteItems: { _ in },
            presentCreateEditor: {},
        ) { link in
            Text(link.title)
        }
    }
}
