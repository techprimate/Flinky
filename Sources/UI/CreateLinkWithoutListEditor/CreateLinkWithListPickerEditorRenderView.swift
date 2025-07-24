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
                Button(L10n.Shared.Button.Cancel.label) {
                    dismiss()
                }
                .accessibilityLabel(L10n.Shared.Button.Cancel.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.Cancel.Accessibility.hint)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(L10n.Shared.Button.Save.label) {
                    submit()
                }
                .disabled(!isValid())
                .accessibilityLabel(L10n.Shared.Button.Save.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.Save.Accessibility.hint)
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
                Label({
                    HStack {
                        Text("List")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(selectedList.name)
                            .foregroundColor(.secondary)
                    }
                }, symbol: selectedList.symbol)
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
            ) {
                Text("Picker Destination")
            }
        }
    }
}
