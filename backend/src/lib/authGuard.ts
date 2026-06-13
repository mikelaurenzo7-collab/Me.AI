import type { FastifyRequest } from "fastify";
import { verifySession } from "./session.js";
import { getWorkspace } from "./db.js";

export async function requireWorkspace(request: FastifyRequest) {
  const session = verifySession(request.headers.authorization);
  if (!session) throw new Error("Unauthorized");
  const workspace = await getWorkspace(session.userId);
  if (!workspace) throw new Error("Workspace not found");
  return workspace;
}
