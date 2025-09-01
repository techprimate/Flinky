import FlinkyCore
import Foundation
import SFSafeSymbols
import SwiftUI

struct LinkListDetailDisplayItem: Hashable, Identifiable {
    let id: UUID

    let title: String
    let url: URL

    let symbol: ListSymbol
    let color: ListColor
}
