import SwiftUI

struct MeAIAppShell: View {
    @StateObject private var appState = MeAIAppState()

    var body: some View {
        DashboardView()
            .environmentObject(appState)
    }
}

@MainActor
final class MeAIAppState: ObservableObject {
    @Published var accountMode: AccountMode = .personal
    @Published var readiness: AgentReadiness = .init(score: 3, total: 7, nextStep: "Set up activation shortcuts")
    @Published var outboundDraft = OutboundRequestDraft()

    @Published var recentCalls: [MeAICallSummary] = [
        .init(
            id: "demo-1",
            direction: .inbound,
            status: .completed,
            contactName: "Unknown caller",
            phoneNumber: "+1 630 555 0199",
            summary: "Caller asked for availability and requested a callback window.",
            outcome: "Needs callback",
            createdAt: .now.addingTimeInterval(-1800)
        ),
        .init(
            id: "demo-2",
            direction: .outbound,
            status: .queued,
            contactName: "Office",
            phoneNumber: "+1 312 555 0144",
            summary: "Me.AI will say you are running five minutes late after confirmation.",
            outcome: "Waiting for approval",
            createdAt: .now.addingTimeInterval(-4200)
        )
    ]

    @Published var pendingConfirmations: [PendingConfirmation] = [
        .init(id: "confirm-1", title: "Place outbound call", detail: "Call the office and say you are running five minutes late.", actionLabel: "Approve call", risk: "Places a call"),
        .init(id: "confirm-2", title: "Create reminder", detail: "Remind you tomorrow morning to return the unknown caller's voicemail.", actionLabel: "Create reminder", risk: "Modifies reminders")
    ]

    @Published var contactRules: [ContactRule] = [
        .init(id: "rule-1", name: "Family", phoneNumber: "Favorites", handling: .alwaysRing),
        .init(id: "rule-2", name: "Unknown callers", phoneNumber: "Not in contacts", handling: .screenFirst),
        .init(id: "rule-3", name: "Work calls", phoneNumber: "Business contacts", handling: .delegate)
    ]

    func approve(_ confirmation: PendingConfirmation) {
        pendingConfirmations.removeAll { $0.id == confirmation.id }
    }

    func decline(_ confirmation: PendingConfirmation) {
        pendingConfirmations.removeAll { $0.id == confirmation.id }
    }
}
