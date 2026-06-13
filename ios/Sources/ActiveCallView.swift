import SwiftUI

struct ActiveCallView: View {
    @EnvironmentObject private var appState: MeAIAppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            SignalBackground()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header Status
                    VStack(spacing: 8) {
                        Image(systemName: "waveform.and.mic")
                            .font(.system(size: 44))
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .symbolEffect(.bounce.up, options: .repeating)
                        
                        Text("Active Screening")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                        
                        Text("Me.AI is protecting your attention")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.top, 40)
                    
                    // Main Screening Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Current Caller Context")
                                .font(.headline)
                                .foregroundStyle(MeAIDesign.primaryAccent)
                            Spacer()
                            HStack(spacing: 4) {
                                Circle().fill(.green).frame(width: 8, height: 8)
                                Text("LIVE").font(.caption.bold()).foregroundStyle(.green)
                            }
                        }
                        
                        Text("“Hi, this is Me.AI. I can help route the call. What is this regarding? ... The caller indicates they are asking for availability to schedule a callback window.”")
                            .font(.body)
                            .foregroundStyle(.white)
                            .lineSpacing(4)
                        
                        Text("Full transcript and audio logs will be available under history once complete.")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.top, 4)
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                appState.takeoverActiveCall(callId: appState.recentCalls.first?.id ?? "demo-1")
                                Task {
                                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                                    dismiss()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text("Take over")
                                }
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(MeAIDesign.primaryAccent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            
                            Button(action: { dismiss() }) {
                                Text("Keep screening")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    .padding(20)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    
                    // Quick Handoff/Confirmation Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 8) {
                            Image(systemName: "bell.badge.fill")
                                .foregroundStyle(MeAIDesign.secondaryAccent)
                            Text("Pending Action Suggestion")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        
                        Text("Me.AI detected a request to schedule a follow-up. Create a return call reminder tomorrow morning?")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                if let confirmation = appState.pendingConfirmations.first(where: { $0.id == "confirm-2" }) {
                                    appState.approve(confirmation)
                                }
                                dismiss()
                            }) {
                                Text("Approve reminder")
                                    .font(.subheadline.bold())
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(MeAIDesign.secondaryAccent)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            Button(action: {
                                if let confirmation = appState.pendingConfirmations.first(where: { $0.id == "confirm-2" }) {
                                    appState.decline(confirmation)
                                }
                                dismiss()
                            }) {
                                Text("Decline")
                                    .font(.subheadline)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.08))
                                    .foregroundStyle(.white.opacity(0.7))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(20)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                }
                .padding(20)
            }
            
            if appState.isCallTransferring {
                ZStack {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 24) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: MeAIDesign.primaryAccent))
                            .scaleEffect(1.8)
                        
                        VStack(spacing: 8) {
                            Text("Call Handoff Initiated")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("Transferring call securely to Michael's phone...")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        
                        HStack(spacing: 8) {
                            Circle().fill(.green)
                                .frame(width: 8, height: 8)
                            Text("Warm Transfer Active")
                                .font(.caption.bold())
                                .foregroundStyle(.green)
                        }
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(radius: 20)
                }
                .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
    }
}
