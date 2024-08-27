import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TaskViewModel
    @State private var title = ""
    @State private var dueDate = Date()
    @State private var notes = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Título da Tarefa")) {
                    TextField("Título", text: $title)
                }

                Section(header: Text("Data de Vencimento")) {
                    DatePicker("Data", selection: $dueDate, displayedComponents: .date)
                }
                
                Section(header: Text("Notas")) {
                    TextField("Notas", text: $notes)
                }
            }
            .navigationTitle("Nova Tarefa")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        viewModel.addTask(title: title, dueDate: dueDate, notes: notes)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
