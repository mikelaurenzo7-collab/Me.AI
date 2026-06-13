import SwiftUI

struct PrivacyCenterView: View {
    @State private var confirmCalls = true
    @State private var confirmMessages = true
    @State private var confirmReminders = true

    var body: some View {
        List {
            Section {
                Text("Control what Me.AI can access, remember, and do.")
                    .foregroundStyle(.secondary)
            }

            Section("Permissions") {
                PrivacyRow(title: "Notifications", detail: "For confirmations and call summaries", status: "Not checked")
                PrivacyRow(title: "Contacts", detail: "For call rules and known caller context", status: "Optional")
                PrivacyRow(title: "Reminders", detail: "For follow-up actions after approval", status: "Optional")
                PrivacyRow(title: "Calendar", detail: "For scheduling context after approval", status: "Optional")
                PrivacyRow(title: "Location", detail: "For route handoffs when requested", status: "Optional")
            }

            Section("Data controls") {
                Button("Export my data") {}
                Button("Clear call history") {}
                Button("Clear transcripts") {}
                Button("Delete account") {}
            }

            Section("Safety") {
                Toggle("Confirm before calls", isOn: $confirmCalls)
                Toggle("Confirm before messages", isOn: $confirmMessages)
                Toggle("Confirm before reminders", isOn: $confirmReminders)
            }
        }
        .navigationTitle("Privacy")
    }
}

struct PrivacyRow: View {
    let title: String
    let detail: String
    let status: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Text(status).font(.caption).foregroundStyle(.secondary)
            }
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}
