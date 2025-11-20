import SwiftUI

struct CreateLinkWithListPickerEditorRenderView<PickerDestination: View>: View {
    private enum Field {
        case title
        case url
    }

    @Environment(\.dismiss) private var dismiss

    @FocusState private var focusedField: Field?

    @Binding var name: String
    @Binding var url: String
    let selectedList: CreateLinkWithListPickerListDisplayItem
    let saveAction: () -> Void

    @ViewBuilder let pickerDestination: () -> PickerDestination

    var body: some View {
        List {
            formView
            listSectionView
        }
        .navigationTitle(L10n.CreateLink.title)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    if #available(iOS 26, *) {
                        Label(L10n.Shared.Button.Cancel.label, systemSymbol: .xmark)
                    } else {
                        Text(L10n.Shared.Button.Cancel.label)
                    }
                }
                .accessibilityLabel(L10n.Shared.Button.Cancel.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.Cancel.Accessibility.hint)
            }
            if #available(iOS 26, *) {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        submit()
                    } label: {
                        Label(L10n.Shared.Button.Save.label, systemSymbol: .checkmark)
                    }
                    .disabled(!isValid())
                    .accessibilityLabel(L10n.Shared.Button.Save.Accessibility.label)
                    .accessibilityHint(L10n.Shared.Button.Save.Accessibility.hint)
                }
            } else {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        submit()
                    } label: {
                        Text(L10n.Shared.Button.Save.label)
                    }
                    .disabled(!isValid())
                    .accessibilityLabel(L10n.Shared.Button.Save.Accessibility.label)
                    .accessibilityHint(L10n.Shared.Button.Save.Accessibility.hint)
                }
            }
        }
        .onAppear {
            focusedField = .title
        }
    }

    var formView: some View {
        Section {
            TextField(L10n.Shared.Form.Title.label, text: $name)
                .tag(Field.title)
                .focused($focusedField, equals: .title)
                .accessibilityLabel(L10n.Shared.Form.Title.Accessibility.label)
                .accessibilityHint(L10n.Shared.Form.Title.Accessibility.hint)
                .onSubmit {
                    focusedField = .url
                }
            TextField(L10n.Shared.Form.Url.label, text: $url)
                .tag(Field.url)
                .focused($focusedField, equals: .url)
                .textContentType(.URL)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .accessibilityLabel(L10n.Shared.Form.Url.Accessibility.label)
                .accessibilityHint(L10n.Shared.Form.Url.Accessibility.hint)
                .onSubmit {
                    focusedField = nil
                }
        }
    }

    var listSectionView: some View {
        Section {
            NavigationLink(destination: pickerDestination()) {
                Label(
                    {
                        HStack {
                            Text("List")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(selectedList.name)
                                .foregroundColor(.secondary)
                        }
                    }, symbol: selectedList.symbol
                )
                .labelStyle(RoundedIconLabelStyle(color: selectedList.color.color))
                .foregroundStyle(.primary)
                .accessibilityElement(children: .combine)
                //                    .accessibilityLabel(L10n.Shared.Item.List.Accessibility.label(item.title))
                //                    .accessibilityHint(L10n.Shared.Item.List.Accessibility.hint)
                .accessibilityAddTraits(.isButton)
            }
        }
    }

    private func isValid() -> Bool {
        !name.isEmpty && !url.isEmpty && URL(string: url) != nil
    }

    private func submit() {
        guard isValid() else {
            return
        }
        saveAction()
    }
}

#Preview {
    let selectedList = CreateLinkWithListPickerListDisplayItem(
        id: UUID(),
        name: "Default List",
        symbol: .defaultForList,
        color: .defaultForList
    )

    Color.gray.sheet(isPresented: .constant(true)) {
        NavigationStack {
            CreateLinkWithListPickerEditorRenderView(
                name: .constant("My Link"),
                url: .constant("https://www.example.com"),
                selectedList: selectedList,
                saveAction: {}
            ) {  // swiftlint:disable:this multiple_closures_with_trailing_closure
                Text("Picker Destination")
            }
        }
    }
}
