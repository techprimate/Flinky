import SwiftUI

struct LinkInfoContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var color: LinkColor = .default
    @State private var symbol: LinkSymbol = .default

    let link: LinkModel

    var body: some View {
        LinkInfoRenderView(
            name: $name,
            color: $color,
            symbol: $symbol,
            presentEmojiPickerAction: {},
            cancelAction: {
                dismiss()
            },
            saveAction: {
                link.name = name
                link.color = color
                link.symbol = symbol

                do {
                    try modelContext.save()
                } catch {
                    print(error)
                }
                dismiss()
            }
        )
        .onAppear {
            name = link.name
            color = link.color ?? .default
            symbol = link.symbol ?? .default
        }
    }
}
