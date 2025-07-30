import UIKit
import SwiftUI
import SFSafeSymbols
import SentrySwiftUI

// MARK: - UIKit Data Models

struct CardItem: Hashable, Identifiable {
    let id: UUID
    let title: String
    let icon: UIImage
    let color: UIColor
    let count: Int
    
    init(from displayItem: LinkListsDisplayItem) {
        self.id = displayItem.id
        self.title = displayItem.name
        self.count = displayItem.count
        self.color = UIColor(displayItem.color.color)
        
        // Convert ListSymbol to UIImage
        if displayItem.symbol.isEmoji {
            self.icon = displayItem.symbol.text?.toUIImage() ?? UIImage(systemName: "list.bullet")!
        } else {
            self.icon = UIImage(systemSymbol: displayItem.symbol.sfsymbol)
        }
    }
}

struct ListItem: Hashable, Identifiable {
    let id: UUID
    let title: String
    let count: Int
    let icon: UIImage
    let color: UIColor
    
    init(from displayItem: LinkListsDisplayItem) {
        self.id = displayItem.id
        self.title = displayItem.name
        self.count = displayItem.count
        self.color = UIColor(displayItem.color.color)
        
        // Convert ListSymbol to UIImage
        if displayItem.symbol.isEmoji {
            self.icon = displayItem.symbol.text?.toUIImage() ?? UIImage(systemName: "list.bullet")!
        } else {
            self.icon = UIImage(systemSymbol: displayItem.symbol.sfsymbol)
        }
    }
}

// MARK: - Section Enum

enum Section: Int, CaseIterable {
    case cards
    case lists
}

// MARK: - UIKit Collection View Controller

class UIKitLinkListsViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private var searchController: UISearchController!
    
    // Data
    private var allCardItems: [CardItem] = []
    private var allListItems: [ListItem] = []
    private var filteredCardItems: [CardItem] = []
    private var filteredListItems: [ListItem] = []
    
    // Delegate
    weak var delegate: UIKitLinkListsDelegate?
    
    // MARK: - Initialization
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        setupCollectionView()
        setupSearchController()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupToolbar()
        applyInitialSnapshot()
    }
    
    // MARK: - Setup Methods
    
    private func setupCollectionView() {
        collectionView.backgroundColor = UIColor.systemGroupedBackground
        collectionView.alwaysBounceVertical = true
        
        // Register cells
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = L10n.Search.listsAndLinks
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupNavigationBar() {
        title = L10n.App.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func setupToolbar() {
        let createLinkButton = UIBarButtonItem(
            image: UIImage(systemSymbol: .plusCircleFill),
            style: .plain,
            target: self,
            action: #selector(createLinkTapped)
        )
        createLinkButton.title = L10n.LinkLists.CreateLink.title
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let createListButton = UIBarButtonItem(
            image: UIImage(systemSymbol: .plusCircleFill),
            style: .plain,
            target: self,
            action: #selector(createListTapped)
        )
        createListButton.title = L10n.LinkLists.CreateList.title
        
        toolbarItems = [createLinkButton, flexibleSpace, createListButton]
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { 
            [weak self] collectionView, indexPath, item in
            
            switch indexPath.section {
            case Section.cards.rawValue:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
                if let cardItem = item as? CardItem {
                    cell.configure(with: cardItem)
                    self?.setupCardCellInteractions(cell: cell, item: cardItem)
                }
                return cell
                
            case Section.lists.rawValue:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as! ListCollectionViewCell
                if let listItem = item as? ListItem {
                    cell.configure(with: listItem)
                    self?.setupListCellInteractions(cell: cell, item: listItem)
                }
                return cell
                
            default:
                fatalError("Unknown section")
            }
        }
        
        // Configure supplementary view provider for headers
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.identifier,
                for: indexPath
            ) as! SectionHeaderView
            
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .cards:
                headerView.configure(title: "") // No header for cards section
            case .lists:
                if !(self?.filteredCardItems.isEmpty ?? true) {
                    headerView.configure(title: L10n.LinkLists.myListsSection)
                } else {
                    headerView.configure(title: "")
                }
            }
            
            return headerView
        }
    }
    
    // MARK: - Data Management
    
    func updateData(pinnedLists: [LinkListsDisplayItem], unpinnedLists: [LinkListsDisplayItem]) {
        allCardItems = pinnedLists.map { CardItem(from: $0) }
        allListItems = unpinnedLists.map { ListItem(from: $0) }
        
        filterData()
        applySnapshot()
    }
    
    private func filterData() {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            filteredCardItems = allCardItems
            filteredListItems = allListItems
        } else {
            filteredCardItems = allCardItems.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            filteredListItems = allListItems.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(Section.allCases)
        
        if !filteredCardItems.isEmpty {
            snapshot.appendItems(filteredCardItems, toSection: .cards)
        }
        
        if !filteredListItems.isEmpty {
            snapshot.appendItems(filteredListItems, toSection: .lists)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
        // Update navigation bar edit button visibility
        navigationItem.rightBarButtonItem?.isEnabled = !filteredCardItems.isEmpty || !filteredListItems.isEmpty
        
        // Show empty state if needed
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        if filteredCardItems.isEmpty && filteredListItems.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    private func showEmptyState() {
        let emptyStateView = EmptyStateView()
        emptyStateView.configure(
            title: L10n.LinkLists.noListsTitle,
            description: L10n.LinkLists.noListsDescription,
            systemImage: "tray.fill"
        )
        collectionView.backgroundView = emptyStateView
    }
    
    private func hideEmptyState() {
        collectionView.backgroundView = nil
    }
    
    // MARK: - Cell Interaction Setup
    
    private func setupCardCellInteractions(cell: CardCollectionViewCell, item: CardItem) {
        // Add context menu
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(contextMenuInteraction)
        cell.contextMenuItem = item
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.tapItem = item
    }
    
    private func setupListCellInteractions(cell: ListCollectionViewCell, item: ListItem) {
        // Add context menu
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(contextMenuInteraction)
        cell.contextMenuItem = item
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(listItemTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.tapItem = item
    }
    
    // MARK: - Action Handlers
    
    @objc private func editButtonTapped() {
        collectionView.isEditing.toggle()
    }
    
    @objc private func createLinkTapped() {
        delegate?.presentCreateLink()
    }
    
    @objc private func createListTapped() {
        delegate?.presentCreateList()
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? CardCollectionViewCell,
              let item = cell.tapItem else { return }
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        delegate?.didSelectCard(with: item.id)
    }
    
    @objc private func listItemTapped(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? ListCollectionViewCell,
              let item = cell.tapItem else { return }
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        delegate?.didSelectListItem(with: item.id)
    }
}

// MARK: - UISearchResultsUpdating

extension UIKitLinkListsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterData()
        applySnapshot()
    }
}

