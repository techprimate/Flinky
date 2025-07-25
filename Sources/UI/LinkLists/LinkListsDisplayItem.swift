import Foundation
import SFSafeSymbols
import SwiftUI

struct LinkListsDisplayItem: Hashable, Identifiable {
    let id: UUID

    let name: String
    let symbol: ListSymbol
    let color: ListColor

    let count: Int
}
