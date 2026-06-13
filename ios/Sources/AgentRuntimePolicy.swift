import Foundation

enum RuntimeComplianceMode: String, CaseIterable, Identifiable {
    case none
    case health
    case financial
    case legal
    case privacy

    var id: String { rawValue }
}

struct AvailabilityWindow: Identifiable {
    let id = UUID()
    var weekday: Int
    var opensAt: String
    var closesAt: String
    var isClosed: Bool = false
}

struct AgentRuntimePolicy {
    var timezone: TimeZone = .current
    var availability: [AvailabilityWindow] = []
    var complianceMode: RuntimeComplianceMode = .none
    var disallowedTopics: [String] = []
    var escalationKeywords: [String] = ["emergency", "urgent", "lawsuit", "hospital", "police"]
    var runtimeVariables: [String: String] = [:]
    var outcomeFocus: String = "Protect the user's time and produce clear next steps."

    func isAvailable(now: Date = .now, calendar: Calendar = .current) -> Bool {
        guard !availability.isEmpty else { return true }
        let weekday = calendar.component(.weekday, from: now)
        guard let window = availability.first(where: { $0.weekday == weekday }) else { return true }
        if window.isClosed { return false }
        guard let open = minutes(window.opensAt), let close = minutes(window.closesAt) else { return true }
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let current = hour * 60 + minute
        if close > open { return current >= open && current < close }
        return current >= open || current < close
    }

    func compiledRuntimeBlock(profile: AgentProfile, scenarios: [AgentScenario], scripts: [AgentScript]) -> String {
        [
            "Agent name: \(profile.name)",
            "Response style: \(profile.responseStyle.label)",
            "Voice style: \(profile.voiceStyle)",
            "Outcome focus: \(outcomeFocus)",
            complianceBlock(),
            disallowedTopicsBlock(),
            escalationBlock(),
            scenarioBlock(scenarios),
            scriptBlock(scripts),
            "Confirm before calls, messages, reminders, calendar changes, or sharing private information."
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "\n\n")
    }

    func applyVariables(to text: String) -> String {
        runtimeVariables.reduce(text) { partial, item in
            partial.replacingOccurrences(of: "{\(item.key)}", with: String(item.value.prefix(500)))
        }
    }

    private func minutes(_ hhmm: String) -> Int? {
        let parts = hhmm.split(separator: ":")
        guard parts.count == 2, let hour = Int(parts[0]), let minute = Int(parts[1]) else { return nil }
        guard (0...23).contains(hour), (0...59).contains(minute) else { return nil }
        return hour * 60 + minute
    }

    private func complianceBlock() -> String {
        switch complianceMode {
        case .none:
            return ""
        case .health:
            return "Health-sensitive mode: do not provide medical advice. Offer to take a message or route to a qualified professional."
        case .financial:
            return "Financial-sensitive mode: do not provide investment, tax, or product advice. Offer to route to a qualified professional."
        case .legal:
            return "Legal-sensitive mode: do not provide legal advice. Offer to route to a qualified professional."
        case .privacy:
            return "Privacy-sensitive mode: minimize personal data, avoid repeating sensitive details, and respect opt-out requests."
        }
    }

    private func disallowedTopicsBlock() -> String {
        guard !disallowedTopics.isEmpty else { return "" }
        return "Do not discuss: " + disallowedTopics.prefix(24).joined(separator: ", ")
    }

    private func escalationBlock() -> String {
        guard !escalationKeywords.isEmpty else { return "" }
        return "Escalate or notify the user if these appear: " + escalationKeywords.prefix(24).joined(separator: ", ")
    }

    private func scenarioBlock(_ scenarios: [AgentScenario]) -> String {
        guard !scenarios.isEmpty else { return "" }
        return scenarios.map { scenario in
            "Scenario: \(scenario.name)\nTrigger: \(scenario.trigger)\nGoal: \(scenario.goal)\nEscalation: \(scenario.escalationRule)\nAllowed actions: \(scenario.allowedActions)"
        }.joined(separator: "\n\n")
    }

    private func scriptBlock(_ scripts: [AgentScript]) -> String {
        guard !scripts.isEmpty else { return "" }
        return scripts.map { script in
            "Script: \(script.name)\nPurpose: \(script.purpose)\nUse when: \(script.whenToUse)\nBody: \(applyVariables(to: script.body))"
        }.joined(separator: "\n\n")
    }
}
