import SwiftUI

struct SetupFlowView: View {
    let steps: [SetupStep] = [
        .init(title: "Choose mode", detail: "Start personal. Upgrade to business when needed."),
        .init(title: "Connect phone line", detail: "Attach or provision the number Me.AI can handle."),
        .init(title: "Enable Siri", detail: "Start safe requests hands-free."),
        .init(title: "Allow notifications", detail: "Receive confirmations and summaries."),
        .init(title: "Enable native tools", detail: "Maps, reminders, and message drafts stay permissioned.")
    ]

    var body: some View {
        List {
            Section {
                ForEach(steps) { step in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(step.title).font(.headline)
                        Text(step.detail).font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            } footer: {
                Text("Me.AI works best when phone, Siri, notifications, and native tool permissions are configured.")
            }
        }
        .navigationTitle("Set up Me.AI")
    }
}

struct SetupStep: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
}
