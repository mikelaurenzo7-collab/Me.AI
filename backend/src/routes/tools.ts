import type { FastifyInstance } from "fastify";
import { z } from "zod";
import { nativeTools } from "../domain/toolRegistry.js";
import { addToolEvent } from "../lib/db.js";
import { requireWorkspace } from "../lib/authGuard.js";

const dispatchSchema = z.object({
  callLogId: z.string().optional(),
  toolName: z.enum(["route_to_location", "create_calendar_reminder", "handoff_music_request", "send_message_draft", "request_user_confirmation"]),
  request: z.record(z.unknown()).default({})
});

export async function toolRoutes(app: FastifyInstance) {
  app.get("/api/tools/native", async () => ({ tools: nativeTools }));

  app.post("/api/tools/dispatch", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const input = dispatchSchema.parse(request.body);
    const event = await addToolEvent({
      accountId: workspace.account.id,
      callLogId: input.callLogId,
      toolName: input.toolName,
      status: "requested",
      request: input.request
    });
    return reply.send({ event, delivery: "queued_for_active_ios_device" });
  });
}
