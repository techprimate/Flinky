import SFSafeSymbols
import SwiftUI

struct LinkInfoRenderView: View {
    @Binding var name: String
    @Binding var color: LinkColor
    @Binding var symbol: LinkSymbol

    let cancelAction: () -> Void
    let saveAction: () -> Void

    var body: some View {
        List {
            NameSection(name: $name, color: color, symbol: symbol)
            ColorPickerSection(selection: $color)
            SymbolPickerSection(selection: $symbol)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(role: .cancel) {
                    cancelAction()
                } label: {
                    Text(L10n.Form.cancel)
                }
                .accessibilityLabel(L10n.Accessibility.Button.cancel)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    saveAction()
                } label: {
                    Text(L10n.Form.done)
                }
                .accessibilityLabel(L10n.Accessibility.Button.done)
                .accessibilityHint(L10n.Accessibility.Hint.saveLinkChanges)
            }
        }
    }
}

private extension LinkInfoRenderView {
    struct NameSection: View {
        fileprivate struct IconPreview: View {
            let symbol: LinkSymbol
            let color: LinkColor

            var body: some View {
                ZStack {
                    if symbol.isEmoji, let text = symbol.text {
                        Text(text)
                    } else {
                        Image(systemSymbol: symbol.sfsymbol)
                    }
                }
                .font(.system(size: 48, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 96, height: 96)
                .background(color.gradient)
                .clipShape(Circle())
                .shadow(color: color.color.opacity(0.4), radius: 12, x: 0, y: 4)
            }
        }

        @Binding var name: String
        let color: LinkColor
        let symbol: LinkSymbol

        var body: some View {
            Section {
                VStack(spacing: 12) {
                    HStack {
                        Spacer()
                        Self.IconPreview(symbol: symbol, color: color)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    TextField(L10n.Form.title, text: $name)
                        .textFieldStyle(.plain)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(color.color)
                        .padding(.vertical, 16)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .accessibilityLabel(L10n.Accessibility.Form.titleField)
                        .accessibilityHint(L10n.Accessibility.Hint.enterLinkTitle)
                }
                .padding(4)
            }
        }
    }

    struct ColorPickerSection: View {
        private struct ColorView: View {
            let color: LinkColor

            var body: some View {
                color.color
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
        }

        @Binding var selection: LinkColor

        var body: some View {
            Section(L10n.Section.color) {
                GridPicker(selection: $selection, items: LinkColor.allCases) { color in
                    ColorView(color: color)
                        .accessibilityLabel(L10n.Accessibility.colorOption(colorName(for: color)))
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(L10n.Accessibility.colorPicker(colorName(for: selection)))
        }
        
        private func colorName(for color: LinkColor) -> String {
            switch color {
            case .blue: return "Blue"
            case .lightBlue: return "Light Blue"
            case .green: return "Green"
            case .red: return "Red"
            case .orange: return "Orange"
            case .yellow: return "Yellow"
            case .purple: return "Purple"
            case .pink: return "Pink"
            case .gray: return "Gray"
            case .brown: return "Brown"
            case .indigo: return "Indigo"
            case .mint: return "Mint"
            }
        }
    }

    struct SymbolPickerSection: View {
        private struct SymbolView: View {
            let symbol: LinkSymbol

            var body: some View {
                Image(systemSymbol: symbol.sfsymbol)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(symbol.isEmoji ? Color.blue : Color.gray.mix(with: Color.black, by: 0.3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(6)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(symbol.isEmoji ? Color.blue.opacity(0.15) : Color.gray.opacity(0.1))
                    .clipShape(Circle())
                    .contentShape(Circle())
            }
        }

        private enum Fields {
            case emoji
        }

        @Binding var selection: LinkSymbol

        @FocusState private var isEmojiKeyboardFocused: Bool
        @State private var emojiInput = ""

        var body: some View {
            Section(L10n.Section.symbol) {
                AdvancedGridPicker(
                    selection: $selection,
                    items: LinkSymbol.allCases,
                    wildcardButton: {
                        Button {
                            // Select an emoji symbol to highlight it in the UI while the keyboard
                            // to select the emoji is presented.
                            selection = .emoji("💙")
                            isEmojiKeyboardFocused = true
                        } label: {
                            // Use an empty emoji symbol as a placeholder
                            // This will cause the symbol to be shown instead of the emoji
                            Self.SymbolView(symbol: .emoji(""))
                        }
                        .buttonStyle(.plain)
                    },
                    isWildcardItem: { $0.isEmoji }
                ) { symbol in
                    Self.SymbolView(symbol: symbol)
                        .accessibilityLabel(L10n.Accessibility.symbolOption(symbolName(for: symbol)))
                }
                // Use an invisible textfield in the background to present the emoji keyboard
                // without showing it on the screen.
                .background(TextField("", text: $emojiInput)
                    .keyboardType(.emoji ?? .default)
                    .textInputAutocapitalization(.never)
                    .focused($isEmojiKeyboardFocused)
                    .onChange(of: emojiInput) { _, newValue in
                        // Accept only the first emoji, then dismiss
                        guard let first = newValue.first else {
                            return
                        }
                        selection = .emoji(String(first))
                        isEmojiKeyboardFocused = false
                    }
                    .frame(width: 0, height: 0)
                    .opacity(0))
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(L10n.Accessibility.symbolPicker(symbolName(for: selection)))
        }
        
        private func symbolName(for symbol: LinkSymbol) -> String {
            if symbol.isEmoji {
                return symbol.text ?? "Custom emoji"
            } else {
                return symbol.sfsymbol.rawValue.replacingOccurrences(of: ".", with: " ").capitalized
            }
        }
    }
}

#Preview("Symbol") {
    @Previewable @State var name = "My Favorites"
    @Previewable @State var color: LinkColor = .blue
    @Previewable @State var icon: LinkSymbol = .bookmark

    NavigationStack {
        LinkInfoRenderView(
            name: $name,
            color: $color,
            symbol: $icon,
            cancelAction: {},
            saveAction: {}
        )
    }
}

#Preview("Emoji") {
    @Previewable @State var name = "My Favorites"
    @Previewable @State var color: LinkColor = .indigo
    @Previewable @State var icon: LinkSymbol = .emoji("😎")

    NavigationStack {
        LinkInfoRenderView(
            name: $name,
            color: $color,
            symbol: $icon,
            cancelAction: {},
            saveAction: {}
        )
    }
}
