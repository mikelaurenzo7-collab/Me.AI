import type { FastifyInstance } from "fastify";
import { requireWorkspace } from "../lib/authGuard.js";
import { listCallsForAccount, listPendingToolEventsForAccount, resolveToolEvent } from "../lib/db.js";

export async function historyRoutes(app: FastifyInstance) {
  app.get("/api/calls/history", async (request) => {
    const workspace = await requireWorkspace(request);
    const calls = await listCallsForAccount(workspace.account.id);
    return { calls };
  });

  app.get("/api/tools/pending", async (request) => {
    const workspace = await requireWorkspace(request);
    const events = await listPendingToolEventsForAccount(workspace.account.id);
    return { events };
  });

  app.post<{ Params: { id: string } }>("/api/tools/:id/approve", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const event = await resolveToolEvent(workspace.account.id, request.params.id, "completed");
    if (!event) return reply.code(404).send({ error: "Tool event not found" });
    return { event };
  });

  app.post<{ Params: { id: string } }>("/api/tools/:id/decline", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const event = await resolveToolEvent(workspace.account.id, request.params.id, "denied");
    if (!event) return reply.code(404).send({ error: "Tool event not found" });
    return { event };
  });
}
