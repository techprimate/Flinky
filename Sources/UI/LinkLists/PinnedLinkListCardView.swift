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
                Spacer()
                Text("\(item.count)")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .font(.system(size: 22))
            HStack {
                Text(item.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(12)
        .background(colorScheme == .light ? Color.white : Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Shared.Item.List.PinnedCard.Accessibility.label(item.name, item.count))
        .accessibilityHint(L10n.Shared.Item.List.Accessibility.hint)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    PinnedLinkListCardView(item: .init(
        id: UUID(),
        name: "Favorites",
        symbol: .communication(.star),
        color: .yellow,
        count: 15
    ))
    .padding()
    .background(Color(.systemGroupedBackground))
}
