import SwiftUI
import SFSafeSymbols
import Sentry

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
                .accessibilityIdentifier("create-link.title.text-field")
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
                .accessibilityIdentifier("create-link.url.text-field")
                .onSubmit {
                    focusedField = nil
                }
        }
        .navigationTitle(L10n.CreateLink.title)
        .accessibilityIdentifier("create-link.container")
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
                .accessibilityIdentifier("create-link.cancel.button")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    SentrySDK.feedback.showForm()
                }, label: {
                    Label(L10n.Shared.Button.Feedback.label, systemSymbol: .megaphone)
                })
                .accessibilityLabel(L10n.Shared.Button.Feedback.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.Feedback.Accessibility.hint)
                .accessibilityIdentifier("create-link.feedback.button")
            }
            ToolbarItem(placement: .confirmationAction) {
                if #available(iOS 26, *) {
                    Button(role: .confirm) {
                        submit()
                    } label: {
                        Label(L10n.Shared.Button.Save.label, systemSymbol: .checkmark)
                    }
                    .disabled(!isValid())
                    .accessibilityLabel(L10n.Shared.Button.Save.Accessibility.label)
                    .accessibilityHint(L10n.Shared.Button.Save.Accessibility.hint)
                    .accessibilityIdentifier("create-link.save.button")
                } else {
                    Button {
                        submit()
                    } label: {
                        Text(L10n.Shared.Button.Save.label)
                    }
                    .disabled(!isValid())
                    .accessibilityLabel(L10n.Shared.Button.Save.Accessibility.label)
                    .accessibilityHint(L10n.Shared.Button.Save.Accessibility.hint)
                    .accessibilityIdentifier("create-link.save.button")
                }
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
