import Foundation
import SFSafeSymbols
import SwiftUI

struct LinkListDetailDisplayItem: Identifiable {
    let id: UUID
    let title: String
    let url: URL

    let symbol: LinkSymbol
    let color: LinkColor
}
