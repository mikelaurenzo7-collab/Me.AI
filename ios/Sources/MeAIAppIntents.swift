import AppIntents
import Foundation

struct StartMeAICallIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Me.AI Call"
    static var description = IntentDescription("Ask Me.AI to prepare an outbound call after confirmation.")

    @Parameter(title: "Number") var number: String
    @Parameter(title: "Purpose") var purpose: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "Me.AI is preparing the call request. Confirm in the app before dialing.")
    }
}

struct DelegateToMeAIIntent: AppIntent {
    static var title: LocalizedStringResource = "Delegate to Me.AI"
    static var description = IntentDescription("Ask Me.AI to handle a call with CallKit and backend routing.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "Me.AI delegation requested.")
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
        .result(dialog: "Me.AI will ask for confirmation before completing sensitive actions.")
    }
}

struct SummarizeLastCallIntent: AppIntent {
    static var title: LocalizedStringResource = "Summarize Last Me.AI Call"
    static var description = IntentDescription("Ask Me.AI for the most recent call summary.")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "Me.AI will show the latest summary when call history is connected.")
    }
}

struct CreateMeAIRequestIntent: AppIntent {
    static var title: LocalizedStringResource = "Create Me.AI Request"
    static var description = IntentDescription("Create a general Me.AI request from Siri, widgets, Back Tap, or Action Button.")

    @Parameter(title: "Request") var request: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "Me.AI request created.")
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
