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
    
    private static let logger = Logger(subsystem: "com.techprimate.Flinky", category: "LinkListContainerView")

    var body: some View {
        LinkListRenderView(
            list: listDisplayItem,
            links: linkDisplayItems,
            editItem: { item in
                editingLink = list.links.first(where: { $0.id == item.id })
            },
            deleteItem: { item in
                guard let model = list.links.first(where: { $0.id == item.id }) else {
                    Self.logger.error("Link not found for deletion: \(item.id)")
                    let appError = AppError.dataCorruption("Link not found for deletion")
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                    return
                }
                modelContext.delete(model)
                do {
                    try modelContext.save()
                } catch {
                    Self.logger.error("Failed to delete link: \(error)")
                    let appError = AppError.persistenceError(.deleteLinkFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            },
            deleteItems: { offsets in
                let models = offsets.map { links[$0] }
                for model in models {
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
            },
            presentCreateEditor: {
                isCreateEditorPresented = true
            },
            presentLinkDetail: { linkDisplayItem in
                selectedLink = list.links.first { $0.id == linkDisplayItem.id }
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
    }

    var listDisplayItem: LinkListDisplayItem {
        LinkListDisplayItem(id: list.id, title: list.name, symbol: .archiveBox, color: .gray, count: list.links.count)
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
                symbol: link.symbol ?? .default,
                color: link.color ?? .default
            )
        }
    }

    var links: [LinkModel] {
        list.links
    }
}
