import UIKit
import SFSafeSymbols

class CardCollectionViewCell: UICollectionViewCell {
    static let identifier = "CardCollectionViewCell"
    
    // MARK: - Properties
    
    var contextMenuItem: CardItem?
    var tapItem: CardItem?
    
    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        contentView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        // Setup top stack view
        topStackView.addArrangedSubview(iconImageView)
        topStackView.addArrangedSubview(UIView()) // Spacer
        topStackView.addArrangedSubview(countLabel)
        
        // Setup bottom stack view
        bottomStackView.addArrangedSubview(titleLabel)
        bottomStackView.addArrangedSubview(UIView()) // Spacer
        
        // Setup main stack view
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(bottomStackView)
        
        setupConstraints()
        setupAccessibility()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Main stack view
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            // Icon size
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    // MARK: - Configuration
    
    func configure(with item: CardItem) {
        iconImageView.image = item.icon
        iconImageView.tintColor = item.color
        countLabel.text = "\(item.count)"
        titleLabel.text = item.title
        
        // Update accessibility
        accessibilityLabel = L10n.Shared.Item.List.PinnedCard.Accessibility.label(item.title, item.count)
        accessibilityHint = L10n.Shared.Item.List.Accessibility.hint
        
        // Store for context menu and tap handling
        contextMenuItem = item
        tapItem = item
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        iconImageView.tintColor = nil
        countLabel.text = nil
        titleLabel.text = nil
        contextMenuItem = nil
        tapItem = nil
        
        // Reset any transformations
        transform = .identity
        alpha = 1.0
        
        // Remove any existing gesture recognizers and interactions
        gestureRecognizers?.forEach { removeGestureRecognizer($0) }
        interactions.forEach { removeInteraction($0) }
    }
    
    // MARK: - Appearance Updates
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            updateAppearanceForCurrentStyle()
        }
    }
    
    private func updateAppearanceForCurrentStyle() {
        if traitCollection.userInterfaceStyle == .light {
            containerView.backgroundColor = UIColor.white
        } else {
            containerView.backgroundColor = UIColor.secondarySystemBackground
        }
    }
}

// MARK: - Animation Helpers

extension CardCollectionViewCell {
    func animateHighlight() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    func animateUnhighlight() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}