import SFSafeSymbols
import SwiftUI

struct LinkListItemView: View {
    let item: LinkListDisplayItem

    let editAction: (_ item: LinkListDisplayItem) -> Void
    let pinAction: (_ item: LinkListDisplayItem) -> Void
    let deleteAction: (_ item: LinkListDisplayItem) -> Void

    var body: some View {
        Label({
            HStack {
                Text(item.title)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(item.count)")
                    .foregroundColor(.secondary)
            }
        }, symbol: item.symbol)
            .labelStyle(RoundedIconLabelStyle(color: item.color.color))
            .foregroundStyle(.primary)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Shared.Item.List.Accessibility.label(item.title, item.count))
            .accessibilityHint(L10n.Shared.Item.List.Accessibility.hint)
            .accessibilityAddTraits(.isButton)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) {
                    deleteAction(item)
                } label: {
                    Label(L10n.Shared.Action.delete, systemSymbol: .trash)
                }
                .accessibilityLabel(L10n.Shared.Item.List.Delete.Accessibility.label(item.title))
                Button {
                    pinAction(item)
                } label: {
                    Label(L10n.Shared.Action.pin, systemSymbol: .pinFill)
                }
                .tint(.blue)
                .accessibilityLabel(L10n.Shared.Item.List.Pin.Accessibility.label(item.title))
                Button {
                    editAction(item)
                } label: {
                    Label(L10n.Shared.Action.edit, systemSymbol: .pencil)
                }
                .tint(.gray)
                .accessibilityLabel(L10n.Shared.Item.List.Edit.Accessibility.label(item.title))
            }
            .contextMenu {
                Button {
                    editAction(item)
                } label: {
                    Label(L10n.Shared.Button.Edit.label, systemSymbol: .pencil)
                }
                .accessibilityLabel(L10n.Shared.Item.List.Edit.Accessibility.label(item.title))
                Button {
                    pinAction(item)
                } label: {
                    Label(L10n.Shared.Action.pin, systemSymbol: .pinFill)
                }
                .accessibilityLabel(L10n.Shared.Item.List.Pin.Accessibility.label(item.title))
                Button(role: .destructive) {
                    deleteAction(item)
                } label: {
                    Label(L10n.Shared.Button.Delete.label, systemSymbol: .trash)
                }
                .accessibilityLabel(L10n.Shared.Item.List.Delete.Accessibility.label(item.title))
            }
    }
}

#Preview {
    List {
        Section {
            let items: [LinkListDisplayItem] = [
                .init(
                    id: UUID(),
                    title: "Favorites",
                    symbol: .communication(.star),
                    color: .yellow,
                    count: 15
                ),
                .init(
                    id: UUID(),
                    title: "Favorites",
                    symbol: .emoji("⭐️"),
                    color: .green,
                    count: 0
                )
            ]
            ForEach(items) { item in
                LinkListItemView(
                    item: item,
                    editAction: { _ in },
                    pinAction: { _ in },
                    deleteAction: { _ in }
                )
            }
        }
    }
}
