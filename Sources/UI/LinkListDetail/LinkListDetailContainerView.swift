import Sentry
import SentrySwiftUI
import SwiftUI
import os.log

struct LinkListDetailContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster

    @State private var isCreateEditorPresented = false
    @State private var isEditEditorPresented = false
    @State private var isDeleteListPresented = false

    @State private var presentedLink: LinkModel?
    @State private var editingLink: LinkModel?
    @State private var searchText = ""

    @State private var linkToDelete: LinkModel?
    @State private var isDeleteLinkPresented = false
    @State private var linksToDelete: [LinkModel]?
    @State private var isDeleteLinksPresented = false

    let list: LinkListModel

    var body: some View {
        renderViewWithSheets
            .alert(
                L10n.Shared.DeleteConfirmation.Link.alertTitle(linkToDelete?.name ?? ""),
                isPresented: $isDeleteLinkPresented, presenting: linkToDelete
            ) { link in
                Button(role: .destructive) {
                    modelContext.delete(link)
                    do {
                        try modelContext.save()
                    } catch {
                        Self.logger.error("Failed to delete link: \(error)")
                        let appError = AppError.persistenceError(
                            .deleteLinkFailed(underlyingError: error.localizedDescription))
                        SentrySDK.capture(error: appError)
                        toaster.show(error: appError)
                    }
                } label: {
                    Text(L10n.Shared.Button.Delete.label)
                }
            } message: { _ in
                Text(L10n.Shared.DeleteConfirmation.Warning.cannotUndo)
            }
            .alert(
                L10n.Shared.DeleteConfirmation.Links.alertTitle, isPresented: $isDeleteLinksPresented,
                presenting: linksToDelete
            ) { links in
                Button(role: .destructive) {
                    for model in links {
                        modelContext.delete(model)
                    }
                    do {
                        try modelContext.save()
                    } catch {
                        Self.logger.error("Failed to delete multiple links: \(error)")
                        let appError = AppError.persistenceError(
                            .deleteMultipleLinksFailed(underlyingError: error.localizedDescription))
                        SentrySDK.capture(error: appError)
                        toaster.show(error: appError)
                    }
                } label: {
                    Text(L10n.Shared.Button.Delete.label)
                }
            } message: { links in
                Text(L10n.Shared.DeleteConfirmation.Links.warningMessage(links.map(\.name).joined(separator: ", ")))
            }
            .alert(L10n.Shared.DeleteConfirmation.List.alertTitle(list.name), isPresented: $isDeleteListPresented) {
                Button(role: .destructive) {
                    modelContext.delete(list)

                    do {
                        try modelContext.save()
                        dismiss()
                    } catch {
                        Self.logger.error("Failed to delete list: \(error)")
                        let appError = AppError.persistenceError(
                            .deleteListFailed(underlyingError: error.localizedDescription))
                        SentrySDK.capture(error: appError)
                        toaster.show(error: appError)
                    }
                } label: {
                    Text(L10n.Shared.Button.Delete.label)
                }
            } message: {
                Text(L10n.Shared.DeleteConfirmation.Warning.cannotUndo)
            }
    }

    private var renderViewWithSheets: some View {
        renderView
            .sheet(isPresented: $isCreateEditorPresented) {
                NavigationStack {
                    CreateLinkEditorContainerView(list: list)
                }
            }
            .sheet(isPresented: $isEditEditorPresented) {
                NavigationStack {
                    LinkListInfoContainerView(list: list)
                }
            }
            .sheet(item: $presentedLink) { link in
                NavigationStack {
                    LinkDetailContainerView(item: link)
                }
            }
            .sheet(item: $editingLink) { link in
                NavigationStack {
                    LinkInfoContainerView(link: link)
                }
            }
    }

    private var renderView: some View {
        LinkListDetailRenderView(
            list: listDisplayItem,
            links: linkDisplayItems,
            searchText: $searchText,
            editItem: { item in
                editingLink = links.first(where: { $0.id == item.id })
            },
            deleteItem: { item in
                guard let model = links.first(where: { $0.id == item.id }) else {
                    Self.logger.error("Link not found for deletion: \(item.id)")
                    let appError = AppError.dataCorruption("Link not found for deletion")
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                    return
                }
                linkToDelete = model
                isDeleteLinkPresented = true
            },
            deleteItems: { offsets in
                let models = offsets.map { links[$0] }
                if models.isEmpty {
                    return
                }
                linksToDelete = models
                isDeleteLinksPresented = true
            },
            presentCreateEditor: {
                isCreateEditorPresented = true
            },
            presentEditEditor: {
                isEditEditorPresented = true
            },
            presentLinkDetail: { linkDisplayItem in
                presentedLink = links.first { $0.id == linkDisplayItem.id }
            },
            deleteListAction: {
                isDeleteListPresented = true
            }
        )
        .sentryTrace("LINK_LIST_DETAIL_VIEW")
    }

    // MARK: - Data

    private var listDisplayItem: LinkListsDisplayItem {
        LinkListsDisplayItem(
            id: list.id,
            name: list.name,
            symbol: list.symbol ?? .defaultForList,
            color: list.color ?? .defaultForList,
            count: links.count
        )
    }

    private var filteredLinks: [LinkModel] {
        if searchText.isEmpty {
            return links
        }
        return links.filter { link in
            link.name.localizedCaseInsensitiveContains(searchText)
                || link.url.absoluteString.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var linkDisplayItems: [LinkListDetailDisplayItem] {
        filteredLinks.map { link in
            LinkListDetailDisplayItem(
                id: link.id,
                title: link.name,
                url: link.url,
                symbol: link.symbol ?? .defaultForList,
                color: link.color ?? .defaultForList
            )
        }
    }

    private var links: [LinkModel] {
        list.links
    }
}
