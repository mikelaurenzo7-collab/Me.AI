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

struct MeAIShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: StartMeAICallIntent(), phrases: ["Ask \.applicationName to start a call", "Tell \.applicationName to place a call"], shortTitle: "Start Call", systemImageName: "phone.arrow.up.right")
        AppShortcut(intent: DelegateToMeAIIntent(), phrases: ["Route this to \.applicationName", "Ask \.applicationName to handle this"], shortTitle: "Delegate", systemImageName: "person.wave.2")
    }
}
