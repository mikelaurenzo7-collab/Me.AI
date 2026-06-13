import SwiftUI

struct ActivationSetupView: View {
    let methods: [ActivationMethod] = [
        .init(title: "Siri", detail: "Say: Ask Me.AI", status: "Works through App Shortcuts"),
        .init(title: "Action Button", detail: "Long-press to open or ask Me.AI", status: "User-configured shortcut"),
        .init(title: "Back Tap", detail: "Double tap your iPhone to create a request", status: "Accessibility shortcut"),
        .init(title: "Lock Screen Widget", detail: "Review confirmations and summaries", status: "WidgetKit target planned"),
        .init(title: "Home Screen Widget", detail: "Start a Me.AI request quickly", status: "WidgetKit target planned"),
        .init(title: "CarPlay", detail: "Safe driving surface when available", status: "Nice-to-have extension")
    ]

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Activate Me.AI anywhere")
                        .font(.title2.bold())
                    Text("Start with Siri and iPhone shortcuts. CarPlay can be added when available, but the iPhone experience comes first.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section("Activation methods") {
                ForEach(methods) { method in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(method.title).font(.headline)
                            Spacer()
                            Text(method.status)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(method.detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Activation")
    }
}

struct ActivationMethod: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let status: String
}
