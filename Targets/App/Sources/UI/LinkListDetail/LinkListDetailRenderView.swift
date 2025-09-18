import SFSafeSymbols
import Sentry
import SwiftUI

struct LinkListDetailRenderView: View {
    let list: LinkListsDisplayItem
    let links: [LinkListDetailDisplayItem]

    @Binding var searchText: String

    let editItem: (LinkListDetailDisplayItem) -> Void
    let deleteItem: (LinkListDetailDisplayItem) -> Void
    let deleteItems: (_ offsets: IndexSet) -> Void

    let presentCreateEditor: () -> Void
    let presentEditEditor: () -> Void
    let presentLinkDetail: (LinkListDetailDisplayItem) -> Void

    let deleteListAction: () -> Void

    var body: some View {
        listContent
            .navigationTitle(list.name)
            .accessibilityIdentifier("link-list-detail.container")
            .searchable(text: $searchText, prompt: L10n.Search.links)
            .overlay {
                emptyStateView
            }
            .toolbar {
                toolbarContent
            }
    }

    @ViewBuilder
    private var listContent: some View {
        List {
            Section {
                ForEach(links) { link in
                    itemViewForLink(link)
                }
                .onDelete(perform: deleteItems)
            }
        }
    }

    @ViewBuilder
    private var emptyStateView: some View {
        if links.isEmpty {
            ContentUnavailableView(
                L10n.LinkListDetail.noLinksTitle,
                systemSymbol: .globe,
                description: Text(L10n.LinkListDetail.noLinksDescription)
            )
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                // TODO: Display the feedback UI when available
                // SentrySDK.feedback.presentUI()
            }, label: {
                Label(L10n.Shared.Button.Feedback.label, systemSymbol: .megaphone)
            })
            .accessibilityLabel(L10n.Shared.Button.Feedback.Accessibility.label)
            .accessibilityHint(L10n.Shared.Button.Feedback.Accessibility.hint)
            .accessibilityIdentifier("link-list-detail.feedback.button")
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            moreMenu
        }
        ToolbarItem(placement: .bottomBar) {
            newLinkButton
        }
        ToolbarItem(placement: .bottomBar) {
            Spacer()
        }
    }

    @ViewBuilder
    private var moreMenu: some View {
        Menu {
            editListButton
            deleteListButton
        } label: {
            Label(L10n.LinkListDetail.MoreMenu.label, systemSymbol: .ellipsisCircle)
                .accessibilityLabel(L10n.LinkListDetail.MoreMenu.Accessibility.label)
                .accessibilityHint(L10n.LinkListDetail.MoreMenu.Accessibility.hint)
        }
        .accessibilityIdentifier("link-list-detail.more-menu.button")
    }

    @ViewBuilder
    private var editListButton: some View {
        Button {
            presentEditEditor()
        } label: {
            Label(L10n.LinkListDetail.MoreMenu.EditList.label, systemSymbol: .safari)
        }
        .accessibilityLabel(L10n.LinkListDetail.MoreMenu.EditList.Accessibility.label)
        .accessibilityHint(L10n.LinkListDetail.MoreMenu.EditList.Accessibility.hint)
        .accessibilityIdentifier("link-list-detail.edit.button")
    }

    @ViewBuilder
    private var deleteListButton: some View {
        Button(role: .destructive) {
            deleteListAction()
        } label: {
            Label(L10n.LinkListDetail.MoreMenu.DeleteList.label, systemSymbol: .trash)
        }
        .accessibilityLabel(L10n.LinkListDetail.MoreMenu.DeleteList.Accessibility.label)
        .accessibilityHint(L10n.LinkListDetail.MoreMenu.DeleteList.Accessibility.hint)
        .accessibilityIdentifier("link-list-detail.delete.button")
    }

    @ViewBuilder
    private var newLinkButton: some View {
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
        .accessibilityHint(L10n.Shared.Button.NewLink.Accessibility.hint)
        .accessibilityIdentifier("link-list-detail.new-link.button")
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
        .accessibilityIdentifier("link-list-detail.link-item.\(link.id).navigation-button")
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
            presentEditEditor: {},
            presentLinkDetail: { link in
                print("Presenting link detail for: \(link.title)")
            },
            deleteListAction: {}
        )
    }
}
