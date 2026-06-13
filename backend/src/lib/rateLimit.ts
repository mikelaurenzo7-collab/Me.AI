import type { FastifyInstance } from "fastify";

const buckets = new Map<string, { count: number; resetAt: number }>();

export async function lightweightRateLimit(app: FastifyInstance) {
  app.addHook("onRequest", async (request, reply) => {
    if (request.method === "GET" && request.url === "/health") return;

    const key = request.ip || "unknown";
    const now = Date.now();
    const bucket = buckets.get(key);

    if (!bucket || bucket.resetAt < now) {
      buckets.set(key, { count: 1, resetAt: now + 60_000 });
      return;
    }

    bucket.count += 1;
    if (bucket.count > 120) {
      reply.code(429).send({ error: "Too many requests" });
    }
  });
}
