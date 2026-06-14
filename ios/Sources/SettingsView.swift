import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            MeAIDesign.darkInk.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Core Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("CORE")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        Group {
                            NavigationLink(destination: AgentStudioView()) {
                                HStack {
                                    Label("Agent Studio", systemImage: "sparkles")
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.caption)
                                }
                            }
                            Divider().background(Color.white.opacity(0.1))
                            NavigationLink(destination: ActivationSetupView()) {
                                HStack {
                                    Label("Activation", systemImage: "bolt.fill")
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.caption)
                                }
                            }
                            Divider().background(Color.white.opacity(0.1))
                            NavigationLink(destination: ContactRulesView()) {
                                HStack {
                                    Label("Contact rules", systemImage: "person.2.fill")
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.caption)
                                }
                            }
                        }
                        .foregroundStyle(.white)
                        .font(.subheadline)
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                            .stroke(LinearGradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    )

                    // Trust Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("TRUST")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        Group {
                            NavigationLink(destination: PrivacyCenterView()) {
                                HStack {
                                    Label("Privacy Center", systemImage: "shield.lefthalf.filled")
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.caption)
                                }
                            }
                            Divider().background(Color.white.opacity(0.1))
                            NavigationLink(destination: PendingConfirmationsView()) {
                                HStack {
                                    Label("Confirmations", systemImage: "bell.badge.fill")
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.caption)
                                }
                            }
                        }
                        .foregroundStyle(.white)
                        .font(.subheadline)
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                            .stroke(LinearGradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    )

                    // Build Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("BUILD")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        Group {
                            LabeledContent("Product", value: "Me.AI")
                            Divider().background(Color.white.opacity(0.1))
                            LabeledContent("MVP focus", value: "iPhone-first")
                            Divider().background(Color.white.opacity(0.1))
                            LabeledContent("CarPlay", value: "Extension")
                        }
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MeAIDesign.cornerRadius)
                            .stroke(LinearGradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    )

                    // Legal Card (App Store Required)
                    VStack(alignment: .leading, spacing: 14) {
                        Text("LEGAL")
                            .font(.caption.bold())
                            .foregroundStyle(MeAIDesign.primaryAccent)
                            .tracking(1.2)
                        
                        Group {
                            Link(destination: URL(string: "https://me.ai/privacy")!) {
                                HStack {
                                    Label("Privacy Policy", systemImage: "hand.raised.fill")
                                    Spacer()
                                    Image(systemName: "arrow.up.right.square").font(.caption)
                                }
                            }
                            Divider().background(Color.white.opacity(0.1))
                            Link(destination: URL(string: "https://me.ai/terms")!) {
                                HStack {
                                    Label("Terms of Service", systemImage: "doc.text.fill")
                                    Spacer()
                                    Image(systemName: "arrow.up.right.square").font(.caption)
                                }
                            }
                        }
                        .foregroundStyle(.gray)
                        .font(.subheadline)
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
        .navigationTitle("Settings")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}
