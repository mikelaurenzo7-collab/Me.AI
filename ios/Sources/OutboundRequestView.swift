import SwiftUI

struct OutboundRequestView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        Form {
            Section {
                TextField("Recipient or phone number", text: $appState.outboundDraft.recipient)
                    .textContentType(.telephoneNumber)
                TextField("What should Me.AI accomplish?", text: $appState.outboundDraft.objective, axis: .vertical)
                    .lineLimit(3...6)
                Toggle("Confirm before dialing", isOn: $appState.outboundDraft.shouldConfirmBeforeDialing)
            } header: {
                Text("Call request")
            } footer: {
                Text("Me.AI should never place sensitive calls without a clear objective and confirmation.")
            }

            Section {
                Button("Prepare call request") {
                    prepareDemoRequest()
                }
                .disabled(appState.outboundDraft.recipient.isEmpty || appState.outboundDraft.objective.isEmpty)
            }
        }
        .navigationTitle("Outbound request")
    }

    private func prepareDemoRequest() {
        let confirmation = PendingConfirmation(
            id: UUID().uuidString,
            title: "Place outbound call",
            detail: "Call \(appState.outboundDraft.recipient) and \(appState.outboundDraft.objective)",
            actionLabel: "Approve call",
            risk: "Places a call"
        )
        appState.pendingConfirmations.insert(confirmation, at: 0)
    }
}
