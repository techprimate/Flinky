import SFSafeSymbols
import SwiftUI

struct LinkListDetailItemView: View {
    let item: LinkListDetailDisplayItem

    let editAction: () -> Void
    let deleteAction: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 8) {
                Label(item.title, symbol: item.symbol)
                    .labelStyle(RoundedIconLabelStyle(color: item.color.color))
                    .foregroundStyle(.primary)
                Text(item.url.absoluteString)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            Spacer()
            Image(systemSymbol: .chevronRight)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Shared.Item.Link.Accessibility.label(item.title, item.url.absoluteString))
        .accessibilityHint(L10n.Shared.Item.Link.Accessibility.hint)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label(L10n.Shared.Action.delete, systemSymbol: .trash)
            }
            .tint(.red)
            .accessibilityLabel(L10n.Shared.Item.Link.Delete.Accessibility.label(item.title))

            Button {
                editAction()
            } label: {
                Label(L10n.Shared.Action.edit, systemSymbol: .pencil)
            }
            .tint(.blue)
            .accessibilityLabel(L10n.Shared.Item.Link.Edit.Accessibility.label(item.title))
        }
        .contextMenu {
            Button {
                editAction()
            } label: {
                Label(L10n.Shared.Action.edit, systemSymbol: .pencil)
            }
            .accessibilityLabel(L10n.Shared.Item.Link.Edit.Accessibility.label(item.title))

            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label(L10n.Shared.Action.delete, systemSymbol: .trash)
            }
            .tint(.red)
            .accessibilityLabel(L10n.Shared.Item.Link.Delete.Accessibility.label(item.title))
        }
    }
}

#Preview {
    let items: [LinkListDetailDisplayItem] = [
        LinkListDetailDisplayItem(
            id: UUID(),
            title: "Example Link",
            url: URL(string: "https://example.com")!,
            symbol: .placesBuildings(.house),
            color: .blue
        ),
        LinkListDetailDisplayItem(
            id: UUID(),
            title: "Another Link",
            url: URL(string: "https://another-example.com")!,
            symbol: .emoji("🌍"),
            color: .green
        )
    ]
    List {
        ForEach(items) { item in
            LinkListDetailItemView(item: item, editAction: {}, deleteAction: {})
        }
    }
}
