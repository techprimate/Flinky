import SFSafeSymbols
import Sentry
import SwiftUI

struct CreateLinkListEditorRenderView: View {
    enum CreateField {
        case name
    }

    @Environment(\.dismiss) private var dismiss

    @Binding var name: String
    @FocusState private var focusedField: CreateField?

    let saveAction: () -> Void

    var body: some View {
        List {
            TextField(L10n.Shared.Form.Name.label, text: $name)
                .tag(CreateField.name)
                .focused($focusedField, equals: .name)
                .accessibilityLabel(L10n.Shared.Form.Name.Accessibility.label)
                .accessibilityHint(L10n.Shared.Form.Name.Accessibility.hint)
                .accessibilityIdentifier("create-link-list.name.text-field")
                .onSubmit {
                    submit()
                }
        }
        .navigationTitle(L10n.CreateList.title)
        .accessibilityIdentifier("create-link-list.container")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    SentrySDK.feedback.showForm()
                }, label: {
                    Label(L10n.Shared.Button.Feedback.label, systemSymbol: .megaphone)
                })
                .accessibilityLabel(L10n.Shared.Button.Feedback.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.Feedback.Accessibility.hint)
                .accessibilityIdentifier("create-link-list.feedback.button")
            }
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
                    .accessibilityIdentifier("create-link-list.cancel-button")
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
                    .accessibilityHint(L10n.Shared.Form.Name.Accessibility.hint)
                    .accessibilityIdentifier("create-link-list.save-button")
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
                    .accessibilityHint(L10n.Shared.Form.Name.Accessibility.hint)
                    .accessibilityIdentifier("create-link-list.save-button")
                }
            }
        }
        .onAppear {
            focusedField = .name
        }
    }

    private func isValid() -> Bool {
        if name.isEmpty {
            return false
        }
        return true
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
        CreateLinkListEditorRenderView(
            name: .constant("My Favorites"),
            saveAction: {}
        )
    }
}
