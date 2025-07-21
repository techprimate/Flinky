import SwiftUI

struct GridPicker<Item: Identifiable, ItemView: View>: View {
    @Binding var selection: Item
    let items: [Item]
    @ViewBuilder let content: (_ item: Item) -> ItemView

    let columns = (0 ..< 6).map { _ in GridItem(.flexible()) }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(items) { item in
                content(item)
                    .padding(5)
                    .overlay {
                        if item.id == selection.id {
                            selectionOverlayView
                        }
                    }
                    .onTapGesture {
                        selection = item
                    }
            }
        }
    }

    private var selectionOverlayView: some View {
        Circle()
            .stroke(Color.gray, lineWidth: 3)
            .opacity(0.5)
    }
}
