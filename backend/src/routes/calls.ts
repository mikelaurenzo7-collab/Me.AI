import type { FastifyInstance } from "fastify";
import { z } from "zod";
import { requireWorkspace } from "../lib/authGuard.js";
import { addCall } from "../lib/db.js";

const outboundSchema = z.object({
  toNumber: z.string().min(3),
  spokenObjective: z.string().min(1),
  contactName: z.string().optional(),
  source: z.enum(["siri", "carplay", "app", "api"]).default("app")
});

export async function callRoutes(app: FastifyInstance) {
  app.post("/api/calls/outbound", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const input = outboundSchema.parse(request.body);
    const agent = workspace.agents.find((item) => item.active);
    if (!agent) return reply.code(404).send({ error: "No active agent" });

    const call = await addCall({
      accountId: workspace.account.id,
      agentId: agent.id,
      direction: "outbound",
      status: "queued",
      toNumber: input.toNumber,
      summary: input.spokenObjective
    });

    return reply.send({
      call,
      route: "outbound_call_queued",
      provider: "twilio_or_openai_sip",
      next: "Provision the live phone bridge before real dialing.",
      agentPrompt: buildOutboundPrompt(agent.name, input.spokenObjective, input.contactName)
    });
  });

  app.post("/api/calls/:callId/takeover", async (request, reply) => {
    await requireWorkspace(request);
    return reply.send({ status: "takeover_requested", note: "The iOS CallKit layer should foreground the active call and pause autonomous handling." });
  });

  app.post("/api/calls/:callId/delegate", async (request, reply) => {
    await requireWorkspace(request);
    return reply.send({ status: "delegation_requested", note: "The active call should continue under Me.AI control with live status updates." });
  });
}

function buildOutboundPrompt(agentName: string, objective: string, contactName?: string) {
  return [
    `You are ${agentName}, an AI voice agent assisting with a call.`,
    contactName ? `Contact label: ${contactName}.` : "Contact label: phone number only.",
    `Objective: ${objective}`,
    "Be brief, truthful, polite, and transparent that you are an AI assistant when appropriate.",
    "Pause for user confirmation before sensitive or irreversible actions."
  ].join("\n");
}