// MARK: - UIContextMenuInteractionDelegate

extension UIKitLinkListsViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let view = interaction.view else { return nil }
        
        if let cardCell = view as? CardCollectionViewCell,
           let item = cardCell.contextMenuItem {
            return createCardContextMenu(for: item)
        } else if let listCell = view as? ListCollectionViewCell,
                  let item = listCell.contextMenuItem {
            return createListItemContextMenu(for: item)
        }
        
        return nil
    }
    
    private func createCardContextMenu(for item: CardItem) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: L10n.Shared.Action.edit, image: UIImage(systemSymbol: .pencil)) { _ in
                self.delegate?.editCard(with: item.id)
            }
            
            let unpinAction = UIAction(title: L10n.Shared.Action.unpin, image: UIImage(systemSymbol: .pinSlashFill)) { _ in
                self.delegate?.unpinCard(with: item.id)
            }
            
            let deleteAction = UIAction(title: L10n.Shared.Action.delete, image: UIImage(systemSymbol: .trash), attributes: .destructive) { _ in
                self.delegate?.deleteCard(with: item.id)
            }
            
            return UIMenu(title: "", children: [editAction, unpinAction, deleteAction])
        }
    }
    
    private func createListItemContextMenu(for item: ListItem) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: L10n.Shared.Button.Edit.label, image: UIImage(systemSymbol: .pencil)) { _ in
                self.delegate?.editListItem(with: item.id)
            }
            
            let pinAction = UIAction(title: L10n.Shared.Action.pin, image: UIImage(systemSymbol: .pinFill)) { _ in
                self.delegate?.pinListItem(with: item.id)
            }
            
            let deleteAction = UIAction(title: L10n.Shared.Button.Delete.label, image: UIImage(systemSymbol: .trash), attributes: .destructive) { _ in
                self.delegate?.deleteListItem(with: item.id)
            }
            
            return UIMenu(title: "", children: [editAction, pinAction, deleteAction])
        }
    }
}

// MARK: - UICollectionViewDelegate

extension UIKitLinkListsViewController {
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell.alpha = 0.8
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
            cell.transform = .identity
            cell.alpha = 1.0
        }
    }
    
    // Swipe actions for list items
    override func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == Section.lists.rawValue
    }
}

// MARK: - Delegate Protocol

protocol UIKitLinkListsDelegate: AnyObject {
    func presentCreateList()
    func presentCreateLink()
    func didSelectCard(with id: UUID)
    func didSelectListItem(with id: UUID)
    func editCard(with id: UUID)
    func unpinCard(with id: UUID)
    func deleteCard(with id: UUID)
    func editListItem(with id: UUID)
    func pinListItem(with id: UUID)
    func deleteListItem(with id: UUID)
}

// MARK: - Helper Extensions

extension String {
    func toUIImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 24)
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        UIColor.clear.set()
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize))
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension ListSymbol {
    var isEmoji: Bool {
        if case .emoji = self {
            return true
        }
        return false
    }
    
    var text: String? {
        if case let .emoji(text) = self {
            return text
        }
        return nil
    }
}

// MARK: - Compositional Layout Factory

extension UIKitLinkListsViewController {
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section(rawValue: sectionIndex)!
            
            switch section {
            case .cards:
                return createCardsSection()
            case .lists:
                return createListsSection()
            }
        }
        
        return layout
    }
    
    private static func createCardsSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(12)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    private static func createListsSection() -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = true
        configuration.backgroundColor = UIColor.systemGroupedBackground
        
        // Enable swipe actions
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self,
                  indexPath.row < self.filteredListItems.count else { return nil }
            
            let item = self.filteredListItems[indexPath.row]
            
            let deleteAction = UIContextualAction(style: .destructive, title: L10n.Shared.Action.delete) { action, view, completion in
                self.delegate?.deleteListItem(with: item.id)
                completion(true)
            }
            deleteAction.image = UIImage(systemSymbol: .trash)
            
            let pinAction = UIContextualAction(style: .normal, title: L10n.Shared.Action.pin) { action, view, completion in
                self.delegate?.pinListItem(with: item.id)
                completion(true)
            }
            pinAction.backgroundColor = UIColor.systemBlue
            pinAction.image = UIImage(systemSymbol: .pinFill)
            
            let editAction = UIContextualAction(style: .normal, title: L10n.Shared.Action.edit) { action, view, completion in
                self.delegate?.editListItem(with: item.id)
                completion(true)
            }
            editAction.backgroundColor = UIColor.systemGray
            editAction.image = UIImage(systemSymbol: .pencil)
            
            return UISwipeActionsConfiguration(actions: [deleteAction, pinAction, editAction])
        }
        
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: nil)
        
        // Add header if needed
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}