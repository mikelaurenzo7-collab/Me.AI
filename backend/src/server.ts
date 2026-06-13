import Fastify from "fastify";
import cors from "@fastify/cors";
import { env, isProviderConfigured } from "./lib/env.js";
import { loadDb } from "./lib/db.js";
import { authRoutes } from "./routes/auth.js";
import { openAIRoutes } from "./routes/openai.js";
import { callRoutes } from "./routes/calls.js";
import { deviceRoutes } from "./routes/devices.js";
import { toolRoutes } from "./routes/tools.js";
import { webhookRoutes } from "./routes/webhooks.js";

const app = Fastify({ logger: true });

await app.register(cors, { origin: true });
await loadDb();

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

await app.listen({ port: env.PORT, host: "127.0.0.1" });
