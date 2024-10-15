import SwiftUI

struct TaskItem: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var assignedTo: String
    var status: TaskStatus
    var dueDate: Date
    
    enum TaskStatus: String, Codable {
        case pending
        case inProgress
        case completed
    }
    
    init(id: String = UUID().uuidString, title: String, description: String, assignedTo: String, status: TaskStatus = .pending, dueDate: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.assignedTo = assignedTo
        self.status = status
        self.dueDate = dueDate
    }
}

// Algorithme :
// 1. Définir la structure TaskItem avec les propriétés nécessaires
// 2. Implémenter Identifiable et Codable
// 3. Créer une énumération TaskStatus pour suivre l'état des tâches
