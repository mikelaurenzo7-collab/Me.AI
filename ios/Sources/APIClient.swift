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

    func fetchCallHistory() async throws -> Data {
        try await get(path: "/api/calls/history")
    }

    func fetchPendingConfirmations() async throws -> Data {
        try await get(path: "/api/tools/pending")
    }

    func approveToolEvent(id: String) async throws -> Data {
        try await post(path: "/api/tools/\(id)/approve", body: [:])
    }

    func declineToolEvent(id: String) async throws -> Data {
        try await post(path: "/api/tools/\(id)/decline", body: [:])
    }

    private func get(path: String) async throws -> Data {
        var request = URLRequest(url: endpoint(path))
        request.httpMethod = "GET"
        addHeaders(to: &request)
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response)
        return data
    }

    private func post(path: String, body: [String: String]) async throws -> Data {
        var request = URLRequest(url: endpoint(path))
        request.httpMethod = "POST"
        addHeaders(to: &request)
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response)
        return data
    }

    private func endpoint(_ path: String) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) ?? URLComponents()
        let basePath = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let requestPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let joined = [basePath, requestPath].filter { !$0.isEmpty }.joined(separator: "/")
        components.path = "/" + joined
        return components.url ?? baseURL
    }

    private func addHeaders(to request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200..<300).contains(http.statusCode) else {
            throw APIClientError.requestFailed(statusCode: http.statusCode)
        }
    }
}

enum APIClientError: Error {
    case requestFailed(statusCode: Int)
}
