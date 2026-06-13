import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        NavigationStack {
            ZStack {
                MeAIDesign.darkInk
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hello, Michael")
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)
                                Text("Your Me.AI operator is active")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Image(systemName: "sparkles")
                                      .font(.title2)
                                      .foregroundStyle(MeAIDesign.primaryAccent)
                        }
                        .padding(.top)

                        // Mode Selector Card
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ACCOUNT MODE")
                                .font(.caption.bold())
                                .foregroundStyle(MeAIDesign.primaryAccent)
                            
                            Picker("Account", selection: $appState.accountMode) {
                                ForEach(AccountMode.allCases) { mode in
                                    Text(mode.label).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.compactCornerRadius, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: MeAIDesign.compactCornerRadius).stroke(Color.white.opacity(0.1), lineWidth: 1))

                        // Circular Readiness Gauge Card
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.08), lineWidth: 6)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(appState.readiness.score) / CGFloat(appState.readiness.total))
                                    .stroke(
                                        LinearGradient(colors: [MeAIDesign.primaryAccent, MeAIDesign.secondaryAccent], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                    )
                                    .frame(width: 65, height: 65)
                                    .rotationEffect(.degrees(-90))
                                Text("\(appState.readiness.score)/\(appState.readiness.total)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("System Readiness")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(appState.readiness.nextStep)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius).stroke(Color.white.opacity(0.1), lineWidth: 1))

                        // Agent Configuration Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Agent Studio")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Spacer()
                                NavigationLink("Configure", destination: AgentStudioView())
                                    .font(.subheadline.bold())
                                    .foregroundStyle(MeAIDesign.primaryAccent)
                            }
                            
                            Text("Tune custom greetings, agent voices, safety policies, scenario escalations, and dialog scripts.")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .lineSpacing(3)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius).stroke(Color.white.opacity(0.1), lineWidth: 1))

                        // Actions Panel Card
                        VStack(alignment: .leading, spacing: 14) {
                            Text("IPHONE-FIRST ACTIONS")
                                .font(.caption.bold())
                                .foregroundStyle(MeAIDesign.primaryAccent)
                            
                            Group {
                                NavigationLink(destination: ActivationSetupView()) {
                                    HStack {
                                        Label("Set up activation", systemImage: "mic.fill")
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                }
                                Divider().background(Color.white.opacity(0.08))
                                NavigationLink(destination: SetupFlowView()) {
                                    HStack {
                                        Label("Open setup checklist", systemImage: "checklist")
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                }
                                Divider().background(Color.white.opacity(0.08))
                                NavigationLink(destination: ActiveCallView()) {
                                    HStack {
                                        Label("View active call state", systemImage: "phone.circle.fill")
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                }
                                Divider().background(Color.white.opacity(0.08))
                                NavigationLink(destination: OutboundRequestView()) {
                                    HStack {
                                        Label("Start outbound request", systemImage: "phone.arrow.up.right.fill")
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                }
                                Divider().background(Color.white.opacity(0.08))
                                NavigationLink(destination: PendingConfirmationsView()) {
                                    HStack {
                                        Label("Review confirmations", systemImage: "bell.badge.fill")
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                }
                            }
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius).stroke(Color.white.opacity(0.1), lineWidth: 1))

                        // Calls & Logs Card
                        VStack(alignment: .leading, spacing: 14) {
                            Text("CALL LOGS & DATA")
                                .font(.caption.bold())
                                .foregroundStyle(MeAIDesign.primaryAccent)
                            
                            Group {
                                NavigationLink(destination: CallHistoryView()) {
                                    HStack {
                                        Label("Call history logs", systemImage: "clock.fill")
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                }
                                Divider().background(Color.white.opacity(0.08))
                                NavigationLink(destination: ContactRulesView()) {
                                    HStack {
                                        Label("Contact screening rules", systemImage: "person.crop.circle.badge.exclamationmark")
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                }
                            }
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius).stroke(Color.white.opacity(0.1), lineWidth: 1))

                        // Security & Settings Card
                        VStack(alignment: .leading, spacing: 14) {
                            Text("SECURITY & TRUST")
                                .font(.caption.bold())
                                .foregroundStyle(MeAIDesign.primaryAccent)
                            
                            Group {
                                NavigationLink(destination: PrivacyCenterView()) {
                                    HStack {
                                        Label("Privacy Center", systemImage: "shield.lefthalf.filled")
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                }
                                Divider().background(Color.white.opacity(0.08))
                                NavigationLink(destination: SettingsView()) {
                                    HStack {
                                        Label("Settings", systemImage: "gearshape.fill")
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption)
                                    }
                                }
                            }
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    }
                    .padding()
                }
            }
            .navigationTitle("Me.AI")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}
