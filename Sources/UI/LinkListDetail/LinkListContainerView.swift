import SwiftUI
import os.log
import Sentry

struct LinkListContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster

    let list: LinkListModel

    @State private var isCreateEditorPresented = false
    @State private var selectedLink: LinkModel?
    @State private var editingLink: LinkModel?
    @State private var searchText = ""

    @State private var linkToDelete: LinkModel?
    @State private var isDeleteLinkPresented = false
    @State private var linksToDelete: [LinkModel]?
    @State private var isDeleteLinksPresented = false

    private static let logger = Logger(subsystem: "com.techprimate.Flinky", category: "LinkListContainerView")

    var body: some View {
        LinkListRenderView(
            list: listDisplayItem,
            links: linkDisplayItems,
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
            presentLinkDetail: { linkDisplayItem in
                selectedLink = links.first { $0.id == linkDisplayItem.id }
            }
        )
        .searchable(text: $searchText, prompt: L10n.Search.links)
        .sheet(isPresented: $isCreateEditorPresented) {
            NavigationStack {
                CreateLinkEditorContainerView(list: list)
            }
        }
        .sheet(item: $selectedLink) { link in
            NavigationStack {
                LinkDetailContainerView(item: link)
            }
        }
        .sheet(item: $editingLink) { link in
            NavigationStack {
                LinkInfoContainerView(link: link)
            }
        }
        .alert(L10n.Delete.Link.alertTitle(linkToDelete?.name ?? ""), isPresented: $isDeleteLinkPresented, presenting: linkToDelete) { link in
            Button(role: .destructive) {
                modelContext.delete(link)
                do {
                    try modelContext.save()
                } catch {
                    Self.logger.error("Failed to delete link: \(error)")
                    let appError = AppError.persistenceError(.deleteLinkFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            } label: {
                Text(L10n.Delete.button)
            }
        } message: { link in
            Text(L10n.Delete.Warning.cannotUndo)
        }
        .alert(L10n.Delete.Links.alertTitle, isPresented: $isDeleteLinksPresented, presenting: linksToDelete) { links in
            Button(role: .destructive) {
                for model in links {
                    modelContext.delete(model)
                }
                do {
                    try modelContext.save()
                } catch {
                    Self.logger.error("Failed to delete multiple links: \(error)")
                    let appError = AppError.persistenceError(.deleteMultipleLinksFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            } label: {
                Text(L10n.Delete.button)
            }
        } message: { links in
            Text(L10n.Delete.Links.warningMessage(links.map(\.name).joined(separator: ", ")))
        }
    }

    var listDisplayItem: LinkListDisplayItem {
        LinkListDisplayItem(
            id: list.id,
            title: list.name,
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
            link.name.localizedCaseInsensitiveContains(searchText) ||
            link.url.absoluteString.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var linkDisplayItems: [LinkListDetailDisplayItem] {
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

    var links: [LinkModel] {
        list.links
    }
}
