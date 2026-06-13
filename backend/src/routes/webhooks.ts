import type { FastifyInstance } from "fastify";
import { addCall, findPhoneLineByE164, getActiveAgent, listAgentStudio, addToolEvent, findCallByProviderId, loadDb, saveDb } from "../lib/db.js";
import { compileAgentInstructions } from "../domain/agentCompiler.js";
import { toVapiTools } from "../domain/toolRegistry.js";

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

  app.post("/api/webhooks/vapi", async (request, reply) => {
    const body = request.body as any;
    const message = body?.message;

    if (!message) {
      return reply.code(400).send({ error: "Missing message payload" });
    }

    app.log.info(`Received Vapi Webhook event of type: ${message.type}`);

    if (message.type === "assistant-request") {
      const call = message.call;
      const toNumber = call?.to;
      const fromNumber = call?.from;

      const phoneLine = toNumber ? await findPhoneLineByE164(toNumber) : null;
      const accountId = phoneLine?.accountId ?? "acct_demo_123";
      const agent = await getActiveAgent(accountId);

      let instructions = "You are Me.AI, a concise call screening agent.";
      let voiceId = "EXAVITQu4vr4xnSDxMaL"; // Rachel (default)

      if (agent) {
        const studio = await listAgentStudio(accountId, agent.id);
        instructions = compileAgentInstructions({
          agent,
          scenarios: studio.scenarios,
          scripts: studio.scripts
        });

        // Map voice name to ElevenLabs voice ID
        const voiceMapping: Record<string, string> = {
          alloy: "EXAVITQu4vr4xnSDxMaL", // Rachel / Bella
          ash: "ErXwobaYiN019PkySvjV",   // Antoni
          coral: "AZnzlk1XvdvUeBnXmlld", // Domi
          sage: "IKne3meq5aSn9XLyUdCD",  // Charlie
          verse: "ODq5zmAzzjZZ58GFxpTq"  // Callum
        };
        voiceId = voiceMapping[agent.voice.toLowerCase()] ?? "EXAVITQu4vr4xnSDxMaL";
      }

      // Record incoming call to local DB in "ringing" state
      await addCall({
        accountId,
        agentId: agent?.id ?? "agt_demo_123",
        phoneLineId: phoneLine?.id,
        direction: "inbound",
        status: "ringing",
        fromNumber,
        toNumber,
        providerCallId: call?.id
      });

      return reply.send({
        assistant: {
          name: agent?.name ?? "Me.AI",
          model: {
            provider: "openai",
            model: "gpt-4-turbo",
            messages: [
              {
                role: "system",
                content: instructions
              }
            ],
            tools: toVapiTools()
          },
          voice: {
            provider: "elevenlabs",
            voiceId: voiceId
          },
          firstMessage: agent?.welcomeMessage ?? "Hi, this is Me.AI, your virtual call operator. What is this regarding?"
        }
      });
    }

    if (message.type === "tool-calls") {
      const toolCalls = message.toolCalls;
      const call = message.call;
      const callSid = call?.id;

      const callLog = callSid ? await findCallByProviderId(callSid) : null;
      const accountId = callLog?.accountId ?? "acct_demo_123";

      const results = [];
      for (const tc of toolCalls) {
        if (tc.type === "function") {
          const fn = tc.function;
          const event = await addToolEvent({
            accountId,
            callLogId: callLog?.id,
            toolName: fn.name,
            status: "requested",
            request: fn.arguments || {}
          });

          results.push({
            toolCallId: tc.id,
            result: `Confirmation queued on Owner's iPhone cockpit (Event ID: ${event.id}). Action will proceed once approved.`
          });
        }
      }
      return reply.send({ results });
    }

    if (message.type === "end-of-call-report") {
      const call = message.call;
      const callSid = call?.id;

      if (callSid) {
        const dbCall = await findCallByProviderId(callSid);
        if (dbCall) {
          const db = await loadDb();
          const targetCall = db.calls.find((c) => c.id === dbCall.id);
          if (targetCall) {
            targetCall.status = "completed";
            targetCall.transcript = message.transcript || "No transcript available.";
            targetCall.summary = message.summary || "Call completed via Vapi Voice Operator.";
            targetCall.outcome = message.endedReason || "Completed";
            targetCall.updatedAt = new Date().toISOString();
            await saveDb(db);
          }
        }
      }
      return reply.send({ received: true });
    }

    // Default response for other messages
    return reply.send({ received: true });
  });
}
