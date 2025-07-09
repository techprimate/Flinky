import SwiftUI

struct CreateLinkEditorRenderView: View {
    enum CreateField {
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
            TextField("Title", text: $title)
                .tag(CreateField.title)
                .focused($focusedField, equals: .title)
                .onSubmit {
                    focusedField = .url
                }
            TextField("URL", text: $url)
                .tag(CreateField.url)
                .focused($focusedField, equals: .url)
                .textContentType(.URL)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .onSubmit {
                    focusedField = nil
                }
        }
        .navigationTitle("New Link")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if title.isEmpty {
                        return
                    }
                    guard let url = URL(string: url) else {
                        return
                    }
                    saveAction(FormData(title: title, url: url))
                }
                .disabled(title.isEmpty || URL(string: url) == nil)
            }
        }
        .onAppear {
            focusedField = .title
        }
    }
}

#Preview {
    NavigationStack {
        CreateLinkEditorRenderView { _ in }
    }
}
