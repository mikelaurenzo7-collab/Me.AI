import SwiftUI

struct ContactRulesView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        List {
            Section {
                Text("Tell Me.AI who should ring through, who should be screened, and who can be delegated.")
                    .foregroundStyle(.secondary)
            }

            Section("Rules") {
                ForEach($appState.contactRules) { $rule in
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Name", text: $rule.name)
                            .font(.headline)
                        TextField("Number or group", text: $rule.phoneNumber)
                            .font(.subheadline)
                        Picker("Handling", selection: $rule.handling) {
                            ForEach(ContactRule.Handling.allCases) { handling in
                                Text(handling.label).tag(handling)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Contact rules")
    }
}
