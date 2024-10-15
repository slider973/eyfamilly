import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @StateObject private var viewModel: ShoppingViewModel
    @State private var showingAddItemForm = false
    @State private var selectedType: ShoppingType = .groceries
    
    init(firestoreService: FirestoreService) {
        _viewModel = StateObject(wrappedValue: ShoppingViewModel(firebaseService: firestoreService))
    }
    
    var body: some View {
        VStack {
            Picker("Type d'achat", selection: $selectedType) {
                ForEach(ShoppingType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            List {
                Section(header: Text("À acheter")) {
                    ForEach(filteredItems.filter { !$0.isPurchased }) { item in
                        ShoppingItemRow(item: item, viewModel: viewModel)
                    }
                }
                
                Section(header: Text("Achetés")) {
                    ForEach(filteredItems.filter { $0.isPurchased }) { item in
                        ShoppingItemRow(item: item, viewModel: viewModel)
                    }
                }
            }
        }
        .navigationTitle(selectedType.rawValue)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddItemForm = true }) {
                    Label("Ajouter un article", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddItemForm) {
            AddItemFormView(viewModel: viewModel, isPresented: $showingAddItemForm, shoppingType: selectedType)
        }
    }
    
    private var filteredItems: [ShoppingItem] {
        viewModel.items.filter { $0.type == selectedType }
    }
}

struct ShoppingItemRow: View {
    let item: ShoppingItem
    let viewModel: ShoppingViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .strikethrough(item.isPurchased)
                Text("Quantité : \(item.quantity)")
                    .font(.subheadline)
                Text("Catégorie : \(item.category.rawValue)")
                    .font(.subheadline)
                Text("Ajouté par : \(item.addedBy)")
                    .font(.caption)
                if let paidBy = item.paidBy {
                    Text("Payé par : \(paidBy)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            Spacer()
            if item.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .onTapGesture {
            viewModel.toggleItemCompletion(item)
        }
        .swipeActions(edge: .trailing) {
            if !item.isPurchased {
                Button {
                    viewModel.toggleItemPurchase(item)
                } label: {
                    Label("Acheter", systemImage: "bag")
                }
                .tint(.blue)
            } else {
                Button {
                    viewModel.toggleItemPurchase(item)
                } label: {
                    Label("Annuler l'achat", systemImage: "arrow.uturn.backward")
                }
                .tint(.orange)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                viewModel.setPaidBy(item, paidBy: "Moi")
            } label: {
                Label("Payé par moi", systemImage: "person")
            }
            .tint(.green)
            
            Button {
                viewModel.setPaidBy(item, paidBy: "Copine")
            } label: {
                Label("Payé par copine", systemImage: "person.2")
            }
            .tint(.purple)
            
            Button(role: .destructive) {
                viewModel.deleteItem(item)
            } label: {
                Label("Supprimer", systemImage: "trash")
            }
        }
    }
}

struct AddItemFormView: View {
    @ObservedObject var viewModel: ShoppingViewModel
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var quantity = 1
    @State private var category: ShoppingCategory = .other
    let shoppingType: ShoppingType
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Nom de l'article", text: $name)
                Stepper("Quantité : \(quantity)", value: $quantity, in: 1...100)
                Picker("Catégorie", selection: $category) {
                    ForEach(categoryOptions, id: \.self) { category in
                        Text(categoryName(category)).tag(category)
                    }
                }
            }
            .navigationTitle("Ajouter un nouvel article")
            .navigationBarItems(
                leading: Button("Annuler") { isPresented = false },
                trailing: Button("Enregistrer") {
                    let newItem = ShoppingItem(id: UUID().uuidString, name: name, quantity: quantity, type: shoppingType, category: category, addedBy: "Utilisateur")
                    viewModel.addItem(newItem)
                    isPresented = false
                }
                .disabled(name.isEmpty)
            )
        }
    }
    
    private var categoryOptions: [ShoppingCategory] {
        shoppingType == .groceries ? [.groceries] : ShoppingCategory.allCases.filter { $0 != .groceries }
    }
    
    private func categoryName(_ category: ShoppingCategory) -> String {
        switch category {
        case .groceries: return "Épicerie"
        case .household: return "Maison"
        case .personalCare: return "Soins personnels"
        case .electronics: return "Électronique"
        case .clothing: return "Vêtements"
        case .other: return "Autres"
        }
    }
}
