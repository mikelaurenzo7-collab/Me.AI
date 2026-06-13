import type { FastifyInstance } from "fastify";
import { addCall } from "../lib/db.js";

export async function webhookRoutes(app: FastifyInstance) {
  app.post("/api/webhooks/twilio/voice", async (request, reply) => {
    const body = request.body as Record<string, string | undefined> | undefined;
    const fromNumber = body?.From;
    const toNumber = body?.To;

    const call = await addCall({
      accountId: "unresolved",
      agentId: "unresolved",
      direction: "inbound",
      status: "ringing",
      fromNumber,
      toNumber,
      providerCallId: body?.CallSid
    });

    const twiml = `<?xml version="1.0" encoding="UTF-8"?><Response><Say>Me dot A I is preparing this call.</Say><Pause length="1"/><Say>Please continue to hold while the assistant connects.</Say></Response>`;
    return reply.type("text/xml").send(twiml);
  });

  app.post("/api/webhooks/twilio/status", async (_request, reply) => {
    return reply.send({ ok: true, received: "twilio_status" });
  });

  app.post("/api/webhooks/openai/realtime", async (_request, reply) => {
    return reply.send({ ok: true, received: "openai_realtime_event" });
  });
}
