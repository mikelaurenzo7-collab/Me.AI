import type { FastifyInstance } from "fastify";
import { z } from "zod";
import { requireWorkspace } from "../lib/authGuard.js";
import { upsertDevice } from "../lib/db.js";

const schema = z.object({
  deviceId: z.string().min(1),
  platform: z.enum(["ios", "android"]).default("ios"),
  voipToken: z.string().optional(),
  pushToken: z.string().optional(),
  fcmToken: z.string().optional()
});

export async function deviceRoutes(app: FastifyInstance) {
  app.post("/api/devices/register", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const input = schema.parse(request.body);
    const device = await upsertDevice({
      accountId: workspace.account.id,
      userId: workspace.user.id,
      deviceId: input.deviceId,
      platform: input.platform,
      voipToken: input.voipToken,
      pushToken: input.pushToken,
      fcmToken: input.fcmToken
    });
    return reply.send({ device });
  });
}
