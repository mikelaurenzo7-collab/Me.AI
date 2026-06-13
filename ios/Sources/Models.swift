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

enum CallDirection: String, Codable, CaseIterable, Identifiable {
    case inbound
    case outbound

    var id: String { rawValue }
    var label: String { self == .inbound ? "Inbound" : "Outbound" }
}

enum CallStatus: String, Codable, CaseIterable, Identifiable {
    case queued
    case ringing
    case active
    case completed
    case failed
    case missed

    var id: String { rawValue }

    var label: String {
        switch self {
        case .queued: "Queued"
        case .ringing: "Ringing"
        case .active: "Active"
        case .completed: "Completed"
        case .failed: "Failed"
        case .missed: "Missed"
        }
    }
}

struct MeAICallSummary: Identifiable, Codable {
    let id: String
    let direction: CallDirection
    let status: CallStatus
    let contactName: String
    let phoneNumber: String
    let summary: String
    let outcome: String
    let createdAt: Date
}

struct PendingConfirmation: Identifiable {
    let id: String
    let title: String
    let detail: String
    let actionLabel: String
    let risk: String
}

struct ContactRule: Identifiable {
    enum Handling: String, CaseIterable, Identifiable {
        case alwaysRing
        case screenFirst
        case delegate

        var id: String { rawValue }
        var label: String {
            switch self {
            case .alwaysRing: "Always ring"
            case .screenFirst: "Screen first"
            case .delegate: "Delegate"
            }
        }
    }

    let id: String
    var name: String
    var phoneNumber: String
    var handling: Handling
}

struct OutboundRequestDraft {
    var recipient: String = ""
    var objective: String = ""
    var shouldConfirmBeforeDialing: Bool = true
}
