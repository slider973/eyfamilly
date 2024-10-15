import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(task.assignedTo)
                    .font(.caption)
                Text(task.dueDate, style: .date)
                    .font(.caption)
                statusView
            }
        }
    }
    
    private var statusView: some View {
        switch task.status {
        case .pending:
            return Text("Pending")
                .foregroundColor(.orange)
        case .inProgress:
            return Text("In Progress")
                .foregroundColor(.blue)
        case .completed:
            return Text("Completed")
                .foregroundColor(.green)
        }
    }
}
