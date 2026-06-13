import type { FastifyInstance } from "fastify";
import { z } from "zod";
import { requireWorkspace } from "../lib/authGuard.js";
import { addCall, loadDb, saveDb } from "../lib/db.js";
import { env } from "../lib/env.js";

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

  app.post<{ Params: { callId: string } }>("/api/calls/:callId/takeover", async (request, reply) => {
    const workspace = await requireWorkspace(request);
    const db = await loadDb();
    const call = db.calls.find((item) => item.id === request.params.callId);
    if (!call) return reply.code(404).send({ error: "Call not found" });

    // Mark call status as completed (handoff terminates AI screening session)
    call.status = "completed";
    call.outcome = "Call taken over by Michael";
    call.updatedAt = new Date().toISOString();
    await saveDb(db);

    // Look up PhoneLine's transferPhone configuration
    const phoneLine = db.phoneLines.find((line) => line.id === call.phoneLineId || line.accountId === workspace.account.id);
    const transferTo = phoneLine?.transferPhone ?? "+16305550199";

    const callSid = call.providerCallId;
    if (callSid && env.TWILIO_ACCOUNT_SID && env.TWILIO_AUTH_TOKEN) {
      try {
        await redirectTwilioCall(
          callSid,
          `${env.PUBLIC_BASE_URL}/api/webhooks/twilio/transfer?transferTo=${encodeURIComponent(transferTo)}`
        );
        request.log.info(`Redirected active Twilio call ${callSid} to transfer phone: ${transferTo}`);
      } catch (err: any) {
        request.log.error(`Failed to redirect Twilio call ${callSid}: ${err.message || err}`);
      }
    } else {
      request.log.info(`[Twilio Mock] Redirected call ${callSid || "demo_call"} to transfer phone: ${transferTo}`);
    }

    return reply.send({
      status: "takeover_initiated",
      transferTo,
      providerCallId: callSid || "demo_call",
      note: "Twilio redirect webhook issued, call transfer initiated to user handset."
    });
  });

  app.post("/api/calls/:callId/delegate", async (request, reply) => {
    await requireWorkspace(request);
    return reply.send({ status: "delegation_requested", note: "The active call should continue under Me.AI control with live status updates." });
  });
}

async function redirectTwilioCall(callSid: string, transferUrl: string) {
  const credentials = Buffer.from(`${env.TWILIO_ACCOUNT_SID}:${env.TWILIO_AUTH_TOKEN}`).toString("base64");
  const response = await fetch(`https://api.twilio.com/2010-04-01/Accounts/${env.TWILIO_ACCOUNT_SID}/Calls/${callSid}.json`, {
    method: "POST",
    headers: {
      Authorization: `Basic ${credentials}`,
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: new URLSearchParams({ Url: transferUrl })
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Twilio redirect failed with ${response.status}: ${body}`);
  }
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
