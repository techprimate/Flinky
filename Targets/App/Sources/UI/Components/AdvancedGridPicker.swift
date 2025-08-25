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
            wildcardButtonView
            listView
        }
        .accessibilityIdentifier("advanced-grid-picker.container")
    }

    private var wildcardButtonView: some View {
        wildcardButton()
            .padding(5)
            .overlay {
                if isWildcardItem(selection) {
                    selectionOverlayView
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(isWildcardItem(selection) ? [.isSelected, .isButton] : [.isButton])
            .accessibilityLabel(L10n.Shared.EmojiPicker.Accessibility.hint)
            .accessibilityHint(L10n.Shared.EmojiPicker.Accessibility.hint)
            .accessibilityIdentifier("advanced-grid-picker.wildcard-button")
    }

    private var listView: some View {
        ForEach(items) { item in
            itemView(for: item)
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
            .contentShape(Circle())
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(item.id == selection.id ? [.isSelected, .isButton] : [.isButton])
            .accessibilityHint(L10n.Shared.Item.List.Accessibility.hint)
            .accessibilityIdentifier("advanced-grid-picker.item.\(item.id)")
            .onTapGesture {
                selection = item
            }
    }

    var selectionOverlayView: some View {
        Circle()
            .stroke(Color.gray, lineWidth: 3)
            .opacity(0.5)
    }
}
