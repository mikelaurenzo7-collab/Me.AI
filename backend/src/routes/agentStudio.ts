import type { FastifyInstance } from "fastify";
import { z } from "zod";
import { requireWorkspace } from "../lib/authGuard.js";
import { getActiveAgent, listAgentStudio, updateActiveAgent, upsertAgentScenario, upsertAgentScript } from "../lib/db.js";

const agentProfileSchema = z.object({
  name: z.string().min(1).optional(),
  voice: z.string().min(1).optional(),
  voiceStyle: z.string().optional(),
  responseStyle: z.enum(["concise", "balanced", "detailed", "warm", "formal", "direct"]).optional(),
  systemInstructions: z.string().optional(),
  welcomeMessage: z.string().optional(),
  aiDisclosure: z.string().optional(),
  trainingNotes: z.string().optional()
});

const scenarioSchema = z.object({
  id: z.string().optional(),
  name: z.string().min(1),
  trigger: z.string().default(""),
  goal: z.string().default(""),
  escalationRule: z.string().default(""),
  allowedActions: z.string().default("")
});

const scriptSchema = z.object({
  id: z.string().optional(),
  name: z.string().min(1),
  purpose: z.string().default(""),
  body: z.string().default(""),
  whenToUse: z.string().default("")
});

export async function agentStudioRoutes(app: FastifyInstance) {
  app.get("/api/agent-studio", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const agent = await getActiveAgent(workspace.account.id);
    if (!agent) return reply.code(404).send({ error: "Active agent not found" });
    const studio = await listAgentStudio(workspace.account.id, agent.id);
    return { agent, ...studio };
  });

  app.patch("/api/agent-studio/profile", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const input = agentProfileSchema.parse(request.body);
    const agent = await updateActiveAgent(workspace.account.id, input);
    if (!agent) return reply.code(404).send({ error: "Active agent not found" });
    return { agent };
  });

  app.post("/api/agent-studio/scenarios", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const agent = await getActiveAgent(workspace.account.id);
    if (!agent) return reply.code(404).send({ error: "Active agent not found" });
    const input = scenarioSchema.parse(request.body);
    const scenario = await upsertAgentScenario({ accountId: workspace.account.id, agentId: agent.id, ...input });
    return { scenario };
  });

  app.post("/api/agent-studio/scripts", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const agent = await getActiveAgent(workspace.account.id);
    if (!agent) return reply.code(404).send({ error: "Active agent not found" });
    const input = scriptSchema.parse(request.body);
    const script = await upsertAgentScript({ accountId: workspace.account.id, agentId: agent.id, ...input });
    return { script };
  });
}
