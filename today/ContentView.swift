import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var selectedRange: TaskRange = .today
    @State private var showingAddTaskView = false
    @State private var showingEditTaskView = false
    @State private var showingConfiguracoesView = false
    @State private var circleSize: CGFloat = 240 // Diminuiu o tamanho do círculo de 300 para 240
    @State private var image: UIImage? = nil
    @State private var showCongratulations: Bool = false
    @State private var taskToEdit: Task? = nil
    @State private var showingNote: NotaWrapper? = nil

    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer().frame(height: 0) // Adiciona um espaço de 25 pontos no topo

                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50) // Ajuste a altura conforme necessário
                    } else {
                        ProgressView()
                            .onAppear(perform: loadImage)
                    }

                    Spacer().frame(height: 5) // Adiciona um espaço de 10 pontos abaixo da imagem

                    HStack {
                        Picker("Tarefas", selection: $selectedRange) {
                            ForEach(TaskRange.allCases) { range in
                                Text(range.rawValue).tag(range)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                        Spacer()

                        Button(action: {
                            showingAddTaskView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .padding(.trailing, 20) // Puxar o botão 10 pontos para a esquerda
                    }
                    .padding(.vertical)

                    ZStack {
                        VStack {
                            Spacer().frame(height: 20) // Adiciona um espaço de 20 pontos antes do círculo

                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 20.0)
                                    .opacity(0.3)
                                    .foregroundColor(Color.blue)

                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(viewModel.progress(for: selectedRange), 1.0)))
                                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(Color.blue)
                                    .rotationEffect(Angle(degrees: 270.0))
                                    .animation(.linear, value: viewModel.progress(for: selectedRange))

                                if showCongratulations {
                                    Text("Parabéns!")
                                        .font(.system(size: 24))
                                        .foregroundColor(.green)
                                        .animation(.easeIn)
                                } else if viewModel.progress(for: selectedRange) == 1.0 {
                                    Text("🎉")
                                        .font(.system(size: 100))
                                        .animation(.easeIn)
                                }
                            }
                            .frame(width: circleSize, height: circleSize)
                            .padding()

                            List {
                                if viewModel.getTasks(for: selectedRange).isEmpty {
                                    Text("Nenhuma tarefa")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                } else {
                                    ForEach(viewModel.getTasks(for: selectedRange)) { task in
                                        HStack {
                                            Button(action: {
                                                if viewModel.markTaskAsCompleted(task: task) {
                                                    showCongratulationsMessage()
                                                }
                                            }) {
                                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(task.isCompleted ? .green : .gray)
                                            }
                                            VStack(alignment: .leading) {
                                                Text(task.title)
                                                    .font(.headline)
                                                HStack {
                                                    if selectedRange == .today && Calendar.current.isDateInPast(task.dueDate) {
                                                        Text("Atrasada")
                                                            .font(.caption)
                                                            .foregroundColor(.red)
                                                            .padding(4)
                                                            .background(Color.red.opacity(0.2))
                                                            .cornerRadius(4)
                                                    }
                                                    HStack {
                                                        Text("Data: \(task.dueDate, formatter: DateFormatter.shortDate)")
                                                            .font(.caption)
                                                    }
                                                    .padding(4)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(4)
                                                }
                                            }
                                            Spacer()
                                            if let notes = task.notes, !notes.isEmpty {
                                                Button(action: {
                                                    showingNote = NotaWrapper(note: notes)
                                                }) {
                                                    Image(systemName: "note.text")
                                                        .foregroundColor(.blue)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .swipeActions(edge: .leading) {
                                            Button(action: {
                                                taskToEdit = task
                                                showingEditTaskView = true
                                            }) {
                                                Label("Editar", systemImage: "pencil")
                                            }
                                            .tint(.blue)
                                        }
                                    }
                                    .onDelete { indices in
                                        viewModel.removeTasks(at: indices, in: selectedRange)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .background(Color.white.opacity(1.1))
                            .cornerRadius(20)
                            .padding()
                        }
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingConfiguracoesView = true
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddTaskView) {
                AddTaskView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingConfiguracoesView) {
                ConfiguracoesView()
            }
            .sheet(item: $taskToEdit) { task in
                EditTaskView(viewModel: viewModel, task: task)
            }
            .alert(item: $showingNote) { note in
                Alert(title: Text("Nota"), message: Text(note.note), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func loadImage() {
        let urlString = "https://iili.io/dzC2Rxn.png"
        let fileName = URL(string: urlString)!.lastPathComponent
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let savedImage = UIImage(contentsOfFile: fileURL.path) {
                self.image = savedImage
            }
        } else {
            downloadImage(from: URL(string: urlString)!) { data in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                    try? data.write(to: fileURL)
                }
            }
        }
    }

    func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    completion(data)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func showCongratulationsMessage() {
        showCongratulations = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showCongratulations = false
        }
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

extension Calendar {
    func isDateInPast(_ date: Date) -> Bool {
        return date < startOfDay(for: Date())
    }
}
