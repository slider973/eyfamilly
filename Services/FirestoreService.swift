//
//  FirestoreService.swift
//  EyFamily
//
//  Created by jonathan lemaine on 12/10/2024.
//

import Foundation
import Combine
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()
    
    // MARK: - ShoppingItem Methods
    
    func addShoppingItem(_ item: ShoppingItem) -> AnyPublisher<ShoppingItem, Error> {
        let firestoreItem = FirestoreShoppingItem(from: item)
        return Future { promise in
            let docRef = self.db.collection("shoppingItems").document(item.id)
            do {
                try docRef.setData(from: firestoreItem)
                promise(.success(item))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateShoppingItem(_ item: ShoppingItem) -> AnyPublisher<ShoppingItem, Error> {
            let firestoreItem = FirestoreShoppingItem(from: item)
            
            return Future { promise in
                // Recherche du document existant basé sur les propriétés de l'item
                self.db.collection("shoppingItems")
                    .whereField("name", isEqualTo: item.name)
                    .whereField("id", isEqualTo: item.id)
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        guard let document = querySnapshot?.documents.first else {
                            // Si aucun document n'est trouvé, on crée un nouveau document
                            let newDocRef = self.db.collection("shoppingItems").document()
                            do {
                                try newDocRef.setData(from: firestoreItem)
                                var updatedItem = item
                                updatedItem.id = newDocRef.documentID
                                promise(.success(updatedItem))
                            } catch {
                                promise(.failure(error))
                            }
                            return
                        }
                        
                        // Mise à jour du document existant
                        do {
                            try document.reference.setData(from: firestoreItem)
                            var updatedItem = item
                            updatedItem.id = document.documentID
                            promise(.success(updatedItem))
                        } catch {
                            promise(.failure(error))
                        }
                    }
            }.eraseToAnyPublisher()
        }
    
    func deleteShoppingItem(_ item: ShoppingItem) -> AnyPublisher<String, Error> {
        Future { promise in
            self.db.collection("shoppingItems").document(item.id).delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(item.id))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchShoppingItems() -> AnyPublisher<[ShoppingItem], Error> {
        let subject = PassthroughSubject<[ShoppingItem], Error>()
        
        self.db.collection("shoppingItems").addSnapshotListener { snapshot, error in
            if let error = error {
                subject.send(completion: .failure(error))
            } else if let snapshot = snapshot {
                let items = snapshot.documents.compactMap { try? $0.data(as: FirestoreShoppingItem.self).toShoppingItem() }
                subject.send(items)
            } else {
                subject.send([])
            }
        }
        
        return subject.eraseToAnyPublisher()
    }

    
    // MARK: - TaskItem Methods
    
    func addTask(_ task: TaskItem) -> AnyPublisher<TaskItem, Error> {
        Future { promise in
            let docRef = self.db.collection("tasks").document()
            var newTask = task
            newTask.id = docRef.documentID
            do {
                try docRef.setData(from: newTask)
                promise(.success(newTask))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateTask(_ task: TaskItem) -> AnyPublisher<TaskItem, Error> {
        Future { promise in
            do {
                try self.db.collection("tasks").document(task.id).setData(from: task)
                promise(.success(task))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteTask(_ task: TaskItem) -> AnyPublisher<String, Error> {
        Future { promise in
            self.db.collection("tasks").document(task.id).delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(task.id))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchTasks() -> AnyPublisher<[TaskItem], Error> {
        Future { promise in
            self.db.collection("tasks").getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot {
                    let tasks = snapshot.documents.compactMap { try? $0.data(as: TaskItem.self) }
                    promise(.success(tasks))
                } else {
                    promise(.success([]))
                }
            }
        }.eraseToAnyPublisher()
    }
}
