import SwiftUI
import SwiftData

struct MainListContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [LinkModel]

    @Binding var presentedDetailItem: LinkModel?
    @Binding var isCreateEditorPresented: Bool

    @State private var itemToDelete: LinkModel?

    init(
        presentedDetailItem: Binding<LinkModel?>,
        isCreateEditorPresented: Binding<Bool>
    ) {
        self._presentedDetailItem = presentedDetailItem
        self._isCreateEditorPresented = isCreateEditorPresented
    }

    var body: some View {
        List {
            ForEach(items) { item in
                MainListItemRenderView(item: item, editAction: {
                    
                }, deleteAction: {
                    itemToDelete = item
                })
                    .onTapGesture {
                        presentedDetailItem = item
                    }
            }
            .onDelete(perform: deleteItems)
        }
        .overlay {
            if items.isEmpty {
                ContentUnavailableView(
                    "No links available",
                    systemImage: "globe",
                    description: Text("Add a new link to get started")
                )
            }
        }
        .navigationTitle("Links")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    isCreateEditorPresented = true
                }, label: {
                    Label(
                        "New Link",
                        systemImage: "plus.circle.fill"
                    )
                    .bold()
                    .imageScale(.large)
                    .labelStyle(.titleAndIcon)
                })
                .buttonStyle(.borderless)
            }
        }
        .sheet(item: $presentedDetailItem) { item in
            Text(item.id.uuidString)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}
