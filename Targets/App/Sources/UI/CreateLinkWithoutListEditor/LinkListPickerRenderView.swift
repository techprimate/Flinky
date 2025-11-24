import FlinkyCore
import SwiftUI

struct LinkListPickerRenderView: View {
    let lists: [LinkListPickerDisplayItem]
    @Binding var selectedList: LinkListPickerDisplayItem?

    var body: some View {
        List(lists, selection: $selectedList) { list in
            itemViewForList(list)
        }
        .listStyle(.plain)
        .navigationTitle(L10n.CreateLinkListPicker.title)
    }

    private func itemViewForList(_ list: LinkListPickerDisplayItem) -> some View {
        Label(
            {
                HStack {
                    Text(list.title)
                        .foregroundColor(.primary)
                    Spacer()
                    if list.id == selectedList?.id {
                        Image(systemSymbol: .checkmark)
                            .foregroundColor(.accentColor)
                    }
                }
            },
            symbol: list.symbol
        )
        .labelStyle(RoundedIconLabelStyle(color: list.color.color))
        .foregroundStyle(.primary)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.CreateLinkListPicker.Item.Accessibility.label(list.title))
        .accessibilityHint(L10n.CreateLinkListPicker.Item.Accessibility.hint)
        .accessibilityAddTraits(.isButton)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedList = list
        }
    }
}

#Preview {
    @Previewable @State var selectedList: LinkListPickerDisplayItem?

    let lists: [LinkListPickerDisplayItem] = [
        .init(
            id: UUID(),
            title: "Title 1",
            symbol: ListSymbol.defaultForLink,
            color: ListColor.defaultForLink
        ),
        .init(
            id: UUID(),
            title: "Title 2",
            symbol: ListSymbol.defaultForLink,
            color: ListColor.defaultForLink
        ),
        .init(
            id: UUID(),
            title: "Title 3",
            symbol: ListSymbol.defaultForLink,
            color: ListColor.defaultForLink
        ),
        .init(
            id: UUID(),
            title: "Title 4",
            symbol: ListSymbol.defaultForLink,
            color: ListColor.defaultForLink
        )
    ]

    NavigationStack {
        LinkListPickerRenderView(
            lists: lists,
            selectedList: $selectedList
        )
    }
}
