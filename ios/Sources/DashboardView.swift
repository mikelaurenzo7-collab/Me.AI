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

                Section("iPhone-first actions") {
                    NavigationLink("Set up activation", destination: ActivationSetupView())
                    NavigationLink("Open setup checklist", destination: SetupFlowView())
                    NavigationLink("View active call state", destination: ActiveCallView())
                    Button("Start outbound Me.AI request") {}
                    Button("Review pending confirmations") {}
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
