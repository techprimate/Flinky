import FlinkyCore
import Foundation

struct LinkListPickerDisplayItem: Hashable, Identifiable {
    let id: UUID

    let title: String
    let symbol: ListSymbol
    let color: ListColor
}
