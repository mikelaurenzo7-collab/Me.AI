import SwiftUI

struct CallHistoryView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        List {
            if appState.recentCalls.isEmpty {
                ContentUnavailableView("No calls yet", systemImage: "phone", description: Text("Me.AI summaries will appear here after calls."))
            } else {
                ForEach(appState.recentCalls) { call in
                    NavigationLink(destination: CallSummaryView(call: call)) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(call.contactName).font(.headline)
                                Spacer()
                                Text(call.status.label)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Text(call.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                            HStack {
                                Text(call.direction.label)
                                Text(call.phoneNumber)
                                Spacer()
                                Text(call.createdAt, style: .time)
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .navigationTitle("Call history")
    }
}

struct CallSummaryView: View {
    let call: MeAICallSummary

    var body: some View {
        List {
            Section("Call") {
                LabeledContent("Contact", value: call.contactName)
                LabeledContent("Number", value: call.phoneNumber)
                LabeledContent("Direction", value: call.direction.label)
                LabeledContent("Status", value: call.status.label)
            }

            Section("Summary") {
                Text(call.summary)
            }

            Section("Outcome") {
                Text(call.outcome)
            }
        }
        .navigationTitle("Summary")
    }
}
