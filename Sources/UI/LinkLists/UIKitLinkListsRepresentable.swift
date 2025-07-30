import SwiftUI
import UIKit
import SentrySwiftUI

struct UIKitLinkListsRepresentable: UIViewControllerRepresentable {
    // MARK: - Properties
    
    let pinnedLists: [LinkListsDisplayItem]
    let unpinnedLists: [LinkListsDisplayItem]
    
    let presentCreateList: () -> Void
    let presentCreateLink: () -> Void
    
    let pinListAction: (LinkListsDisplayItem) -> Void
    let unpinListAction: (LinkListsDisplayItem) -> Void
    let deleteUnpinnedListAction: (LinkListsDisplayItem) -> Void
    let editListAction: (LinkListsDisplayItem) -> Void
    
    let destination: (LinkListsDisplayItem) -> AnyView
    
    // MARK: - UIViewControllerRepresentable
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let layout = UIKitLinkListsViewController.createLayout()
        let collectionViewController = UIKitLinkListsViewController(collectionViewLayout: layout)
        
        collectionViewController.delegate = context.coordinator
        
        let navigationController = UINavigationController(rootViewController: collectionViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        guard let collectionViewController = uiViewController.topViewController as? UIKitLinkListsViewController else {
            return
        }
        
        // Update coordinator with new actions
        context.coordinator.updateActions(
            pinnedLists: pinnedLists,
            unpinnedLists: unpinnedLists,
            presentCreateList: presentCreateList,
            presentCreateLink: presentCreateLink,
            pinListAction: pinListAction,
            unpinListAction: unpinListAction,
            deleteUnpinnedListAction: deleteUnpinnedListAction,
            editListAction: editListAction,
            destination: destination
        )
        
        // Update data
        collectionViewController.updateData(pinnedLists: pinnedLists, unpinnedLists: unpinnedLists)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            pinnedLists: pinnedLists,
            unpinnedLists: unpinnedLists,
            presentCreateList: presentCreateList,
            presentCreateLink: presentCreateLink,
            pinListAction: pinListAction,
            unpinListAction: unpinListAction,
            deleteUnpinnedListAction: deleteUnpinnedListAction,
            editListAction: editListAction,
            destination: destination
        )
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIKitLinkListsDelegate {
        // Data and actions
        private var pinnedLists: [LinkListsDisplayItem]
        private var unpinnedLists: [LinkListsDisplayItem]
        
        private var presentCreateList: () -> Void
        private var presentCreateLink: () -> Void
        
        private var pinListAction: (LinkListsDisplayItem) -> Void
        private var unpinListAction: (LinkListsDisplayItem) -> Void
        private var deleteUnpinnedListAction: (LinkListsDisplayItem) -> Void
        private var editListAction: (LinkListsDisplayItem) -> Void
        
        private var destination: (LinkListsDisplayItem) -> AnyView
        
        init(
            pinnedLists: [LinkListsDisplayItem],
            unpinnedLists: [LinkListsDisplayItem],
            presentCreateList: @escaping () -> Void,
            presentCreateLink: @escaping () -> Void,
            pinListAction: @escaping (LinkListsDisplayItem) -> Void,
            unpinListAction: @escaping (LinkListsDisplayItem) -> Void,
            deleteUnpinnedListAction: @escaping (LinkListsDisplayItem) -> Void,
            editListAction: @escaping (LinkListsDisplayItem) -> Void,
            destination: @escaping (LinkListsDisplayItem) -> AnyView
        ) {
            self.pinnedLists = pinnedLists
            self.unpinnedLists = unpinnedLists
            self.presentCreateList = presentCreateList
            self.presentCreateLink = presentCreateLink
            self.pinListAction = pinListAction
            self.unpinListAction = unpinListAction
            self.deleteUnpinnedListAction = deleteUnpinnedListAction
            self.editListAction = editListAction
            self.destination = destination
        }
        
        func updateActions(
            pinnedLists: [LinkListsDisplayItem],
            unpinnedLists: [LinkListsDisplayItem],
            presentCreateList: @escaping () -> Void,
            presentCreateLink: @escaping () -> Void,
            pinListAction: @escaping (LinkListsDisplayItem) -> Void,
            unpinListAction: @escaping (LinkListsDisplayItem) -> Void,
            deleteUnpinnedListAction: @escaping (LinkListsDisplayItem) -> Void,
            editListAction: @escaping (LinkListsDisplayItem) -> Void,
            destination: @escaping (LinkListsDisplayItem) -> AnyView
        ) {
            self.pinnedLists = pinnedLists
            self.unpinnedLists = unpinnedLists
            self.presentCreateList = presentCreateList
            self.presentCreateLink = presentCreateLink
            self.pinListAction = pinListAction
            self.unpinListAction = unpinListAction
            self.deleteUnpinnedListAction = deleteUnpinnedListAction
            self.editListAction = editListAction
            self.destination = destination
        }
        
        // MARK: - UIKitLinkListsDelegate
        
        func presentCreateList() {
            presentCreateList()
        }
        
        func presentCreateLink() {
            presentCreateLink()
        }
        
        func didSelectCard(with id: UUID) {
            guard let item = pinnedLists.first(where: { $0.id == id }) else { return }
            
            // Navigate to destination - this would require additional setup for navigation
            // For now, we'll handle this through the existing action
            // In a full implementation, you might use a navigation coordinator
            _ = destination(item)
        }
        
        func didSelectListItem(with id: UUID) {
            guard let item = unpinnedLists.first(where: { $0.id == id }) else { return }
            
            // Navigate to destination - this would require additional setup for navigation
            // For now, we'll handle this through the existing action
            // In a full implementation, you might use a navigation coordinator
            _ = destination(item)
        }
        
        func editCard(with id: UUID) {
            guard let item = pinnedLists.first(where: { $0.id == id }) else { return }
            editListAction(item)
        }
        
        func unpinCard(with id: UUID) {
            guard let item = pinnedLists.first(where: { $0.id == id }) else { return }
            unpinListAction(item)
        }
        
        func deleteCard(with id: UUID) {
            guard let item = pinnedLists.first(where: { $0.id == id }) else { return }
            deleteUnpinnedListAction(item)
        }
        
        func editListItem(with id: UUID) {
            guard let item = unpinnedLists.first(where: { $0.id == id }) else { return }
            editListAction(item)
        }
        
        func pinListItem(with id: UUID) {
            guard let item = unpinnedLists.first(where: { $0.id == id }) else { return }
            pinListAction(item)
        }
        
        func deleteListItem(with id: UUID) {
            guard let item = unpinnedLists.first(where: { $0.id == id }) else { return }
            deleteUnpinnedListAction(item)
        }
    }
}

// MARK: - Enhanced UIKitLinkListsRenderView

struct UIKitLinkListsRenderView<Destination: View>: View {
    let pinnedLists: [LinkListsDisplayItem]
    let unpinnedLists: [LinkListsDisplayItem]
    
    let presentCreateList: () -> Void
    let presentCreateLink: () -> Void
    
    let pinListAction: (LinkListsDisplayItem) -> Void
    let unpinListAction: (LinkListsDisplayItem) -> Void
    let deleteUnpinnedListAction: (LinkListsDisplayItem) -> Void
    let editListAction: (LinkListsDisplayItem) -> Void
    
    @ViewBuilder let destination: (LinkListsDisplayItem) -> Destination
    
    var body: some View {
        UIKitLinkListsRepresentable(
            pinnedLists: pinnedLists,
            unpinnedLists: unpinnedLists,
            presentCreateList: presentCreateList,
            presentCreateLink: presentCreateLink,
            pinListAction: pinListAction,
            unpinListAction: unpinListAction,
            deleteUnpinnedListAction: deleteUnpinnedListAction,
            editListAction: editListAction,
            destination: { item in
                AnyView(destination(item))
            }
        )
        .sentryTrace("UIKIT_LINK_LISTS_VIEW")
    }
}