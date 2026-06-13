import Foundation

struct PhoneLineRoutingPolicy {
    static func isTwilioPhoneNumberSid(_ value: String?) -> Bool {
        guard let value else { return false }
        return value.hasPrefix("PN")
    }

    static func isUUIDProviderId(_ value: String?) -> Bool {
        guard let value, !isTwilioPhoneNumberSid(value) else { return false }
        let pattern = #"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }

    static func preferredLine(from lines: [PhoneLineDTO], agentId: String?) -> PhoneLineDTO? {
        let active = lines.filter(\.active)
        if let agentId, let exact = active.first(where: { $0.agentId == agentId }) {
            return exact
        }
        return active.first
    }

    static func displayLabel(for line: PhoneLineDTO?) -> String {
        guard let line else { return "No phone line connected" }
        return "\(line.label) • \(line.e164)"
    }
}
