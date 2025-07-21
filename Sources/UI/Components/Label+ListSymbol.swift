import SwiftUI

struct LabelListSymbolIconView: View {
    let symbol: ListSymbol

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

extension Label where Title == Text, Icon == LabelListSymbolIconView {
    init(_ title: String, symbol: ListSymbol) {
        self = Label({
            Text(title)
        }, symbol: symbol)
    }
}

extension Label where Icon == LabelListSymbolIconView {
    init(_ title: () -> Title, symbol: ListSymbol) {
        self = Label(title: title, icon: {
            LabelListSymbolIconView(symbol: symbol)
        })
    }
}
