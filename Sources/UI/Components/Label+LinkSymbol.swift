import SwiftUI

struct LabelLinkSymbolIconView: View {
    let symbol: LinkSymbol
    
    var body: some View {
        Group {
            if symbol.isEmoji {
                Text(symbol.text ?? "")
            } else {
                Image(systemSymbol: symbol.sfsymbol)
            }
        }
        .foregroundStyle(.white)
    }
}

extension Label where Title == Text, Icon == LabelLinkSymbolIconView {
    init(_ title: String, symbol: LinkSymbol) {
        self = Label({
            Text(title)
        }, symbol: symbol)
    }
}

extension Label where Icon == LabelLinkSymbolIconView {
    init(_ title: () -> Title, symbol: LinkSymbol) {
        self = Label(title: title) {
            LabelLinkSymbolIconView(symbol: symbol)
        }
    }
}
