import FlinkyCore
import SentrySwift
import SwiftData
import SwiftUI
import os.log

struct LinkListPickerContainerView: View {
    private static let logger = Logger.forType(Self.self)

    @Environment(\.dismiss) private var dismiss
    @Environment(\.toaster) private var toaster

    @Query private var lists: [LinkListModel]
    @State private var selectedList: LinkListPickerDisplayItem?

    let preselectedList: LinkListModel
    let didSelectList: (LinkListModel) -> Void

    var body: some View {
        LinkListPickerRenderView(
            lists: listsDisplayItems,
            selectedList: $selectedList
        )
        .sentryTrace("LINK_LIST_PICKER_VIEW")
        .onChange(of: selectedList) { oldValue, newValue in
            guard let newValue = newValue, oldValue != nil, newValue.id != oldValue?.id else {
                // No change or same selection, do nothing
                return
            }
            guard let list = lists.first(where: { $0.id == newValue.id }) else {
                let error = AppError.dataCorruption("Selected list not found in the query results.")
                SentrySDK.capture(error: error)
                toaster.show(error: error)
                Self.logger.error("Selected list not found in the query results.")
                return
            }
            didSelectList(list)
            dismiss()
        }
        .onAppear {
            selectedList = listsDisplayItems.first { $0.id == preselectedList.id }
        }
    }

    var listsDisplayItems: [LinkListPickerDisplayItem] {
        lists.map { list in
            LinkListPickerDisplayItem(
                id: list.id,
                title: list.name,
                symbol: list.symbol ?? .defaultForList,
                color: list.color ?? .defaultForList
            )
        }
    }
}
