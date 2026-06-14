import SwiftUI

struct ContactRulesView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        ZStack {
            MeAIDesign.darkInk.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Tell Me.AI who should ring through, who should be screened, and who can be delegated.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    ForEach($appState.contactRules) { $rule in
                        VStack(alignment: .leading, spacing: 16) {
                            
                            VStack(alignment: .leading, spacing: 6) {
                                TextField("Name", text: $rule.name)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                
                                TextField("Number or group", text: $rule.phoneNumber)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            
                            Divider().background(Color.white.opacity(0.1))
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("ACTION")
                                    .font(.caption.bold())
                                    .foregroundStyle(MeAIDesign.primaryAccent)
                                    .tracking(1.2)
                                
                                Picker("Handling", selection: $rule.handling) {
                                    ForEach(ContactRule.Handling.allCases) { handling in
                                        Text(handling.label).tag(handling)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
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
                .padding()
            }
        }
        .navigationTitle("Contact Rules")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
