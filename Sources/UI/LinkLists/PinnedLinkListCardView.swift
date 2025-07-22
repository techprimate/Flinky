import SFSafeSymbols
import SwiftUI

struct PinnedLinkListCardView: View {
    let item: LinkListDisplayItem

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
                .font(.title)
                .foregroundColor(item.color.color)
                Spacer()
                Text("\(item.count)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            HStack {
                Text(item.title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Accessibility.pinnedListCard(item.title, item.count))
        .accessibilityHint(L10n.Accessibility.listItemHint)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    PinnedLinkListCardView(item: .init(
        id: UUID(),
        title: "Favorites",
        symbol: .communication(.star),
        color: .yellow,
        count: 15
    ))
    .padding()
    .background(Color(.systemGroupedBackground))
}
