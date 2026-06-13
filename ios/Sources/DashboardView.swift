import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        NavigationStack {
            List {
                Section("Mode") {
                    Picker("Account", selection: $appState.accountMode) {
                        ForEach(AccountMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                }

                Section("Readiness") {
                    HStack {
                        Text("Score")
                        Spacer()
                        Text("\(appState.readiness.score)/\(appState.readiness.total)")
                    }
                    Text(appState.readiness.nextStep)
                        .foregroundStyle(.secondary)
                }

                Section("Agent") {
                    NavigationLink("Agent Studio", destination: AgentStudioView())
                    Text("Customize name, voice, response style, training, scenarios, and scripts.")
                        .foregroundStyle(.secondary)
                }

                Section("iPhone-first actions") {
                    NavigationLink("Set up activation", destination: ActivationSetupView())
                    NavigationLink("Open setup checklist", destination: SetupFlowView())
                    NavigationLink("View active call state", destination: ActiveCallView())
                    NavigationLink("Start outbound request", destination: OutboundRequestView())
                    NavigationLink("Review confirmations", destination: PendingConfirmationsView())
                }

                Section("Calls") {
                    NavigationLink("Call history", destination: CallHistoryView())
                    NavigationLink("Contact rules", destination: ContactRulesView())
                }

                Section("CarPlay") {
                    Text("CarPlay is a premium extension. The iPhone experience comes first.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Me.AI")
        }
    }
}
