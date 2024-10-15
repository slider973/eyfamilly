import Foundation
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    private var cancellables: Set<AnyCancellable> = []
    private let firestoreService: FirestoreService
    
    init(firestoreService: FirestoreService) {
        self.firestoreService = firestoreService
        fetchTasks()
    }
    
    func addTask(_ task: TaskItem) {
        firestoreService.addTask(task)
            .sink { completion in
                // Handle completion
            } receiveValue: { [weak self] newTask in
                self?.tasks.append(newTask)
            }
            .store(in: &cancellables)
    }
    
    func updateTask(_ task: TaskItem) {
        firestoreService.updateTask(task)
            .sink { completion in
                // Handle completion
            } receiveValue: { [weak self] updatedTask in
                if let index = self?.tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                    self?.tasks[index] = updatedTask
                }
            }
            .store(in: &cancellables)
    }
    
    func deleteTask(_ task: TaskItem) {
        firestoreService.deleteTask(task)
            .sink { completion in
                // Handle completion
            } receiveValue: { [weak self] deletedTaskId in
                self?.tasks.removeAll { $0.id == deletedTaskId }
            }
            .store(in: &cancellables)
    }
    
    private func fetchTasks() {
        firestoreService.fetchTasks()
            .sink { completion in
                // Handle completion
            } receiveValue: { [weak self] tasks in
                self?.tasks = tasks
            }
            .store(in: &cancellables)
    }
}
