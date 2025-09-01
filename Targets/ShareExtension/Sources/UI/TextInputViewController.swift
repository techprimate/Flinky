import UIKit
import SwiftUI

class TextInputViewController: UIViewController {
    var initialText: String = ""
    var onSave: ((String) -> Void)?

    weak var textField: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let textView = UITextView(frame: .zero)
        self.textField = textView
        textView.text = initialText
        textView.borderStyle = .none
        textView.returnKeyType = .done
        textView.enablesReturnKeyAutomatically = true
        textView.autocapitalizationType = .words
        textView.autocorrectionType = .default
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isScrollEnabled = false
        view.addSubview(textView)

        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8),
            textView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))

        // Focus immediately for a native feel
        DispatchQueue.main.async { [weak textView] in
            textView?.becomeFirstResponder()
        }
    }

    @objc func doneTapped() {
        finishEditing()
    }

    func finishEditing() {
        onSave?(textField?.text ?? "")
        navigationController?.popViewController(animated: true)
    }
}

extension TextInputViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // User has pressed return
            finishEditing()
            return false
        }
        // Disallow any newline characters from paste or dictation
        if text.rangeOfCharacter(from: .newlines) != nil {
            let cleaned = text.components(separatedBy: .newlines).joined(separator: " ")
            if let replacedText = textView.text as NSString? {
                let updated = replacedText.replacingCharacters(in: range, with: cleaned)
                textView.text = updated
                let cursor = range.location + (cleaned as NSString).length
                textView.selectedRange = NSRange(location: cursor, length: 0)
            }
            return false
        }
        return true
    }
}
