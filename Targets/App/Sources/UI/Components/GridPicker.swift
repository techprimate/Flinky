import SwiftUI

struct GridPicker<Item: Identifiable, ItemView: View>: View {
    @Binding var selection: Item
    let items: [Item]
    @ViewBuilder let content: (_ item: Item) -> ItemView

    let columns = (0..<6).map { _ in GridItem(.flexible()) }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(items) { item in
                itemView(for: item)
            }
        }
    }

    private func itemView(for item: Item) -> some View {
        content(item)
            .padding(5)
            .overlay {
                if item.id == selection.id {
                    selectionOverlayView
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(item.id == selection.id ? [.isSelected, .isButton] : [.isButton])
            .accessibilityHint(L10n.Shared.Item.List.Accessibility.hint)
            .accessibilityIdentifier("grid-picker.item.\(item.id)")
            .onTapGesture {
                selection = item
            }
    }

    private var selectionOverlayView: some View {
        Circle()
            .stroke(Color.gray, lineWidth: 3)
            .opacity(0.5)
    }
}
