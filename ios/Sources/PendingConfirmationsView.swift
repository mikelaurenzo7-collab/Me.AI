import SwiftUI

struct PendingConfirmationsView: View {
    @EnvironmentObject private var appState: MeAIAppState
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            MeAIDesign.darkInk.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    if appState.pendingConfirmations.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(appState.pendingConfirmations) { confirmation in
                            confirmationCard(for: confirmation)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Action Queue")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
    
    // MARK: - Subviews
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .scaleEffect(isPulsing ? 1.05 : 0.95)
                
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(Color.green)
                    .symbolEffect(.bounce, options: .repeating)
            }
            .padding(.top, 60)
            
            Text("System All Clear")
                .font(.title2.weight(.heavy))
                .foregroundStyle(.white)
            
            Text("Me.AI will intelligently surface sensitive action requests here for your secure cryptographic approval.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }
    
    private func confirmationCard(for confirmation: ConfirmationRequest) -> some View {
        let isHighRisk = confirmation.risk == "High"
        
        return VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(confirmation.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("Requires Authorization")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: isHighRisk ? "exclamationmark.triangle.fill" : "lock.fill")
                    Text(confirmation.risk)
                }
                .font(.caption.bold())
                .foregroundStyle(isHighRisk ? .red : .orange)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background((isHighRisk ? Color.red : Color.orange).opacity(0.15))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(isHighRisk ? Color.red.opacity(0.3) : Color.orange.opacity(0.3), lineWidth: 1)
                )
            }
            
            Text(confirmation.detail)
                .font(.subheadline)
                .lineSpacing(4)
                .foregroundStyle(Color(white: 0.8))
                .padding(.vertical, 4)
            
            HStack(spacing: 12) {
                Button(action: {
                    triggerHaptic()
                    appState.approve(confirmation)
                }) {
                    Label(confirmation.actionLabel, systemImage: "checkmark.circle.fill")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(isHighRisk ? Color.red : MeAIDesign.primaryAccent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: (isHighRisk ? Color.red : MeAIDesign.primaryAccent).opacity(0.3), radius: isHighRisk ? 8 : 4, x: 0, y: 4)
                }

                Button(action: {
                    triggerHaptic(style: .rigid)
                    appState.decline(confirmation)
                }) {
                    Label("Decline", systemImage: "xmark.circle.fill")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.06))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.02))
        .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: isHighRisk ? [Color.red.opacity(0.5), Color.red.opacity(0.1)] : [Color.white.opacity(0.15), Color.white.opacity(0.03)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isHighRisk ? 1.5 : 1
                )
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Helpers
    
    private func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
