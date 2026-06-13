import type { FastifyRequest } from "fastify";
import { verifySession } from "./session.js";
import { getWorkspace } from "./db.js";

export class AuthError extends Error {
  statusCode = 401;

  constructor(message = "Unauthorized") {
    super(message);
    this.name = "AuthError";
  }
}

export class WorkspaceNotFoundError extends Error {
  statusCode = 404;

  constructor(message = "Workspace not found") {
    super(message);
    this.name = "WorkspaceNotFoundError";
  }
}

export async function requireWorkspace(request: FastifyRequest) {
  const session = verifySession(request.headers.authorization);
  if (!session) throw new AuthError();
  const workspace = await getWorkspace(session.userId);
  if (!workspace) throw new WorkspaceNotFoundError();
  return workspace;
}
