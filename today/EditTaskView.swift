import SwiftUI

struct EditTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var title: String
    @State private var dueDate: Date
    @State private var notes: String
    var task: Task
    
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: TaskViewModel, task: Task) {
        self.viewModel = viewModel
        self.task = task
        _title = State(initialValue: task.title)
        _dueDate = State(initialValue: task.dueDate)
        _notes = State(initialValue: task.notes ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Título", text: $title)
                DatePicker("Data de Vencimento", selection: $dueDate, displayedComponents: .date)
                TextField("Notas", text: $notes)
            }
            .navigationBarTitle("Editar Tarefa", displayMode: .inline)
            .navigationBarItems(trailing: Button("Salvar") {
                if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                    viewModel.tasks[index].title = title
                    viewModel.tasks[index].dueDate = dueDate
                    viewModel.tasks[index].notes = notes.isEmpty ? nil : notes
                    viewModel.saveTasks()
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .onAppear {
                title = task.title
                dueDate = task.dueDate
                notes = task.notes ?? ""
            }
        }
    }
}
