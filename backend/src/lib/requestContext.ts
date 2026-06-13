import type { FastifyInstance } from "fastify";
import { nanoid } from "nanoid";

export async function requestContext(app: FastifyInstance) {
  app.addHook("onRequest", async (request, reply) => {
    const incoming = request.headers["x-request-id"];
    const requestId = typeof incoming === "string" && incoming.length > 0 ? incoming : `req_${nanoid(12)}`;
    request.headers["x-request-id"] = requestId;
    reply.header("x-request-id", requestId);
  });
}
