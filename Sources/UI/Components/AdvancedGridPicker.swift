import SwiftUI

struct AdvancedGridPicker<Item: Identifiable, ItemView: View, WildCardButtonView: View>: View {
    @Binding var selection: Item
    let items: [Item]

    let wildcardButton: () -> WildCardButtonView
    let isWildcardItem: (_ item: Item) -> Bool
    @ViewBuilder let content: (_ item: Item) -> ItemView

    let columns = (0..<6).map { _ in GridItem(.flexible()) }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            wildcardButton()
                .padding(5)
                .overlay {
                    if isWildcardItem(selection) {
                        selectionOverlayView
                    }
                }
            ForEach(items) { item in
                content(item)
                    .padding(5)
                    .overlay {
                        if item.id == selection.id {
                            selectionOverlayView
                        }
                    }
                    .contentShape(Circle())
                    .onTapGesture {
                        selection = item
                    }
            }
        }
    }

    var selectionOverlayView: some View {
        Circle()
            .stroke(Color.gray, lineWidth: 3)
            .opacity(0.5)
    }
}
