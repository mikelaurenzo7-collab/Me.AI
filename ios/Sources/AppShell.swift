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
    @Published var readiness: AgentReadiness = .init(score: 4, total: 8, nextStep: "Customize your agent")
    @Published var outboundDraft = OutboundRequestDraft()
    @Published var agentProfile = AgentProfile()
    @Published var runtimePolicy = AgentRuntimePolicy()

    @Published var scenarios: [AgentScenario] = [
        .init(id: "scenario-1", name: "Unknown caller", trigger: "Caller is not in contacts", goal: "Screen politely and identify reason for call", escalationRule: "Escalate if urgent, family-related, legal, medical, or time-sensitive", allowedActions: "Summarize, request callback window, create reminder after approval"),
        .init(id: "scenario-2", name: "Running late", trigger: "User asks Me.AI to notify someone", goal: "Make a concise outbound update", escalationRule: "Ask for confirmation before placing call", allowedActions: "Prepare call, place call after approval, summarize result"),
        .init(id: "scenario-3", name: "Appointment", trigger: "Call appears related to appointment or scheduling", goal: "Confirm time, location, and next step", escalationRule: "Escalate if schedule conflict or payment issue appears", allowedActions: "Summarize, create reminder after approval")
    ]

    @Published var scripts: [AgentScript] = [
        .init(id: "script-1", name: "Inbound screening opener", purpose: "Screen unknown callers", body: "Hi, this is Me.AI. I can help route the call. What is this regarding?", whenToUse: "Unknown inbound caller"),
        .init(id: "script-2", name: "Running late update", purpose: "Notify someone the user is delayed", body: "Hi, this is Me.AI. Michael asked me to let you know he is running about five minutes late.", whenToUse: "User asks Me.AI to call with a delay update")
    ]

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

    func refreshReadiness() {
        readiness = ReadinessEngine.evaluate(
            .init(
                hasAgentProfile: !agentProfile.name.isEmpty,
                hasActivationSetup: true,
                hasPhoneLine: false,
                hasNotificationPermission: false,
                hasContactRules: !contactRules.isEmpty,
                hasPrivacyReview: true,
                hasConfirmationRules: true,
                hasProviderConnection: false
            )
        )
    }

    func approve(_ confirmation: PendingConfirmation) {
        pendingConfirmations.removeAll { $0.id == confirmation.id }
    }

    func decline(_ confirmation: PendingConfirmation) {
        pendingConfirmations.removeAll { $0.id == confirmation.id }
    }
}
