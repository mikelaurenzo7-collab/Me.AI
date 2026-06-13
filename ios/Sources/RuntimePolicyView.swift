import SwiftUI

struct RuntimePolicyView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        Form {
            Section("Availability") {
                LabeledContent("Current status", value: appState.runtimePolicy.isAvailable() ? "Available" : "Outside hours")
                Text("Availability rules are optional for personal mode and stricter for business mode later.")
                    .foregroundStyle(.secondary)
            }

            Section("Sensitive mode") {
                Picker("Mode", selection: $appState.runtimePolicy.complianceMode) {
                    ForEach(RuntimeComplianceMode.allCases) { mode in
                        Text(mode.rawValue.capitalized).tag(mode)
                    }
                }
            }

            Section("Escalation keywords") {
                ForEach(appState.runtimePolicy.escalationKeywords, id: \.self) { keyword in
                    Text(keyword)
                }
            }

            Section("Runtime preview") {
                Text(appState.runtimePolicy.compiledRuntimeBlock(
                    profile: appState.agentProfile,
                    scenarios: appState.scenarios,
                    scripts: appState.scripts
                ))
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Runtime Policy")
    }
}
