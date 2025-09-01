import FlinkyCore
import Foundation
import SFSafeSymbols
import SwiftUI

struct CreateLinkWithListPickerListDisplayItem: Hashable {
    let id: UUID

    let name: String
    let symbol: ListSymbol
    let color: ListColor
}
