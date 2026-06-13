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

enum AgentResponseStyle: String, CaseIterable, Identifiable {
    case concise
    case balanced
    case detailed
    case warm
    case formal
    case direct

    var id: String { rawValue }
    var label: String {
        switch self {
        case .concise: "Concise"
        case .balanced: "Balanced"
        case .detailed: "Detailed"
        case .warm: "Warm"
        case .formal: "Formal"
        case .direct: "Direct"
        }
    }
}

struct AgentProfile {
    var name: String = "Me.AI"
    var voice: String = "alloy"
    var voiceStyle: String = "Calm, professional"
    var responseStyle: AgentResponseStyle = .concise
    var welcomeMessage: String = "I am Me.AI. I can help screen, place, summarize, and follow up on calls."
    var aiDisclosure: String = "This is Me.AI, an AI assistant."
    var behaviorInstructions: String = "Be concise, calm, helpful, and privacy-protective. Ask for confirmation before sensitive actions."
    var trainingNotes: String = "Protect my time. Unknown callers should be screened first. Family and urgent calls should be prioritized."
}

struct AgentScenario: Identifiable {
    let id: String
    var name: String
    var trigger: String
    var goal: String
    var escalationRule: String
    var allowedActions: String
}

struct AgentScript: Identifiable {
    let id: String
    var name: String
    var purpose: String
    var body: String
    var whenToUse: String
}
