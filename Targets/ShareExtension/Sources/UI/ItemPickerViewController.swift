import UIKit

class ItemPickerViewController: UITableViewController {
    struct Item: Identifiable {
        let id: UUID
        let name: String
    }

    private let options: [Item]
    private let selected: Item.ID?
    var onSelect: ((Item.ID) -> Void)?

    init(options: [Item], selected: Item.ID?) {
        self.options = options
        self.selected = selected

        super.init(style: .plain)

        setupView()
    }

    required init?(coder: NSCoder) {
        self.options = []
        self.selected = nil

        super.init(coder: coder)

        setupView()
    }

    func setupView() {
        self.view.backgroundColor = .clear
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let option = options[indexPath.row]
        cell.textLabel?.text = option.name
        cell.accessoryType = option.id == selected ? .checkmark : .none
        cell.backgroundColor = .clear
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(options[indexPath.row].id)
        navigationController?.popViewController(animated: true)
    }
}
