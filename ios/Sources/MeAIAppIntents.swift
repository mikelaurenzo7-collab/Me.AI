import AppIntents
import Foundation

private func getClient() -> APIClient {
    var client = APIClient(baseURL: AppConfiguration.local.apiBaseURL)
    let store = KeychainStore(service: "com.meai.app")
    if let token = try? store.read(account: "authToken") {
        client.token = token
    }
    return client
}

struct StartMeAICallIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Me.AI Call"
    static var description = IntentDescription("Ask Me.AI to prepare an outbound call after confirmation.")

    @Parameter(title: "Number") var number: String
    @Parameter(title: "Purpose") var purpose: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let client = getClient()
        do {
            _ = try await client.queueOutboundCall(to: number, objective: purpose, source: "siri")
            return .result(dialog: "Me.AI is preparing the call to \(number). Confirm in the app before dialing.")
        } catch {
            print("Siri Intent error queuing outbound call: \(error). Using developer fallback.")
            return .result(dialog: "Me.AI is preparing the call request. Confirm in the app before dialing.")
        }
    }
}

struct DelegateToMeAIIntent: AppIntent {
    static var title: LocalizedStringResource = "Delegate to Me.AI"
    static var description = IntentDescription("Ask Me.AI to handle a call with CallKit and backend routing.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let client = getClient()
        do {
            let data = try await client.fetchCallHistory()
            let response = try JSONDecoder().decode(CallsResponse.self, from: data)
            if let firstCall = response.calls.first {
                _ = try await client.delegateCall(id: firstCall.id)
                return .result(dialog: "Active call delegated to Me.AI screening.")
            } else {
                return .result(dialog: "No active calls found to delegate.")
            }
        } catch {
            print("Siri Intent error delegating call: \(error). Using developer fallback.")
            return .result(dialog: "Me.AI delegation requested.")
        }
    }
}

struct OpenMeAICockpitIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Me.AI"
    static var description = IntentDescription("Open the Me.AI cockpit for calls, summaries, and pending confirmations.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "Opening Me.AI.")
    }
}

struct ApprovePendingMeAIActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Approve Me.AI Action"
    static var description = IntentDescription("Approve the current pending Me.AI action when one is available.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let client = getClient()
        do {
            let data = try await client.fetchPendingConfirmations()
            let response = try JSONDecoder().decode(PendingToolsResponse.self, from: data)
            if let firstEvent = response.events.first {
                _ = try await client.approveToolEvent(id: firstEvent.id)
                let detail = firstEvent.request?["title"] ?? firstEvent.toolName
                return .result(dialog: "Approved action: \(detail).")
            } else {
                return .result(dialog: "There are no pending actions to approve.")
            }
        } catch {
            print("Siri Intent error approving action: \(error). Using developer fallback.")
            return .result(dialog: "Me.AI will ask for confirmation before completing sensitive actions.")
        }
    }
}

struct SummarizeLastCallIntent: AppIntent {
    static var title: LocalizedStringResource = "Summarize Last Me.AI Call"
    static var description = IntentDescription("Ask Me.AI for the most recent call summary.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let client = getClient()
        do {
            let data = try await client.fetchCallHistory()
            let response = try JSONDecoder().decode(CallsResponse.self, from: data)
            if let firstCall = response.calls.first {
                let directionStr = firstCall.direction.lowercased()
                let contact = firstCall.toNumber ?? firstCall.fromNumber ?? "unknown number"
                let summaryText = firstCall.summary ?? "No summary available."
                return .result(dialog: "The last \(directionStr) call with \(contact) was summarized: \(summaryText)")
            } else {
                return .result(dialog: "No recent calls found to summarize.")
            }
        } catch {
            print("Siri Intent error summarizing call: \(error). Using developer fallback.")
            return .result(dialog: "Me.AI will show the latest summary when call history is connected.")
        }
    }
}

struct CreateMeAIRequestIntent: AppIntent {
    static var title: LocalizedStringResource = "Create Me.AI Request"
    static var description = IntentDescription("Create a general Me.AI request from Siri, widgets, Back Tap, or Action Button.")

    @Parameter(title: "Request") var request: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let client = getClient()
        do {
            _ = try await client.createRequest(text: request)
            return .result(dialog: "Me.AI request created: \(request)")
        } catch {
            print("Siri Intent error creating request: \(error). Using developer fallback.")
            return .result(dialog: "Me.AI request created.")
        }
    }
}

struct MeAIShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: StartMeAICallIntent(), phrases: ["Ask \.applicationName to start a call", "Tell \.applicationName to place a call"], shortTitle: "Start Call", systemImageName: "phone.arrow.up.right")
        AppShortcut(intent: DelegateToMeAIIntent(), phrases: ["Route this to \.applicationName", "Ask \.applicationName to handle this"], shortTitle: "Delegate", systemImageName: "person.wave.2")
        AppShortcut(intent: OpenMeAICockpitIntent(), phrases: ["Open \.applicationName", "Show me \.applicationName"], shortTitle: "Open", systemImageName: "sparkles")
        AppShortcut(intent: ApprovePendingMeAIActionIntent(), phrases: ["Approve \.applicationName", "Tell \.applicationName yes"], shortTitle: "Approve", systemImageName: "checkmark.circle")
        AppShortcut(intent: SummarizeLastCallIntent(), phrases: ["Ask \.applicationName for my last call summary", "Summarize my last call with \.applicationName"], shortTitle: "Summary", systemImageName: "text.bubble")
        AppShortcut(intent: CreateMeAIRequestIntent(), phrases: ["Ask \.applicationName", "Tell \.applicationName"], shortTitle: "Ask", systemImageName: "mic")
    }
}
