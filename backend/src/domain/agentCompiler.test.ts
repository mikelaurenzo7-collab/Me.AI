import { describe, expect, it } from "vitest";
import { compileAgentInstructions } from "./agentCompiler.js";
import type { Agent } from "./types.js";

const agent: Agent = {
  id: "agt_test",
  accountId: "acct_test",
  mode: "personal",
  name: "Michael's Me.AI",
  active: true,
  voice: "alloy",
  voiceStyle: "Calm",
  responseStyle: "concise",
  systemInstructions: "Protect the user's time.",
  welcomeMessage: "Hi, this is Me.AI.",
  aiDisclosure: "This is Me.AI, an AI assistant.",
  trainingNotes: "Family calls should be prioritized.",
  createdAt: new Date().toISOString(),
  updatedAt: new Date().toISOString()
};

describe("compileAgentInstructions", () => {
  it("includes agent profile, scenarios, and scripts", () => {
    const instructions = compileAgentInstructions({
      agent,
      scenarios: [
        {
          id: "scn_test",
          accountId: "acct_test",
          agentId: "agt_test",
          name: "Unknown caller",
          trigger: "Caller not in contacts",
          goal: "Screen call",
          escalationRule: "Escalate urgent issues",
          allowedActions: "Summarize and request callback window",
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        }
      ],
      scripts: [
        {
          id: "scr_test",
          accountId: "acct_test",
          agentId: "agt_test",
          name: "Screening opener",
          purpose: "Screen unknown callers",
          body: "What is this regarding?",
          whenToUse: "Unknown inbound calls",
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        }
      ]
    });

    expect(instructions).toContain("Michael's Me.AI");
    expect(instructions).toContain("Response style: concise");
    expect(instructions).toContain("Unknown caller");
    expect(instructions).toContain("Screening opener");
    expect(instructions).toContain("Always ask for confirmation");
  });
});
