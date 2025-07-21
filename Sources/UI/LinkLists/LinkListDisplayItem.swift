import Foundation
import SwiftUI
import SFSafeSymbols

struct LinkListDisplayItem: Hashable, Identifiable {
    let id: UUID
    let title: String

    let symbol: ListSymbol
    let color: ListColor

    let count: Int

    init(id: UUID, title: String, symbol: ListSymbol, color: ListColor, count: Int) {
        self.id = id
        self.title = title
        self.symbol = symbol
        self.color = color
        self.count = count
    }
}
