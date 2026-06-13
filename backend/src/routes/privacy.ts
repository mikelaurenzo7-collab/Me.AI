import type { FastifyInstance } from "fastify";
import { requireWorkspace } from "../lib/authGuard.js";
import { getActiveAgent, listAgentStudio, listCallsForAccount, listPendingToolEventsForAccount } from "../lib/db.js";

export async function privacyRoutes(app: FastifyInstance) {
  app.get("/api/privacy/export", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const activeAgent = await getActiveAgent(workspace.account.id);
    const calls = await listCallsForAccount(workspace.account.id);
    const pendingEvents = await listPendingToolEventsForAccount(workspace.account.id);
    const studio = activeAgent ? await listAgentStudio(workspace.account.id, activeAgent.id) : { scenarios: [], scripts: [] };

    return reply.send({
      exportedAt: new Date().toISOString(),
      account: workspace.account,
      user: {
        id: workspace.user.id,
        email: workspace.user.email,
        displayName: workspace.user.displayName,
        role: workspace.user.role
      },
      agents: workspace.agents,
      phoneLines: workspace.phoneLines,
      calls,
      pendingEvents,
      agentStudio: studio
    });
  });

  app.get("/api/privacy/summary", async (request) => {
    const workspace = await requireWorkspace(request);
    const calls = await listCallsForAccount(workspace.account.id);
    const pendingEvents = await listPendingToolEventsForAccount(workspace.account.id);
    return {
      accountMode: workspace.account.mode,
      agentCount: workspace.agents.length,
      phoneLineCount: workspace.phoneLines.length,
      callCount: calls.length,
      pendingConfirmationCount: pendingEvents.length,
      dataControls: ["export", "clear call history", "clear transcripts", "close account"]
    };
  });
}
