import SFSafeSymbols
import SwiftData
import SwiftUI
import os.log
import Sentry

struct LinkListsContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster
    
    private static let logger = Logger(subsystem: "com.techprimate.Flinky", category: "LinkListsContainerView")
    @Query(
        filter: #Predicate { (list: LinkListModel) in list.isPinned == true },
        sort: \.name
    )
    private var pinnedLists: [LinkListModel]
    @Query(
        filter: #Predicate { (list: LinkListModel) in list.isPinned == false },
        sort: \.name
    )
    private var unpinnedLists: [LinkListModel]

    @State private var isCreateListPresented = false
    @State private var presentedInfoList: LinkListModel?
    @State private var searchText = ""

    var body: some View {
        LinkListsRenderView(
            pinnedLists: pinnedListDisplayItems,
            unpinnedLists: listDisplayItems,
            presentCreateList: {
                isCreateListPresented = true
            },
            pinListAction: { list in
                guard let model = unpinnedLists.first(where: { $0.id == list.id }) else {
                    Self.logger.error("List not found for pinning: \(list.title)")
                    let appError = AppError.dataCorruption("List not found for pinning: \(list.title)")
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                    return
                }
                model.isPinned = true
                model.updatedAt = Date()

                do {
                    try modelContext.save()
                } catch {
                    Self.logger.error("Failed to pin list: \(error)")
                    let appError = AppError.persistenceError(.pinListFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            },
            unpinListAction: { list in
                guard let model = pinnedLists.first(where: { $0.id == list.id }) else {
                    Self.logger.error("List not found for unpinning: \(list.title)")
                    let appError = AppError.dataCorruption("List not found for unpinning: \(list.title)")
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                    return
                }
                model.isPinned = false
                model.updatedAt = Date()

                do {
                    try modelContext.save()
                } catch {
                    Self.logger.error("Failed to unpin list: \(error)")
                    let appError = AppError.persistenceError(.unpinListFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            },
            deleteUnpinnedListAction: { list in
                guard let model = unpinnedLists.first(where: { $0.id == list.id }) else {
                    Self.logger.error("List not found for deletion: \(list.id)")
                    let appError = AppError.dataCorruption("List not found for deletion: \(list.id)")
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                    return
                }
                modelContext.delete(model)

                do {
                    try modelContext.save()
                } catch {
                    Self.logger.error("Failed to delete list: \(error)")
                    let appError = AppError.persistenceError(.deleteListFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            },
            deleteUnpinnedListsAction: { offsets in
                // Map the indicies to the models first, as deleting models can cause indicies to be wrong
                let models = offsets.map { unpinnedLists[$0] }
                for model in models {
                    modelContext.delete(model)
                }
                do {
                    try modelContext.save()
                } catch {
                    Self.logger.error("Failed to save changes after deletion: \(error)")
                    let appError = AppError.persistenceError(.saveChangesAfterDeletionFailed(underlyingError: error.localizedDescription))
                    SentrySDK.capture(error: appError)
                    toaster.show(error: appError)
                }
            },
            editListAction: { item in
                presentedInfoList = (pinnedLists + unpinnedLists).first { $0.id == item.id }
            }
        ) { listDisplayItem in
            LinkListContainerView(list: (pinnedLists + unpinnedLists).first { $0.id == listDisplayItem.id }!)
        }
        .searchable(text: $searchText, prompt: L10n.Search.listsAndLinks)
        .sheet(isPresented: $isCreateListPresented) {
            NavigationStack {
                CreateLinkListEditorContainerView()
            }
        }
        .sheet(item: $presentedInfoList) { list in
            NavigationStack {
                LinkListInfoContainerView(list: list)
            }
        }
    }

    var pinnedListDisplayItems: [LinkListDisplayItem] {
        filteredPinnedLists.map { list in
            mapToDisplayItem(list)
        }
    }

    var listDisplayItems: [LinkListDisplayItem] {
        filteredUnpinnedLists.map { list in
            mapToDisplayItem(list)
        }
    }
    
    private var filteredPinnedLists: [LinkListModel] {
        if searchText.isEmpty {
            return pinnedLists
        }
        return pinnedLists.filter { list in
            list.name.localizedCaseInsensitiveContains(searchText) ||
            list.links.contains { link in
                link.name.localizedCaseInsensitiveContains(searchText) ||
                link.url.absoluteString.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private var filteredUnpinnedLists: [LinkListModel] {
        if searchText.isEmpty {
            return unpinnedLists
        }
        return unpinnedLists.filter { list in
            list.name.localizedCaseInsensitiveContains(searchText) ||
            list.links.contains { link in
                link.name.localizedCaseInsensitiveContains(searchText) ||
                link.url.absoluteString.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func mapToDisplayItem(_ model: LinkListModel) -> LinkListDisplayItem {
        LinkListDisplayItem(
            id: model.id,
            title: model.name,
            symbol: model.symbol ?? .defaultForLink,
            color: model.color ?? .default,
            count: model.links.count
        )
    }
}
