import SwiftUI

struct PrivacyCenterView: View {
    @State private var confirmCalls = true
    @State private var confirmMessages = true
    @State private var confirmReminders = true

    var body: some View {
        ZStack {
            MeAIDesign.darkInk.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Control what Me.AI can access, remember, and do.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    // Permissions Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("DEVICE PERMISSIONS")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        Group {
                            PrivacyRow(title: "Notifications", detail: "For confirmations and call summaries", status: "Not checked")
                            Divider().background(Color.white.opacity(0.1))
                            PrivacyRow(title: "Contacts", detail: "For call rules and known caller context", status: "Optional")
                            Divider().background(Color.white.opacity(0.1))
                            PrivacyRow(title: "Reminders", detail: "For follow-up actions after approval", status: "Optional")
                            Divider().background(Color.white.opacity(0.1))
                            PrivacyRow(title: "Calendar", detail: "For scheduling context after approval", status: "Optional")
                            Divider().background(Color.white.opacity(0.1))
                            PrivacyRow(title: "Location", detail: "For route handoffs when requested", status: "Optional")
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                            .stroke(LinearGradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    )

                    // Safety Controls Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("SAFETY & GUARDRAILS")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        Toggle("Confirm before calls", isOn: $confirmCalls)
                        Divider().background(Color.white.opacity(0.1))
                        Toggle("Confirm before messages", isOn: $confirmMessages)
                        Divider().background(Color.white.opacity(0.1))
                        Toggle("Confirm before reminders", isOn: $confirmReminders)
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                            .stroke(LinearGradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    )
                    .tint(MeAIDesign.primaryAccent)

                    // Data Controls Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("DATA CONTROLS")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        Group {
                            Button("Export my data") {}
                            Divider().background(Color.white.opacity(0.1))
                            Button("Clear call history") {}
                                .foregroundStyle(.red)
                            Divider().background(Color.white.opacity(0.1))
                            Button("Clear transcripts") {}
                                .foregroundStyle(.red)
                            Divider().background(Color.white.opacity(0.1))
                            Button("Delete account") {}
                                .foregroundStyle(.red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                            .stroke(LinearGradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    )
                }
                .padding()
            }
        }
        .navigationTitle("Privacy Center")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

struct PrivacyRow: View {
    let title: String
    let detail: String
    let status: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text(status)
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(status == "Optional" ? Color.blue.opacity(0.15) : Color.gray.opacity(0.15))
                    .foregroundStyle(status == "Optional" ? .blue : .gray)
                    .clipShape(Capsule())
            }
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 4)
    }
}
