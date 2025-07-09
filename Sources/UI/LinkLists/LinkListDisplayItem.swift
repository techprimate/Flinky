import Foundation
import SwiftUI
import SFSafeSymbols

struct LinkListDisplayItem: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let icon: SFSymbol
    let color: Color
    let count: Int
}
