import SwiftUI
import SFSafeSymbols

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
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                deleteAction(item)
            } label: {
                Label("Delete", systemSymbol: .trash)
            }
            Button {
                pinAction(item)
            } label: {
                Label("Pin", systemSymbol: .pinFill)
            }
            .tint(.blue)
            Button {
                editAction(item)
            } label: {
                Label("Edit", systemSymbol: .pencil)
            }
            .tint(.gray)
        }
        .contextMenu {
            Button {
                editAction(item)
            } label: {
                Label("Edit List", systemSymbol: .pencil)
            }
            Button {
                pinAction(item)
            } label: {
                Label("Pin List", systemSymbol: .pinFill)
            }
            Button(role: .destructive) {
                deleteAction(item)
            } label: {
                Label("Delete List", systemSymbol: .trash)
            }
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
                    symbol: .star,
                    color: .yellow,
                    count: 15,
                ),
                .init(
                    id: UUID(),
                    title: "Favorites",
                    symbol: .emoji("⭐️"),
                    color: .green,
                    count: 0,
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
