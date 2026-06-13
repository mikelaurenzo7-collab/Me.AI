import Foundation

enum AccountMode: String, CaseIterable, Identifiable {
    case personal
    case business

    var id: String { rawValue }
    var label: String { self == .personal ? "Personal" : "Business" }
}

struct AgentReadiness {
    let score: Int
    let total: Int
    let nextStep: String
}
