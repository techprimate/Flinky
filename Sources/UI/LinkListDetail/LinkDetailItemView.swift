import SFSafeSymbols
import SwiftUI

struct LinkDetailItemView: View {
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
        .accessibilityLabel(L10n.Accessibility.linkItem(item.title, item.url.absoluteString))
        .accessibilityHint(L10n.Accessibility.linkItemHint)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label("Delete", systemSymbol: .trash)
            }
            .tint(.red)
            .accessibilityLabel(L10n.Accessibility.deleteLink(item.title))
            
            Button {
                editAction()
            } label: {
                Label("Edit", systemSymbol: .pencil)
            }
            .tint(.blue)
            .accessibilityLabel(L10n.Accessibility.editLink(item.title))
        }
        .contextMenu {
            Button {
                editAction()
            } label: {
                Label("Edit", systemSymbol: .pencil)
            }
            .accessibilityLabel(L10n.Accessibility.editLink(item.title))
            
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label("Delete", systemSymbol: .trash)
            }
            .tint(.red)
            .accessibilityLabel(L10n.Accessibility.deleteLink(item.title))
        }
    }
}

#Preview {
    let items: [LinkListDetailDisplayItem] = [
        LinkListDetailDisplayItem(
            id: UUID(),
            title: "Example Link",
            url: URL(string: "https://example.com")!,
            symbol: .house,
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
            LinkDetailItemView(item: item, editAction: {}, deleteAction: {})
        }
    }
}
