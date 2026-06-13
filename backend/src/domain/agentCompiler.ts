import type { Agent, AgentScenario, AgentScript } from "./types.js";

export function compileAgentInstructions(input: { agent: Agent; scenarios: AgentScenario[]; scripts: AgentScript[] }) {
  const { agent, scenarios, scripts } = input;
  const parts = [
    agent.systemInstructions,
    `Agent name: ${agent.name}`,
    `Response style: ${agent.responseStyle ?? "concise"}`,
    `Voice style: ${agent.voiceStyle ?? "calm, professional"}`,
    `Welcome message: ${agent.welcomeMessage}`,
    agent.aiDisclosure ? `AI disclosure: ${agent.aiDisclosure}` : undefined,
    agent.trainingNotes ? `Training notes: ${agent.trainingNotes}` : undefined,
    formatScenarios(scenarios),
    formatScripts(scripts),
    "Always ask for confirmation before sensitive actions such as placing calls, sending messages, creating reminders, changing calendar data, or sharing private details."
  ].filter(Boolean);

  return parts.join("\n\n");
}

function formatScenarios(scenarios: AgentScenario[]) {
  if (scenarios.length === 0) return undefined;
  return [
    "Scenarios:",
    ...scenarios.map((scenario) => [
      `- ${scenario.name}`,
      `  Trigger: ${scenario.trigger}`,
      `  Goal: ${scenario.goal}`,
      `  Escalation: ${scenario.escalationRule}`,
      `  Allowed actions: ${scenario.allowedActions}`
    ].join("\n"))
  ].join("\n");
}

function formatScripts(scripts: AgentScript[]) {
  if (scripts.length === 0) return undefined;
  return [
    "Scripts:",
    ...scripts.map((script) => [
      `- ${script.name}`,
      `  Purpose: ${script.purpose}`,
      `  When to use: ${script.whenToUse}`,
      `  Body: ${script.body}`
    ].join("\n"))
  ].join("\n");
}
