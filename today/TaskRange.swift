import Foundation

enum TaskRange: String, CaseIterable, Identifiable {
    case today = "Hoje"
    case next7Days = "Próximos"
    case all = "Todas"
    
    var id: String { self.rawValue }
}
