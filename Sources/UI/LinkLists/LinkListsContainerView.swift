import os.log
import Sentry
import SFSafeSymbols
import SwiftData
import SwiftUI

struct LinkListsContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster

    @Query(
        filter: #Predicate { (list: LinkListModel) in list.isPinned == true },
        sort: [SortDescriptor(\.name, comparator: .localized)]
    )
    private var pinnedLists: [LinkListModel]
    @Query(
        filter: #Predicate { (list: LinkListModel) in list.isPinned == false },
        sort: [SortDescriptor(\.name, comparator: .localized)]
    )
    private var unpinnedLists: [LinkListModel]

    @State private var isCreateListPresented = false
    @State private var isCreateLinkPresented = false

    @State private var presentedInfoList: LinkListModel?
    @State private var searchText = ""

    @State private var listToDelete: LinkListModel?
    @State private var isDeleteListPresented = false
    @State private var listsToDelete: [LinkListModel]?
    @State private var isDeleteListsPresented = false

    var body: some View {
        viewWithAlerts
    }

    var viewWithAlerts: some View {
        viewWithSheets
            .alert(L10n.Shared.DeleteConfirmation.List.alertTitle(listToDelete?.name ?? ""), isPresented: $isDeleteListPresented, presenting: listToDelete) { list in
                Button(role: .destructive) {
                    modelContext.delete(list)

                    do {
                        try modelContext.save()
                    } catch {
                        Self.logger.error("Failed to delete list: \(error)")
                        let appError = AppError.persistenceError(.deleteListFailed(underlyingError: error.localizedDescription))
                        SentrySDK.capture(error: appError)
                        toaster.show(error: appError)
                    }
                } label: {
                    Text(L10n.Shared.Button.Delete.label)
                }
            } message: { _ in
                Text(L10n.Shared.DeleteConfirmation.Warning.cannotUndo)
            }
            .alert(L10n.Shared.DeleteConfirmation.Lists.alertTitle, isPresented: $isDeleteListsPresented, presenting: listsToDelete) { lists in
                Button(role: .destructive) {
                    for list in lists {
                        modelContext.delete(list)
                    }

                    do {
                        try modelContext.save()
                    } catch {
                        Self.logger.error("Failed to save changes after deletion: \(error)")
                        let appError = AppError.persistenceError(.saveChangesAfterDeletionFailed(underlyingError: error.localizedDescription))
                        SentrySDK.capture(error: appError)
                        toaster.show(error: appError)
                    }
                } label: {
                    Text(L10n.Shared.Button.Delete.label)
                }
            } message: { links in
                Text(L10n.Shared.DeleteConfirmation.Lists.warningMessage(links.map(\.name).joined(separator: ", ")))
            }
    }

    var viewWithSheets: some View {
        renderView
            .sheet(isPresented: $isCreateListPresented) {
                NavigationStack {
                    CreateLinkListEditorContainerView()
                }
            }
            .sheet(isPresented: $isCreateLinkPresented) {
                NavigationStack {
                    CreateLinkWithListPickerEditorContainerView()
                }
            }
            .sheet(item: $presentedInfoList) { list in
                NavigationStack {
                    LinkListInfoContainerView(list: list)
                }
            }
    }

    var renderView: some View {
        LinkListsRenderView(
            pinnedLists: pinnedListDisplayItems,
            unpinnedLists: listDisplayItems,
            searchText: $searchText,
            presentCreateList: {
                isCreateListPresented = true
            },
            presentCreateLink: {
                isCreateLinkPresented = true
            },
            pinListAction: { list in
                guard let model = unpinnedLists.first(where: { $0.id == list.id }) else {
                    Self.logger.error("List not found for pinning: \(list.id.uuidString)")
                    let appError = AppError.dataCorruption("List not found for pinning: \(list.id.uuidString)")
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
                    Self.logger.error("List not found for unpinning: \(list.id.uuidString)")
                    let appError = AppError.dataCorruption("List not found for unpinning: \(list.id.uuidString)")
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
                listToDelete = model
                isDeleteListPresented = true
            },
            deleteUnpinnedListsAction: { offsets in
                let models = offsets.map { unpinnedLists[$0] }
                if models.isEmpty {
                    return
                }
                listsToDelete = models
                isDeleteListsPresented = true
            },
            editListAction: { item in
                presentedInfoList = (pinnedLists + unpinnedLists).first { $0.id == item.id }
            }
        ) { listDisplayItem in
            if let list = (pinnedLists + unpinnedLists).first(where: { $0.id == listDisplayItem.id }) {
                LinkListDetailContainerView(list: list)
            }
        }
    }

    var pinnedListDisplayItems: [LinkListsDisplayItem] {
        filteredPinnedLists.map { list in
            mapToDisplayItem(list)
        }
    }

    var listDisplayItems: [LinkListsDisplayItem] {
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

    func mapToDisplayItem(_ model: LinkListModel) -> LinkListsDisplayItem {
        LinkListsDisplayItem(
            id: model.id,
            name: model.name,
            symbol: model.symbol ?? .defaultForList,
            color: model.color ?? .defaultForList,
            count: model.links.count
        )
    }
}
