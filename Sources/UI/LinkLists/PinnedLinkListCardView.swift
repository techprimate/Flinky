import SwiftUI
import SFSafeSymbols

struct PinnedLinkListCardView: View {
    let item: LinkListDisplayItem

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemSymbol: item.icon)
                    .font(.title)
                    .foregroundColor(item.color)
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
    }
}

#Preview {
    PinnedLinkListCardView(item: .init(title: "Favorites", icon: .starFill, color: .yellow, count: 15))
        .padding()
        .background(Color(.systemGroupedBackground))
}
