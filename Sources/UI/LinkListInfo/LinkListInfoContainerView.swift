import SwiftUI

struct LinkListInfoContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var color: ListColor = .default
    @State private var symbol: ListSymbol = .default

    let list: LinkListModel

    var body: some View {
        LinkListInfoRenderView(
            name: $name,
            color: $color,
            symbol: $symbol,
            presentEmojiPickerAction: {},
            cancelAction: {
                dismiss()
            },
            saveAction: {
                list.name = name
                list.color = color
                list.symbol = symbol

                do {
                    try modelContext.save()
                } catch {
                    print(error)
                }
                dismiss()
            }
        )
        .onAppear {
            name = list.name
            color = list.color ?? .default
            symbol = list.symbol ?? .default
        }
    }
}

