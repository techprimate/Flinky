import SFSafeSymbols
import SwiftUI

struct PinnedLinkListCardView: View {
    @Environment(\.colorScheme) private var colorScheme

    let item: LinkListsDisplayItem

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Group {
                    if item.symbol.isEmoji {
                        Text(item.symbol.text ?? "")
                    } else {
                        Image(systemSymbol: item.symbol.sfsymbol)
                    }
                }
                .foregroundColor(item.color.color)
                .frame(height: 36)
                Spacer()
                Text("\(item.count)")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            .font(.system(size: 22))
            HStack {
                Text(item.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Spacer()
            }
        }
        .padding(12)
        .background(colorScheme == .light ? Color.white : Color(UIColor.secondarySystemBackground))
        .ifAvailable(.iOS26, modify: { view in
            view.cornerRadius(16)
        }, elseModify: { view in
            view.cornerRadius(10)
        })
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Shared.Item.List.PinnedCard.Accessibility.label(item.name, item.count))
        .accessibilityHint(L10n.Shared.Item.List.Accessibility.hint)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    PinnedLinkListCardView(
        item: .init(
            id: UUID(),
            name: "Favorites",
            symbol: .communication(.star),
            color: .yellow,
            count: 15
        )
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
