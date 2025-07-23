import SwiftUI

struct CreateLinkEditorRenderView: View {
    private enum CreateField {
        case title
        case url
    }

    struct FormData {
        let title: String
        let url: URL
    }

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var url: String = ""

    @FocusState private var focusedField: CreateField?

    var saveAction: (FormData) -> Void

    init(saveAction: @escaping (FormData) -> Void) {
        self.saveAction = saveAction
    }

    var body: some View {
        Form {
            TextField(L10n.Shared.Form.Title.label, text: $title)
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
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(L10n.Shared.Button.Save.label) {
                    submit()
                }
                .disabled(!isValid())
                .accessibilityLabel(L10n.Shared.Button.Save.Accessibility.label)
                .accessibilityHint(isValid() ? L10n.Shared.Button.Save.Accessibility.label : L10n.Shared.Form.Title.Accessibility.hint)
            }
        }
        .onAppear {
            focusedField = .title
        }
    }
    
    private func isValid() -> Bool {
        return !title.isEmpty && !url.isEmpty && URL(string: url) != nil
    }
    
    private func submit() {
        guard isValid() else {
            return
        }
        
        guard let validURL = URL(string: url) else {
            return
        }
        
        saveAction(FormData(title: title, url: validURL))
    }
}

#Preview {
    NavigationStack {
        CreateLinkEditorRenderView { _ in }
    }
}
