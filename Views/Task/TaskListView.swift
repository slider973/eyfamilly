import SwiftUICore
import SwiftUI
struct TaskListView: View {
    @ObservedObject var viewModel: TaskViewModel

    var body: some View {
        List {
            ForEach(viewModel.tasks) { task in
                TaskRowView(task: task)
            }
            .onDelete(perform: deleteTask)
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteTask(viewModel.tasks[index])
        }
    }
}
