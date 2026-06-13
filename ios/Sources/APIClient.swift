import Foundation

struct APIClient {
    let baseURL: URL
    var token: String?

    func register(email: String, displayName: String, mode: AccountMode) async throws -> Data {
        let body: [String: String] = [
            "email": email,
            "displayName": displayName,
            "mode": mode.rawValue,
            "name": mode == .personal ? "Me.AI Personal" : "Me.AI Business"
        ]
        return try await post(path: "/api/auth/register", body: body)
    }

    func createRealtimeSession() async throws -> Data {
        try await post(path: "/api/openai/realtime/session", body: [:])
    }

    func queueOutboundCall(to number: String, objective: String, source: String) async throws -> Data {
        try await post(path: "/api/calls/outbound", body: ["toNumber": number, "spokenObjective": objective, "source": source])
    }

    private func post(path: String, body: [String: String]) async throws -> Data {
        var request = URLRequest(url: baseURL.appending(path: path))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
