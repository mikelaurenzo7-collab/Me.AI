import SwiftUI

struct MeAIAppShell: View {
    @StateObject private var appState = MeAIAppState()

    var body: some View {
        DashboardView()
            .environmentObject(appState)
    }
}

@MainActor
final class MeAIAppState: ObservableObject {
    @Published var accountMode: AccountMode = .personal
    @Published var readiness: AgentReadiness = .init(score: 2, total: 6, nextStep: "Connect a phone number")
}
