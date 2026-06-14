import SwiftUI

struct CallHistoryView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        ZStack {
            MeAIDesign.darkInk.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    if appState.recentCalls.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "phone.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(MeAIDesign.primaryAccent.opacity(0.5))
                            Text("No Calls Yet")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                            Text("Me.AI summaries will appear here after calls.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        .padding(40)
                    } else {
                        ForEach(appState.recentCalls) { call in
                            NavigationLink(destination: CallSummaryView(call: call)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(call.contactName)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Text(call.status.label)
                                            .font(.caption.bold())
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.white.opacity(0.1))
                                            .clipShape(Capsule())
                                            .foregroundStyle(.white)
                                    }
                                    
                                    Text(call.summary)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                    
                                    HStack {
                                        Image(systemName: call.direction == .inbound ? "arrow.down.left" : "arrow.up.right")
                                            .foregroundStyle(call.direction == .inbound ? .green : .blue)
                                        Text(call.phoneNumber)
                                        Spacer()
                                        Text(call.createdAt, style: .time)
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                }
                                .padding()
                                .background(Color.white.opacity(0.03))
                                .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Call History")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct CallSummaryView: View {
    let call: MeAICallSummary

    var body: some View {
        ZStack {
            MeAIDesign.darkInk.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Call Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CALL DETAILS")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        DetailRow(label: "Contact", value: call.contactName)
                        DetailRow(label: "Number", value: call.phoneNumber)
                        DetailRow(label: "Direction", value: call.direction.label)
                        DetailRow(label: "Status", value: call.status.label)
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    // Summary Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SUMMARY")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        Text(call.summary)
                            .font(.body)
                            .foregroundStyle(.white)
                            .lineSpacing(4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )

                    // Outcome Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("OUTCOME")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        Text(call.outcome)
                            .font(.body)
                            .foregroundStyle(.white)
                            .lineSpacing(4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                }
                .padding()
            }
        }
        .navigationTitle("Summary")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.gray)
            Spacer()
            Text(value)
                .foregroundStyle(.white)
        }
        .font(.subheadline)
        .padding(.vertical, 4)
    }
}
