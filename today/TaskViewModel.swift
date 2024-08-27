import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []

    func addTask(title: String, dueDate: Date, notes: String?) {
        let newTask = Task(title: title, dueDate: dueDate, notes: notes)
        tasks.append(newTask)
        saveTasks()
    }

    func markTaskAsCompleted(task: Task) -> Bool {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            let wasCompleted = tasks[index].isCompleted
            tasks[index].isCompleted.toggle()
            saveTasks()
            return !wasCompleted // Return true if the task was just marked as completed
        }
        return false
    }

    func removeTasks(at offsets: IndexSet, in range: TaskRange) {
        let tasksToRemove = getTasks(for: range).enumerated().filter { offsets.contains($0.offset) }.map { $0.element }
        for task in tasksToRemove {
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks.remove(at: index)
            }
        }
        saveTasks()
    }

    func getTasks(for range: TaskRange) -> [Task] {
        switch range {
        case .today:
            let now = Date()
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: now)
            return tasks.filter { calendar.isDateInToday($0.dueDate) || ($0.dueDate < today && !$0.isCompleted) }
                        .sorted { $0.dueDate < $1.dueDate }
        case .next7Days:
            let now = Date()
            let futureDate = Calendar.current.date(byAdding: .day, value: 7, to: now)!
            return tasks.filter { $0.dueDate >= now && $0.dueDate <= futureDate }
                        .sorted { $0.dueDate < $1.dueDate }
        case .all:
            return tasks.sorted { $0.dueDate > $1.dueDate }
        }
    }

    func progress(for range: TaskRange) -> Double {
        let tasksInRange = getTasks(for: range)
        let completedTasks = tasksInRange.filter { $0.isCompleted }
        return tasksInRange.isEmpty ? 0 : Double(completedTasks.count) / Double(tasksInRange.count)
    }

    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    func loadTasks() {
        if let savedTasks = UserDefaults.standard.object(forKey: "tasks") as? Data {
            if let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
                tasks = decodedTasks
            }
        }
    }

    init() {
        loadTasks()
    }
}
