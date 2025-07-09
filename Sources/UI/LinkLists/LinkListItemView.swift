import SwiftUI
import SFSafeSymbols

struct LinkListItemView: View {
    let item: LinkListDisplayItem

    var body: some View {
        Label(item.title, systemSymbol: item.icon)
            .labelStyle(RoundedIconLabelStyle(color: item.color))
            .foregroundStyle(.primary)
    }
}

#Preview {
    LinkListItemView(item: .init(title: "Favorites", icon: .starFill, color: .yellow, count: 15))
        .padding()
        .background(Color(.systemGroupedBackground))
}
