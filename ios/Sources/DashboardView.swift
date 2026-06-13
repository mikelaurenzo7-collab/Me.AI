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

                Section("Driving-safe actions") {
                    Button("Delegate active call to Me.AI") {}
                    Button("Start outbound Me.AI call") {}
                    Button("Open native tool permissions") {}
                }
            }
            .navigationTitle("Me.AI")
        }
    }
}
