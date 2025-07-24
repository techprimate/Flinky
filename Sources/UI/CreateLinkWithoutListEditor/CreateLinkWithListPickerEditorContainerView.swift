import SwiftUI
import SwiftData
import os.log
import Sentry

struct CreateLinkWithListPickerEditorContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.toaster) private var toaster

    @Query private var lists: [LinkListModel]
    @State private var selectedList: LinkListModel?

    @State private var name = ""
    @State private var url = ""

    var body: some View {
        renderView
            .onAppear {
                // If no list is selected, default to the first available list
                if selectedList == nil {
                    selectedList = lists.first
                }
            }
            .onChange(of: lists) { _, newLists in
                // If no list is selected, default to the first available list
                if selectedList == nil {
                    selectedList = newLists.first
                }
            }
    }

    @ViewBuilder private var renderView: some View {
        if let list = selectedList {
            CreateLinkWithListPickerEditorRenderView(
                name: $name,
                url: $url,
                selectedList: .init(
                    id: list.id,
                    name: list.name,
                    symbol: list.symbol ?? .defaultForList,
                    color: list.color ?? .defaultForList
                ),
                saveAction: {
                    guard let url = URL(string: url) else {
                        preconditionFailure("Validation of URL was not performed before saving")
                    }
                    let newItem = LinkModel(
                        name: name,
                        url: url
                    )
                    modelContext.insert(newItem)
                    list.links.append(newItem)
                    list.updatedAt = Date()

                    do {
                        try modelContext.save()
                        dismiss()
                    } catch {
                        Self.logger.error("Failed to save link: \(error)")
                        let appError = AppError.persistenceError(.saveLinkFailed(underlyingError: error.localizedDescription))
                        SentrySDK.capture(error: appError)
                        toaster.show(error: appError)
                    }
                }
            ) {
                LinkListPickerContainerView(
                    preselectedList: list,
                    didSelectList: { list in
                        self.selectedList = list
                    }
                )
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}
