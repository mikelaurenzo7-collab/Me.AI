import SwiftUI
import WidgetKit

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
    @Published var isCallTransferring = false

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

    private var apiClient = APIClient(baseURL: AppConfiguration.local.apiBaseURL)

    init() {
        publishWidgetSnapshot()
        Task {
            await autoAuthenticate()
        }
    }

    func autoAuthenticate() async {
        let store = KeychainStore(service: "com.meai.app")
        if let cachedToken = try? store.read(account: "authToken"), !cachedToken.isEmpty {
            apiClient.token = cachedToken
            print("Found cached Me.AI token in Keychain, verifying session...")
            do {
                _ = try await apiClient.fetchCallHistory()
                print("Session validated successfully with cached token")
                fetchPendingConfirmations()
                fetchCallHistory()
                return
            } catch {
                print("Cached token invalid or server offline. Retrying registration...")
            }
        }

        do {
            let data = try await apiClient.register(email: "michael@me.ai", displayName: "Michael Laurenzo", mode: accountMode)
            let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
            apiClient.token = response.token
            try? store.save(response.token, account: "authToken")
            print("Successfully authenticated and cached Me.AI client session token in Keychain")
            fetchPendingConfirmations()
            fetchCallHistory()
        } catch {
            print("Warning: local backend connection unavailable, relying on default mock records. \(error)")
        }
    }

    func fetchPendingConfirmations() {
        Task {
            do {
                let data = try await apiClient.fetchPendingConfirmations()
                let response = try JSONDecoder().decode(PendingToolsResponse.self, from: data)
                await MainActor.run {
                    self.pendingConfirmations = response.events.map { event in
                        let title = event.request?["title"] ?? "Confirmation requested"
                        let detail = event.request?["detail"] ?? "The agent requires user confirmation for a tool action (\(event.toolName))."
                        let actionLabel = event.request?["actionLabel"] ?? "Approve"
                        let risk = event.request?["risk"] ?? "Standard action"
                        return PendingConfirmation(
                            id: event.id,
                            title: title,
                            detail: detail,
                            actionLabel: actionLabel,
                            risk: risk
                        )
                    }
                    self.publishWidgetSnapshot()
                }
            } catch {
                print("Failed to fetch pending confirmations: \(error)")
            }
        }
    }

    func fetchCallHistory() {
        Task {
            do {
                let data = try await apiClient.fetchCallHistory()
                let response = try JSONDecoder().decode(CallsResponse.self, from: data)
                let formatter = ISO8601DateFormatter()
                await MainActor.run {
                    self.recentCalls = response.calls.map { dto in
                        let direction = CallDirection(rawValue: dto.direction) ?? .inbound
                        let status = CallStatus(rawValue: dto.status) ?? .completed
                        let date = formatter.date(from: dto.createdAt) ?? .now
                        let outcome = dto.outcome ?? (dto.status == "completed" ? "Screened successfully" : dto.status.capitalized)
                        return MeAICallSummary(
                            id: dto.id,
                            direction: direction,
                            status: status,
                            contactName: dto.fromNumber == "+16305550199" ? "Me.AI Operator Line" : (dto.direction == "inbound" ? "Unknown Caller" : (dto.toNumber ?? "Unknown")),
                            phoneNumber: dto.direction == "inbound" ? (dto.fromNumber ?? "Unknown") : (dto.toNumber ?? "Unknown"),
                            summary: dto.summary ?? "Active caller screening context.",
                            outcome: outcome,
                            createdAt: date
                        )
                    }
                    self.publishWidgetSnapshot()
                }
            } catch {
                print("Failed to fetch call history: \(error)")
            }
        }
    }

    func queueOutboundCall(to number: String, objective: String) {
        Task {
            do {
                _ = try await apiClient.queueOutboundCall(to: number, objective: objective, source: "app")
                fetchPendingConfirmations()
                fetchCallHistory()
            } catch {
                print("Failed to queue outbound call: \(error)")
            }
        }
    }

    func takeoverActiveCall(callId: String) {
        isCallTransferring = true
        publishWidgetSnapshot()
        Task {
            do {
                let url = AppConfiguration.local.apiBaseURL.appending(path: "/api/calls/\(callId)/takeover")
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                if let token = apiClient.token, !token.isEmpty {
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                let (_, response) = try await URLSession.shared.data(for: request)
                guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                try await Task.sleep(nanoseconds: 2_000_000_000)
                
                await MainActor.run {
                    self.isCallTransferring = false
                    self.publishWidgetSnapshot()
                    self.fetchCallHistory()
                    self.fetchPendingConfirmations()
                }
            } catch {
                print("Failed to takeover active call: \(error)")
                await MainActor.run {
                    self.isCallTransferring = false
                    self.publishWidgetSnapshot()
                }
            }
        }
    }

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
        publishWidgetSnapshot()
    }

    func approve(_ confirmation: PendingConfirmation) {
        pendingConfirmations.removeAll { $0.id == confirmation.id }
        publishWidgetSnapshot()
        Task {
            do {
                _ = try await apiClient.approveToolEvent(id: confirmation.id)
                fetchPendingConfirmations()
                fetchCallHistory()
            } catch {
                print("Failed to approve tool confirmation \(confirmation.id): \(error)")
            }
        }
    }

    func decline(_ confirmation: PendingConfirmation) {
        pendingConfirmations.removeAll { $0.id == confirmation.id }
        publishWidgetSnapshot()
        Task {
            do {
                _ = try await apiClient.declineToolEvent(id: confirmation.id)
                fetchPendingConfirmations()
                fetchCallHistory()
            } catch {
                print("Failed to decline tool confirmation \(confirmation.id): \(error)")
            }
        }
    }

    private func publishWidgetSnapshot() {
        let defaults = UserDefaults(suiteName: "group.com.meai.shared")
        defaults?.set(readiness.score, forKey: "readinessScore")
        defaults?.set(readiness.total, forKey: "readinessTotal")
        defaults?.set(readiness.nextStep, forKey: "readinessNextStep")
        defaults?.set(pendingConfirmations.count, forKey: "pendingConfirmations")
        defaults?.set(widgetCallStatus, forKey: "activeCallStatus")
        WidgetCenter.shared.reloadTimelines(ofKind: "MeAIOperatorStatusWidget")
    }

    private var widgetCallStatus: String {
        if isCallTransferring {
            return "Transferring active call to you"
        }
        if let activeCall = recentCalls.first(where: { $0.status == .active || $0.status == .ringing }) {
            return "\(activeCall.status.label): \(activeCall.contactName)"
        }
        return "Operator ready to screen calls"
    }
}
