import SwiftUI

struct CreateLinkEditorRenderView: View {
    private enum CreateField {
        case title
        case url
    }

    @Environment(\.dismiss) private var dismiss

    @Binding var name: String
    @Binding var url: String
    let saveAction: () -> Void

    @FocusState private var focusedField: CreateField?

    var body: some View {
        List {
            TextField(L10n.Shared.Form.Title.label, text: $name)
                .tag(CreateField.title)
                .focused($focusedField, equals: .title)
                .accessibilityLabel(L10n.Shared.Form.Title.Accessibility.label)
                .accessibilityHint(L10n.Shared.Form.Title.Accessibility.hint)
                .onSubmit {
                    focusedField = .url
                }
            TextField(L10n.Shared.Form.Url.label, text: $url)
                .tag(CreateField.url)
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
    NavigationStack {
        CreateLinkEditorRenderView(
            name: .constant("My Favorite Link"),
            url: .constant("https://www.example.com"),
            saveAction: {}
        )
    }
}
