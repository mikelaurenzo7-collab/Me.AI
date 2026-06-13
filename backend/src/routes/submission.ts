import type { FastifyInstance } from "fastify";
import { submissionGates } from "../domain/submissionRules.js";

export async function submissionRoutes(app: FastifyInstance) {
  app.get("/api/submission/gates", async () => ({ gates: submissionGates }));
}
