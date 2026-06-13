import SwiftUI

struct SignalBackground: View {
    @State private var waveAnimation = false

    var body: some View {
        ZStack {
            // Base background
            MeAIDesign.darkInk
                .ignoresSafeArea()

            // Dynamic ambient gradient wash
            RadialGradient(
                colors: [
                    MeAIDesign.secondaryAccent.opacity(0.12),
                    MeAIDesign.primaryAccent.opacity(0.04),
                    .clear
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 600
            )
            .ignoresSafeArea()
            
            // Kinetic signal wave rings simulating active voice state
            ZStack {
                Circle()
                    .stroke(MeAIDesign.primaryAccent.opacity(0.15), lineWidth: 1.5)
                    .scaleEffect(waveAnimation ? 2.2 : 0.8)
                    .opacity(waveAnimation ? 0.0 : 0.7)
                
                Circle()
                    .stroke(MeAIDesign.secondaryAccent.opacity(0.10), lineWidth: 1.0)
                    .scaleEffect(waveAnimation ? 3.0 : 1.2)
                    .opacity(waveAnimation ? 0.0 : 0.5)

                Circle()
                    .stroke(MeAIDesign.primaryAccent.opacity(0.08), lineWidth: 1.0)
                    .scaleEffect(waveAnimation ? 1.5 : 0.5)
                    .opacity(waveAnimation ? 0.0 : 0.8)
            }
            .frame(width: 200, height: 200)
            .position(x: UIScreen.main.bounds.width * 0.85, y: 120)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 8.0)
                    .repeatForever(autoreverses: false)
                ) {
                    waveAnimation = true
                }
            }
        }
    }
}

#Preview {
    SignalBackground()
}
