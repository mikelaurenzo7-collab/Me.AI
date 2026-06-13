import SwiftUI

struct PendingConfirmationsView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        List {
            if appState.pendingConfirmations.isEmpty {
                ContentUnavailableView("No pending confirmations", systemImage: "checkmark.circle", description: Text("Me.AI will ask before completing sensitive actions."))
            } else {
                ForEach(appState.pendingConfirmations) { confirmation in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(confirmation.title)
                                .font(.headline)
                            Spacer()
                            Text(confirmation.risk)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(confirmation.detail)
                            .foregroundStyle(.secondary)
                        HStack {
                            Button(confirmation.actionLabel) {
                                appState.approve(confirmation)
                            }
                            .buttonStyle(.borderedProminent)

                            Button("Decline", role: .cancel) {
                                appState.decline(confirmation)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Confirmations")
    }
}
