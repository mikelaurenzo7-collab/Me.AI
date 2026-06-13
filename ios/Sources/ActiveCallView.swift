import SwiftUI

struct ActiveCallView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Me.AI is screening")
                        .font(.title2.bold())
                    Text("Caller context appears here as short notes only. Full transcripts stay outside CarPlay.")
                        .foregroundStyle(.secondary)
                    HStack {
                        Button("Take over") {}
                            .buttonStyle(.borderedProminent)
                        Button("Keep screening") {}
                            .buttonStyle(.bordered)
                    }
                }
                .padding(.vertical, 8)
            }

            Section("Needs confirmation") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create reminder after call?")
                    HStack {
                        Button("Approve") {}
                        Button("Decline", role: .cancel) {}
                    }
                }
            }
        }
        .navigationTitle("Active call")
    }
}
