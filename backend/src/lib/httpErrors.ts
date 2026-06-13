import type { FastifyInstance } from "fastify";
import { ZodError } from "zod";

export async function httpErrors(app: FastifyInstance) {
  app.setErrorHandler((error, request, reply) => {
    const requestId = request.headers["x-request-id"];

    if (error instanceof ZodError) {
      return reply.code(400).send({
        error: "Invalid request",
        requestId,
        issues: error.issues.map((issue) => ({ path: issue.path.join("."), message: issue.message }))
      });
    }

    const statusCode = "statusCode" in error && typeof error.statusCode === "number" ? error.statusCode : undefined;
    if (statusCode && statusCode >= 400 && statusCode < 500) {
      return reply.code(statusCode).send({ error: error.message, requestId });
    }

    request.log.error({ error, requestId }, "Unhandled request error");
    return reply.code(500).send({ error: "Internal server error", requestId });
  });
}
