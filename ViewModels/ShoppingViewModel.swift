import SwiftUI
import SwiftData
import Combine

class ShoppingViewModel: ObservableObject {
    @Published var items: [ShoppingItem] = []
    private var cancellables = Set<AnyCancellable>()
    private let firebaseService: FirestoreService
    
    init(firebaseService: FirestoreService) {
        self.firebaseService = firebaseService
        fetchItems()
    }
    
    func fetchItems() {
        firebaseService.fetchShoppingItems()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Erreur lors de la récupération des items: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] items in
                self?.items = items
            })
            .store(in: &cancellables)
    }
    
    func addItem(_ item: ShoppingItem) {
        firebaseService.addShoppingItem(item)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Erreur lors de l'ajout de l'item: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] item in
                self?.items.append(item)
            })
            .store(in: &cancellables)
    }
    
    func updateItem(_ item: ShoppingItem) {
        print(item.id)
        firebaseService.updateShoppingItem(item)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Erreur lors de la mise à jour de l'item: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] updatedItem in
                if let index = self?.items.firstIndex(where: { $0.id == updatedItem.id }) {
                    self?.items[index] = updatedItem
                }
            })
            .store(in: &cancellables)
    }
    
    func deleteItem(_ item: ShoppingItem) {
        firebaseService.deleteShoppingItem(item)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Erreur lors de la suppression de l'item: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] deletedItemId in
                self?.items.removeAll { $0.id == deletedItemId }
            })
            .store(in: &cancellables)
    }
    
    func toggleItemCompletion(_ item: ShoppingItem) {
        var updatedItem = item
        updatedItem.isCompleted.toggle()
        updateItem(updatedItem)
    }
    
    func toggleItemPurchase(_ item: ShoppingItem) {
        var updatedItem = item
        updatedItem.isPurchased.toggle()
        updateItem(updatedItem)
    }
    
    func setPaidBy(_ item: ShoppingItem, paidBy: String) {
        var updatedItem = item
        updatedItem.paidBy = paidBy
        updateItem(updatedItem)
    }
}
