import SwiftUI

struct CreateLinkListEditorRenderView: View {
    enum CreateField {
        case name
    }

    struct FormData {
        let name: String
    }

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @FocusState private var focusedField: CreateField?

    var saveAction: (FormData) -> Void

    init(saveAction: @escaping (FormData) -> Void) {
        self.saveAction = saveAction
    }

    var body: some View {
        Form {
            TextField(L10n.Shared.Form.Name.label, text: $name)
                .tag(CreateField.name)
                .focused($focusedField, equals: .name)
                .accessibilityLabel(L10n.Shared.Form.Name.Accessibility.label)
                .accessibilityHint(L10n.Shared.Form.Name.Accessibility.hint)
                .onSubmit {
                    submit()
                }
        }
        .navigationTitle(L10n.CreateList.title)
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
                .accessibilityHint(isValid() ? L10n.Shared.Button.Save.Accessibility.label : L10n.Shared.Form.Name.Accessibility.hint)
            }
        }
        .onAppear {
            focusedField = .name
        }
    }

    func submit() {
        guard isValid() else {
            return
        }
        saveAction(FormData(name: name))
    }

    func isValid() -> Bool {
        if name.isEmpty {
            return false
        }
        return true
    }
}

#Preview {
    NavigationStack {
        CreateLinkEditorRenderView { _ in }
    }
}
