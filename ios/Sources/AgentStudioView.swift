import SwiftUI

struct AgentStudioView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Customize how Me.AI represents you")
                        .font(.title2.bold())
                    Text("Tune the agent's name, voice, response style, training notes, runtime policies, scenarios, and scripts.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section("Studio") {
                NavigationLink("Identity and voice", destination: AgentIdentityView())
                NavigationLink("Behavior and training", destination: AgentTrainingView())
                NavigationLink("Runtime policy", destination: RuntimePolicyView())
                NavigationLink("Scenarios", destination: AgentScenariosView())
                NavigationLink("Scripts", destination: AgentScriptsView())
                NavigationLink("Test prompt", destination: AgentTestPromptView())
            }
        }
        .navigationTitle("Agent Studio")
    }
}

struct AgentIdentityView: View {
    @EnvironmentObject private var appState: MeAIAppState

    private var voiceExperience: VoiceExperienceProfile {
        VoiceExperienceProfile.resolve(role: appState.agentProfile.responseStyle.defaultVoiceRole, isOutbound: false)
    }

    var body: some View {
        Form {
            Section("Identity") {
                TextField("Agent name", text: $appState.agentProfile.name)
                TextField("Welcome message", text: $appState.agentProfile.welcomeMessage, axis: .vertical)
                    .lineLimit(2...5)
                TextField("AI disclosure", text: $appState.agentProfile.aiDisclosure, axis: .vertical)
                    .lineLimit(2...4)
            }

            Section("Voice") {
                Picker("Voice", selection: $appState.agentProfile.voice) {
                    Text("Alloy").tag("alloy")
                    Text("Ash").tag("ash")
                    Text("Ballad").tag("ballad")
                    Text("Coral").tag("coral")
                    Text("Sage").tag("sage")
                    Text("Verse").tag("verse")
                }
                TextField("Voice style", text: $appState.agentProfile.voiceStyle)
            }

            Section("Response style") {
                Picker("Style", selection: $appState.agentProfile.responseStyle) {
                    ForEach(AgentResponseStyle.allCases) { style in
                        Text(style.label).tag(style)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Voice experience") {
                LabeledContent("Silence window", value: String(format: "%.1fs", voiceExperience.silenceTimeoutSeconds))
                LabeledContent("Interrupt threshold", value: "\(voiceExperience.wordsToInterruptAssistant) words")
                LabeledContent("Latency priority", value: "\(voiceExperience.streamingLatencyPriority)")
            }
        }
        .navigationTitle("Identity")
    }
}

struct AgentTrainingView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        Form {
            Section("Behavior instructions") {
                TextField("Instructions", text: $appState.agentProfile.behaviorInstructions, axis: .vertical)
                    .lineLimit(5...10)
            }

            Section("Training notes") {
                TextField("Notes", text: $appState.agentProfile.trainingNotes, axis: .vertical)
                    .lineLimit(5...12)
            }
        }
        .navigationTitle("Training")
    }
}

struct AgentScenariosView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        List {
            ForEach($appState.scenarios) { $scenario in
                NavigationLink(destination: AgentScenarioEditorView(scenario: $scenario)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(scenario.name).font(.headline)
                        Text(scenario.goal).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
                    }
                }
            }
        }
        .navigationTitle("Scenarios")
        .toolbar {
            Button("Add") {
                appState.scenarios.append(.init(id: UUID().uuidString, name: "New scenario", trigger: "", goal: "", escalationRule: "", allowedActions: ""))
            }
        }
    }
}

struct AgentScenarioEditorView: View {
    @Binding var scenario: AgentScenario

    var body: some View {
        Form {
            TextField("Name", text: $scenario.name)
            TextField("Trigger", text: $scenario.trigger, axis: .vertical).lineLimit(2...4)
            TextField("Goal", text: $scenario.goal, axis: .vertical).lineLimit(2...4)
            TextField("Escalation rule", text: $scenario.escalationRule, axis: .vertical).lineLimit(2...5)
            TextField("Allowed actions", text: $scenario.allowedActions, axis: .vertical).lineLimit(2...5)
        }
        .navigationTitle("Scenario")
    }
}

struct AgentScriptsView: View {
    @EnvironmentObject private var appState: MeAIAppState

    var body: some View {
        List {
            ForEach($appState.scripts) { $script in
                NavigationLink(destination: AgentScriptEditorView(script: $script)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(script.name).font(.headline)
                        Text(script.purpose).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
                    }
                }
            }
        }
        .navigationTitle("Scripts")
        .toolbar {
            Button("Add") {
                appState.scripts.append(.init(id: UUID().uuidString, name: "New script", purpose: "", body: "", whenToUse: ""))
            }
        }
    }
}

struct AgentScriptEditorView: View {
    @Binding var script: AgentScript

    var body: some View {
        Form {
            TextField("Name", text: $script.name)
            TextField("Purpose", text: $script.purpose, axis: .vertical).lineLimit(2...4)
            TextField("Script", text: $script.body, axis: .vertical).lineLimit(5...12)
            TextField("When to use", text: $script.whenToUse, axis: .vertical).lineLimit(2...5)
        }
        .navigationTitle("Script")
    }
}

struct AgentTestPromptView: View {
    @EnvironmentObject private var appState: MeAIAppState
    @State private var prompt = "Unknown caller asks why I missed their call."

    var body: some View {
        Form {
            Section("Prompt") {
                TextField("Test prompt", text: $prompt, axis: .vertical)
                    .lineLimit(3...8)
            }

            Section("Preview") {
                Text("Agent: \(appState.agentProfile.name)")
                Text("Style: \(appState.agentProfile.responseStyle.label)")
                Text("Voice: \(appState.agentProfile.voice) — \(appState.agentProfile.voiceStyle)")
                Text(appState.runtimePolicy.compiledRuntimeBlock(profile: appState.agentProfile, scenarios: appState.scenarios, scripts: appState.scripts))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Test agent")
    }
}
