import type { FastifyInstance } from "fastify";
import { addCall, findPhoneLineByE164 } from "../lib/db.js";

export async function webhookRoutes(app: FastifyInstance) {
  app.post("/api/webhooks/twilio/voice", async (request, reply) => {
    const body = request.body as Record<string, string | undefined> | undefined;
    const fromNumber = body?.From;
    const toNumber = body?.To;

    const phoneLine = toNumber ? await findPhoneLineByE164(toNumber) : null;

    const call = await addCall({
      accountId: phoneLine?.accountId ?? "unresolved",
      agentId: phoneLine?.agentId ?? "unresolved",
      phoneLineId: phoneLine?.id,
      direction: "inbound",
      status: "ringing",
      fromNumber,
      toNumber,
      providerCallId: body?.CallSid
    });

    const host = request.headers.host || "localhost:3000";
    const protocol = request.headers["x-forwarded-proto"] === "https" ? "wss" : "ws";
    const streamUrl = `${protocol}://${host}/api/media-stream`;

    const twiml = `<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>Connecting to Me.AI personal call operator.</Say>
  <Connect>
    <Stream url="${streamUrl}" />
  </Connect>
</Response>`;
    return reply.type("text/xml").send(twiml);
  });

  app.post("/api/webhooks/twilio/status", async (_request, reply) => {
    return reply.send({ ok: true, received: "twilio_status" });
  });

  app.post("/api/webhooks/twilio/transfer", async (request, reply) => {
    const query = request.query as Record<string, string | undefined> | undefined;
    const body = request.body as Record<string, string | undefined> | undefined;
    const transferTo = query?.transferTo ?? body?.transferTo ?? "+16305550199";

    const twiml = `<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say voice="Polly.Matthew-Neural">Connecting you with Michael Laurenzo now. Please hold.</Say>
  <Play>http://demo.twilio.com/docs/classic.mp3</Play>
  <Dial>${transferTo}</Dial>
</Response>`;
    return reply.type("text/xml").send(twiml);
  });

  app.post("/api/webhooks/openai/realtime", async (_request, reply) => {
    return reply.send({ ok: true, received: "openai_realtime_event" });
  });
}
