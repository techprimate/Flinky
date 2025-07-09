import SwiftUI

struct CreateListEditorRenderView: View {
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
            TextField("Name", text: $name)
                .tag(CreateField.name)
                .focused($focusedField, equals: .name)
                .onSubmit {
                    submit()
                }
        }
        .navigationTitle("New List")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    submit()
                }
                .disabled(!isValid())
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
