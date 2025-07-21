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
            TextField(L10n.Form.name, text: $name)
                .tag(CreateField.name)
                .focused($focusedField, equals: .name)
                .accessibilityLabel(L10n.Accessibility.Form.nameField)
                .accessibilityHint(L10n.Accessibility.Hint.enterListName)
                .onSubmit {
                    submit()
                }
        }
        .navigationTitle(L10n.CreateList.title)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(L10n.Form.cancel) {
                    dismiss()
                }
                .accessibilityLabel(L10n.Accessibility.Button.cancel)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(L10n.Form.save) {
                    submit()
                }
                .disabled(!isValid())
                .accessibilityLabel(L10n.Accessibility.Button.save)
                .accessibilityHint(isValid() ? L10n.Accessibility.Hint.saveNewList : L10n.Accessibility.Hint.enterNameFirst)
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
