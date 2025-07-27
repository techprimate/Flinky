import SFSafeSymbols
import SwiftUI

struct LinkListsItemView: View {
    let item: LinkListsDisplayItem

    let editAction: (_ item: LinkListsDisplayItem) -> Void
    let pinAction: (_ item: LinkListsDisplayItem) -> Void
    let deleteAction: (_ item: LinkListsDisplayItem) -> Void

    var body: some View {
        Label(
            {
                HStack {
                    Text(item.name)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(item.count)")
                        .foregroundColor(.secondary)
                }
            }, symbol: item.symbol
        )
        .labelStyle(RoundedIconLabelStyle(color: item.color.color))
        .foregroundStyle(.primary)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Shared.Item.List.Accessibility.label(item.name, item.count))
        .accessibilityHint(L10n.Shared.Item.List.Accessibility.hint)
        .accessibilityAddTraits(.isButton)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                deleteAction(item)
            } label: {
                Label(L10n.Shared.Action.delete, systemSymbol: .trash)
            }
            .accessibilityLabel(L10n.Shared.Item.List.Delete.Accessibility.label(item.name))
            Button {
                pinAction(item)
            } label: {
                Label(L10n.Shared.Action.pin, systemSymbol: .pinFill)
            }
            .tint(.blue)
            .accessibilityLabel(L10n.Shared.Item.List.Pin.Accessibility.label(item.name))
            Button {
                editAction(item)
            } label: {
                Label(L10n.Shared.Action.edit, systemSymbol: .pencil)
            }
            .tint(.gray)
            .accessibilityLabel(L10n.Shared.Item.List.Edit.Accessibility.label(item.name))
        }
        .contextMenu {
            Button {
                editAction(item)
            } label: {
                Label(L10n.Shared.Button.Edit.label, systemSymbol: .pencil)
            }
            .accessibilityLabel(L10n.Shared.Item.List.Edit.Accessibility.label(item.name))
            Button {
                pinAction(item)
            } label: {
                Label(L10n.Shared.Action.pin, systemSymbol: .pinFill)
            }
            .accessibilityLabel(L10n.Shared.Item.List.Pin.Accessibility.label(item.name))
            Button(role: .destructive) {
                deleteAction(item)
            } label: {
                Label(L10n.Shared.Button.Delete.label, systemSymbol: .trash)
            }
            .accessibilityLabel(L10n.Shared.Item.List.Delete.Accessibility.label(item.name))
        }
    }
}

#Preview {
    List {
        Section {
            let items: [LinkListsDisplayItem] = [
                .init(
                    id: UUID(),
                    name: "Favorites",
                    symbol: .communication(.star),
                    color: .yellow,
                    count: 15
                ),
                .init(
                    id: UUID(),
                    name: "Favorites",
                    symbol: .emoji("⭐️"),
                    color: .green,
                    count: 0
                )
            ]
            ForEach(items) { item in
                LinkListsItemView(
                    item: item,
                    editAction: { _ in },
                    pinAction: { _ in },
                    deleteAction: { _ in }
                )
            }
        }
    }
}
