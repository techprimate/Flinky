import UIKit

class TextInputViewController: UIViewController {
    var initialText: String = ""
    var onSave: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let textField = UITextField(frame: CGRect(x: 20, y: 100, width: 280, height: 44))
        textField.text = initialText
        textField.borderStyle = .roundedRect
        view.addSubview(textField)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }

    @objc func doneTapped() {
        if let textField = view.subviews.first(where: { $0 is UITextField }) as? UITextField {
            onSave?(textField.text ?? "")
            navigationController?.popViewController(animated: true)
        }
    }
}
