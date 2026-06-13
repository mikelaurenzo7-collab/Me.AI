import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section("Core") {
                NavigationLink("Agent Studio", destination: AgentStudioView())
                NavigationLink("Activation", destination: ActivationSetupView())
                NavigationLink("Contact rules", destination: ContactRulesView())
            }

            Section("Trust") {
                NavigationLink("Privacy Center", destination: PrivacyCenterView())
                NavigationLink("Confirmations", destination: PendingConfirmationsView())
            }

            Section("Build") {
                LabeledContent("Product", value: "Me.AI")
                LabeledContent("MVP focus", value: "iPhone-first")
                LabeledContent("CarPlay", value: "Extension")
            }
        }
        .navigationTitle("Settings")
    }
}
