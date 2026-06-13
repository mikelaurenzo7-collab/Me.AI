import Foundation

struct RegisterResponse: Codable {
    let token: String
    let workspace: WorkspaceDTO?
}

struct WorkspaceDTO: Codable {
    let account: AccountDTO
    let user: UserDTO
    let agents: [AgentDTO]
    let phoneLines: [PhoneLineDTO]
}

struct AccountDTO: Codable, Identifiable {
    let id: String
    let mode: String
    let name: String
    let createdAt: String
    let updatedAt: String
}

struct UserDTO: Codable, Identifiable {
    let id: String
    let accountId: String
    let email: String
    let displayName: String
    let role: String
    let createdAt: String
}

struct AgentDTO: Codable, Identifiable {
    let id: String
    let accountId: String
    let mode: String
    let name: String
    let active: Bool
    let voice: String
    let voiceStyle: String?
    let responseStyle: String?
    let systemInstructions: String
    let welcomeMessage: String
    let aiDisclosure: String?
    let trainingNotes: String?
    let createdAt: String
    let updatedAt: String
}

struct PhoneLineDTO: Codable, Identifiable {
    let id: String
    let accountId: String
    let agentId: String
    let e164: String
    let label: String
    let active: Bool
    let createdAt: String
}

struct CallsResponse: Codable {
    let calls: [CallDTO]
}

struct CallDTO: Codable, Identifiable {
    let id: String
    let accountId: String
    let agentId: String
    let phoneLineId: String?
    let direction: String
    let status: String
    let fromNumber: String?
    let toNumber: String?
    let transcript: String?
    let summary: String?
    let outcome: String?
    let createdAt: String
    let updatedAt: String
}

struct PendingToolsResponse: Codable {
    let events: [ToolEventDTO]
}

struct ToolEventDTO: Codable, Identifiable {
    let id: String
    let accountId: String
    let callLogId: String?
    let toolName: String
    let status: String
    let createdAt: String
    let updatedAt: String
}
