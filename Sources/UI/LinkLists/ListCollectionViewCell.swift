import UIKit
import SFSafeSymbols

class ListCollectionViewCell: UICollectionViewCell {
    static let identifier = "ListCollectionViewCell"
    
    // MARK: - Properties
    
    var contextMenuItem: ListItem?
    var tapItem: ListItem?
    
    // MARK: - UI Elements
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = UIColor.systemBackground
        
        // Setup icon container
        iconContainerView.addSubview(iconImageView)
        
        // Setup label stack view
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(UIView()) // Spacer
        labelStackView.addArrangedSubview(countLabel)
        
        // Setup content stack view
        contentStackView.addArrangedSubview(iconContainerView)
        contentStackView.addArrangedSubview(labelStackView)
        
        // Add to content view
        contentView.addSubview(contentStackView)
        contentView.addSubview(separatorView)
        
        setupConstraints()
        setupAccessibility()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Content stack view
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -12),
            
            // Icon container
            iconContainerView.widthAnchor.constraint(equalToConstant: 32),
            iconContainerView.heightAnchor.constraint(equalToConstant: 32),
            
            // Icon image view
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16),
            
            // Separator
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64), // Align with text
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    // MARK: - Configuration
    
    func configure(with item: ListItem) {
        iconImageView.image = item.icon
        iconContainerView.backgroundColor = item.color
        titleLabel.text = item.title
        countLabel.text = "\(item.count)"
        
        // Update accessibility
        accessibilityLabel = L10n.Shared.Item.List.Accessibility.label(item.title, item.count)
        accessibilityHint = L10n.Shared.Item.List.Accessibility.hint
        
        // Store for context menu and tap handling
        contextMenuItem = item
        tapItem = item
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        iconContainerView.backgroundColor = nil
        titleLabel.text = nil
        countLabel.text = nil
        contextMenuItem = nil
        tapItem = nil
        
        // Reset any transformations
        transform = .identity
        alpha = 1.0
        
        // Remove any existing gesture recognizers and interactions
        gestureRecognizers?.forEach { removeGestureRecognizer($0) }
        interactions.forEach { removeInteraction($0) }
    }
    
    // MARK: - Highlighting
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.backgroundColor = self.isHighlighted ? UIColor.systemGray6 : UIColor.systemBackground
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.backgroundColor = self.isSelected ? UIColor.systemGray5 : UIColor.systemBackground
            }
        }
    }
}

// MARK: - Animation Helpers

extension ListCollectionViewCell {
    func animateHighlight() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self.backgroundColor = UIColor.systemGray6
        }
    }
    
    func animateUnhighlight() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
            self.transform = .identity
            self.backgroundColor = UIColor.systemBackground
        }
    }
}