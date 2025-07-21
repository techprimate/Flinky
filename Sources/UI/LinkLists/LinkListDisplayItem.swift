import Foundation
import SFSafeSymbols
import SwiftUI

struct LinkListDisplayItem: Hashable, Identifiable {
    let id: UUID
    let title: String

    let symbol: ListSymbol
    let color: ListColor

    let count: Int
}
