import SwiftUI

public extension Image {
    init(systemSymbol: SystemSymbol) {
        self.init(systemName: systemSymbol.rawValue)
    }
}

public extension Label where Title == Text, Icon == Image {
    nonisolated init(_ title: some StringProtocol, systemSymbol: SystemSymbol) {
        self.init(title, systemImage: systemSymbol.rawValue)
    }
}

public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    nonisolated init(_ title: some StringProtocol, systemSymbol: SystemSymbol, description: Text? = nil) {
        self.init(title, systemImage: systemSymbol.rawValue, description: description)
    }
}
