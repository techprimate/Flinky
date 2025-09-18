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
                    // TODO: Display the feedback UI when available
                    // SentrySDK.feedback.presentUI()
                }, label: {
                    Label(L10n.Shared.Button.Feedback.label, systemSymbol: .megaphone)
                })
                .accessibilityLabel(L10n.Shared.Button.Feedback.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.Feedback.Accessibility.hint)
                .accessibilityIdentifier("create-link-list.feedback.button")
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(L10n.Shared.Button.Cancel.label) {
                    dismiss()
                }
                .accessibilityLabel(L10n.Shared.Button.Cancel.Accessibility.label)
                .accessibilityHint(L10n.Shared.Button.Cancel.Accessibility.hint)
                .accessibilityIdentifier("create-link-list.cancel-button")
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(L10n.Shared.Button.Save.label) {
                    submit()
                }
                .disabled(!isValid())
                .accessibilityLabel(L10n.Shared.Button.Save.Accessibility.label)
                .accessibilityHint(L10n.Shared.Form.Name.Accessibility.hint)
                .accessibilityIdentifier("create-link-list.save-button")
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
