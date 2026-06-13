import Fastify from "fastify";
import cors from "@fastify/cors";
import { env, isProviderConfigured } from "./lib/env.js";
import { loadDb } from "./lib/db.js";
import { requestContext } from "./lib/requestContext.js";
import { lightweightRateLimit } from "./lib/rateLimit.js";
import { httpErrors } from "./lib/httpErrors.js";
import { securityHeaders } from "./lib/securityHeaders.js";
import { authRoutes } from "./routes/auth.js";
import { openAIRoutes } from "./routes/openai.js";
import { callRoutes } from "./routes/calls.js";
import { deviceRoutes } from "./routes/devices.js";
import { toolRoutes } from "./routes/tools.js";
import { webhookRoutes } from "./routes/webhooks.js";
import { submissionRoutes } from "./routes/submission.js";
import { historyRoutes } from "./routes/history.js";
import { agentStudioRoutes } from "./routes/agentStudio.js";
import { privacyRoutes } from "./routes/privacy.js";
import fastifyWebsocket from "@fastify/websocket";
import { mediaStreamRoutes } from "./routes/mediaStream.js";

if (typeof (BigInt.prototype as any).toJSON !== "function") {
  Object.defineProperty(BigInt.prototype, "toJSON", {
    value: function toJSON(this: bigint) {
      return this.toString();
    },
    writable: true,
    configurable: true,
  });
}

export async function buildApp() {
  const app = Fastify({ logger: true });

  await app.register(httpErrors);
  await app.register(requestContext);
  await app.register(securityHeaders);
  await app.register(lightweightRateLimit);
  await app.register(cors, { origin: true });
  await app.register(fastifyWebsocket);
  await loadDb();

  app.addContentTypeParser("application/x-www-form-urlencoded", { parseAs: "string" }, (req, body, done) => {
    try {
      const parsed = new URLSearchParams(body.toString());
      const result: Record<string, string> = {};
      for (const [key, value] of parsed.entries()) {
        result[key] = value;
      }
      done(null, result);
    } catch (err: any) {
      err.statusCode = 400;
      done(err, undefined);
    }
  });

  app.get("/health", async () => ({
    ok: true,
    service: "me-ai-backend",
    providers: isProviderConfigured,
    realtimeModel: env.OPENAI_REALTIME_MODEL
  }));

  await app.register(authRoutes);
  await app.register(openAIRoutes);
  await app.register(callRoutes);
  await app.register(deviceRoutes);
  await app.register(toolRoutes);
  await app.register(webhookRoutes);
  await app.register(submissionRoutes);
  await app.register(historyRoutes);
  await app.register(agentStudioRoutes);
  await app.register(privacyRoutes);
  await app.register(mediaStreamRoutes);

  return app;
}
