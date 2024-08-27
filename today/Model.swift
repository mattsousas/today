import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var dueDate: Date
    var isCompleted: Bool = false
    var notes: String? = nil
}
