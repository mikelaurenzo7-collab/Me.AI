import type { FastifyInstance } from "fastify";
import { env, isProviderConfigured } from "../lib/env.js";
import { requireWorkspace } from "../lib/authGuard.js";
import { toOpenAITools } from "../domain/toolRegistry.js";

export async function openAIRoutes(app: FastifyInstance) {
  app.post("/api/openai/realtime/session", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const agent = workspace.agents.find((item) => item.active);
    if (!agent) return reply.code(404).send({ error: "No active agent" });

    const sessionConfig = {
      type: "realtime",
      model: env.OPENAI_REALTIME_MODEL,
      instructions: agent.systemInstructions,
      voice: agent.voice,
      reasoning: { effort: "low" },
      tools: toOpenAITools(),
      tool_choice: "auto",
      metadata: {
        accountId: workspace.account.id,
        accountMode: workspace.account.mode,
        agentId: agent.id,
        userId: workspace.user.id,
        product: "Me.AI"
      }
    };

    if (!isProviderConfigured.openai) {
      return reply.send({ configured: false, session: sessionConfig, note: "Set OPENAI_API_KEY to create live ephemeral sessions." });
    }

    const response = await fetch("https://api.openai.com/v1/realtime/client_secrets", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${env.OPENAI_API_KEY}`,
        "Content-Type": "application/json",
        "OpenAI-Safety-Identifier": workspace.user.id
      },
      body: JSON.stringify({ session: sessionConfig })
    });

    if (!response.ok) {
      const text = await response.text();
      return reply.code(response.status).send({ error: "OpenAI session creation failed", detail: text });
    }

    return reply.send(await response.json());
  });
}
