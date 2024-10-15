import Foundation
import SwiftData
enum ShoppingType: String, CaseIterable, Identifiable, Codable {
    case groceries = "Courses"
    case household = "Maison"
    
    var id: String { self.rawValue }
}

enum ShoppingCategory: String, Codable, CaseIterable {
    case groceries
    case household
    case personalCare
    case electronics
    case clothing
    case other
}

@Model
final class ShoppingItem {
    var id: String
    var name: String
    var quantity: Int
    var category: ShoppingCategory
    var isCompleted: Bool
    var addedBy: String
    var addedDate: Date
    var type: ShoppingType
    var isPurchased: Bool
    var paidBy: String?
    
    init(id: String, name: String, quantity: Int, type: ShoppingType, category: ShoppingCategory, isCompleted: Bool = false, addedBy: String, addedDate: Date = Date(), isPurchased: Bool = false, paidBy: String? = nil) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.isCompleted = isCompleted
        self.addedBy = addedBy
        self.addedDate = addedDate
        self.isPurchased = isPurchased
        self.paidBy = paidBy
        self.type = type
    }
}

// Structure intermédiaire pour ShoppingItem
struct FirestoreShoppingItem: Codable {
    var id: String
    var name: String
    var quantity: Int
    var category: ShoppingCategory
    var isCompleted: Bool
    var addedBy: String
    var addedDate: Date
    var isPurchased: Bool
    var paidBy: String?
    var type: ShoppingType
    
    init(from item: ShoppingItem) {
        self.id = item.id
        self.name = item.name
        self.quantity = item.quantity
        self.category = item.category
        self.isCompleted = item.isCompleted
        self.addedBy = item.addedBy
        self.addedDate = item.addedDate
        self.isPurchased = item.isPurchased
        self.paidBy = item.paidBy
        self.type = item.type
    }
    
    func toShoppingItem() -> ShoppingItem {
        return ShoppingItem(id: id, name: name, quantity: quantity, type: type, category: category, isCompleted: isCompleted, addedBy: addedBy, addedDate: addedDate, isPurchased: isPurchased, paidBy: paidBy)
    }
}
