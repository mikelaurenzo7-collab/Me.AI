import Foundation

struct VoiceExperienceProfile {
    enum ConversationRole: String, CaseIterable, Identifiable {
        case personalAssistant
        case receptionist
        case scheduler
        case sales
        case support

        var id: String { rawValue }
    }

    let silenceTimeoutSeconds: Double
    let responseDelaySeconds: Double
    let wordsToInterruptAssistant: Int
    let streamingLatencyPriority: Int

    static func resolve(role: ConversationRole, isOutbound: Bool) -> VoiceExperienceProfile {
        let fastRole = isOutbound || role == .sales || role == .scheduler
        let silenceTimeout: Double

        switch role {
        case .personalAssistant:
            silenceTimeout = fastRole ? 2.0 : 2.5
        case .receptionist, .support:
            silenceTimeout = 3.0
        case .scheduler:
            silenceTimeout = 3.0
        case .sales:
            silenceTimeout = 2.0
        }

        return VoiceExperienceProfile(
            silenceTimeoutSeconds: min(silenceTimeout, fastRole ? 2.0 : 3.0),
            responseDelaySeconds: isOutbound ? 0.45 : 0.0,
            wordsToInterruptAssistant: 2,
            streamingLatencyPriority: 3
        )
    }
}

extension AgentResponseStyle {
    var defaultVoiceRole: VoiceExperienceProfile.ConversationRole {
        switch self {
        case .concise, .direct:
            return .personalAssistant
        case .balanced, .warm:
            return .receptionist
        case .detailed:
            return .support
        case .formal:
            return .scheduler
        }
    }
}
