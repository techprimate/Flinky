import FlinkyCore
import SFSafeSymbols
import SwiftUI

struct LinkInfoRenderView: View {
    @Binding var name: String
    @Binding var url: String
    @Binding var color: ListColor
    @Binding var symbol: ListSymbol

    let cancelAction: () -> Void
    let saveAction: () -> Void

    var body: some View {
        List {
            NameSection(name: $name, color: color, symbol: symbol)
            UrlSection(url: $url)
            ColorPickerSection(selection: $color)
            SymbolPickerSection(selection: $symbol)
        }
        .accessibilityIdentifier("link-info.container")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    cancelAction()
                } label: {
                    if #available(iOS 26, *) {
                        Label(L10n.Shared.Button.Cancel.label, systemSymbol: .xmark)
                    } else {
                        Text(L10n.Shared.Button.Cancel.label)
                    }
                }
                .accessibilityLabel(L10n.Shared.Button.Cancel.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.Cancel.Accessibility.hint)
                .accessibilityIdentifier("link-info.cancel.button")
            }
            if #available(iOS 26, *) {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        saveAction()
                    } label: {
                        Label(L10n.Shared.Button.Done.label, systemSymbol: .checkmark)
                    }
                    .accessibilityLabel(L10n.Shared.Button.Done.Accessibility.label)
                    .accessibilityHint(L10n.Shared.Button.Done.Accessibility.hint)
                    .accessibilityIdentifier("link-info.save.button")
                }
            } else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveAction()
                    } label: {
                        Text(L10n.Shared.Button.Done.label)
                            .bold()
                    }
                    .accessibilityLabel(L10n.Shared.Button.Done.Accessibility.label)
                    .accessibilityHint(L10n.Shared.Button.Done.Accessibility.hint)
                    .accessibilityIdentifier("link-info.save.button")
                }
            }
        }
    }
}

extension LinkInfoRenderView {
    fileprivate struct NameSection: View {
        fileprivate struct IconPreview: View {
            let symbol: ListSymbol
            let color: ListColor

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
        let color: ListColor
        let symbol: ListSymbol

        var body: some View {
            Section {
                VStack(spacing: 12) {
                    HStack {
                        Spacer()
                        Self.IconPreview(symbol: symbol, color: color)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    TextField(L10n.Shared.Form.Title.label, text: $name)
                        .textFieldStyle(.plain)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(color.color)
                        .padding(.vertical, 16)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .accessibilityLabel(L10n.Shared.Form.Title.Accessibility.label)
                        .accessibilityHint(L10n.Shared.Form.Title.Accessibility.hint)
                        .accessibilityIdentifier("link-info.title.text-field")
                }
                .padding(4)
            }
        }
    }

    fileprivate struct UrlSection: View {
        @Binding var url: String

        var body: some View {
            Section {
                TextField(L10n.Shared.Form.Url.label, text: $url)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                    .disableAutocorrection(true)
                    .padding(.vertical, 8)
                    .accessibilityLabel(L10n.Shared.Form.Url.Accessibility.label)
                    .accessibilityHint(L10n.Shared.Form.Url.Accessibility.hint)
                    .accessibilityIdentifier("link-info.url.text-field")
            }
        }
    }

    fileprivate struct ColorPickerSection: View {
        private struct ColorView: View {
            let color: ListColor

            var body: some View {
                color.color
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
        }

        @Binding var selection: ListColor

        var body: some View {
            Section {
                GridPicker(selection: $selection, items: ListColor.allCases) { color in
                    ColorView(color: color)
                        .accessibilityLabel(L10n.Shared.ColorPicker.Option.Accessibility.label(color.name))
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(L10n.Shared.ColorPicker.Accessibility.hint(selection.name))
            .accessibilityIdentifier("link-info.color.picker")
        }
    }

    fileprivate struct SymbolPickerSection: View {
        private struct SymbolView: View {
            @Environment(\.colorScheme) private var colorScheme

            let symbol: ListSymbol

            var body: some View {
                Image(systemSymbol: symbol.sfsymbol)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(
                        symbol.isEmoji
                            ? Color.blue
                            : (colorScheme == .light ? Color.gray.mix(with: Color.black, by: 0.3) : Color.gray)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(6)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        symbol.isEmoji
                            ? Color.blue.opacity(0.15) : Color.gray.opacity(colorScheme == .light ? 0.1 : 0.2)
                    )
                    .clipShape(Circle())
                    .contentShape(Circle())
            }
        }

        private enum Fields {
            case emoji
        }

        @Binding var selection: ListSymbol

        @FocusState private var isEmojiKeyboardFocused: Bool
        @State private var emojiInput = ""

        var body: some View {
            Section {
                AdvancedGridPicker(
                    selection: $selection,
                    items: ListSymbol.allCases,
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
                ) { symbol in  // swiftlint:disable:this multiple_closures_with_trailing_closure
                    Self.SymbolView(symbol: symbol)
                        .accessibilityLabel(
                            L10n.Shared.SymbolPicker.Option.Accessibility.label(symbolName(for: symbol)))
                }
                // Use an invisible textfield in the background to present the emoji keyboard
                // without showing it on the screen.
                .background(
                    TextField("", text: $emojiInput)
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
            .accessibilityLabel(L10n.Shared.SymbolPicker.Accessibility.hint(symbolName(for: selection)))
            .accessibilityIdentifier("link-info.symbol.picker")
        }

        private func symbolName(for symbol: ListSymbol) -> String {
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
    @Previewable @State var url = "www.techprimate.com"
    @Previewable @State var color: ListColor = .blue
    @Previewable @State var icon: ListSymbol = .communication(.bolt)

    NavigationStack {
        LinkInfoRenderView(
            name: $name,
            url: $url,
            color: $color,
            symbol: $icon,
            cancelAction: {},
            saveAction: {}
        )
    }
}

#Preview("Emoji") {
    @Previewable @State var name = "My Favorites"
    @Previewable @State var url = "www.techprimate.com"
    @Previewable @State var color: ListColor = .indigo
    @Previewable @State var icon: ListSymbol = .emoji("😎")

    NavigationStack {
        LinkInfoRenderView(
            name: $name,
            url: $url,
            color: $color,
            symbol: $icon,
            cancelAction: {},
            saveAction: {}
        )
    }
}
