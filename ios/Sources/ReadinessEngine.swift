import Foundation

struct ReadinessInput {
    var hasAgentProfile: Bool
    var hasActivationSetup: Bool
    var hasPhoneLine: Bool
    var hasNotificationPermission: Bool
    var hasContactRules: Bool
    var hasPrivacyReview: Bool
    var hasConfirmationRules: Bool
    var hasProviderConnection: Bool
}

struct ReadinessEngine {
    static func evaluate(_ input: ReadinessInput) -> AgentReadiness {
        let checks: [(Bool, String)] = [
            (input.hasAgentProfile, "Customize your agent"),
            (input.hasActivationSetup, "Set up activation shortcuts"),
            (input.hasPhoneLine, "Connect a phone number"),
            (input.hasNotificationPermission, "Enable notifications"),
            (input.hasContactRules, "Add contact rules"),
            (input.hasPrivacyReview, "Review privacy controls"),
            (input.hasConfirmationRules, "Confirm safety rules"),
            (input.hasProviderConnection, "Connect live providers")
        ]

        let completed = checks.filter { $0.0 }.count
        let next = checks.first(where: { !$0.0 })?.1 ?? "Ready for live testing"
        return AgentReadiness(score: completed, total: checks.count, nextStep: next)
    }
}
