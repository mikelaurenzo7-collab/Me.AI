import type { FastifyInstance } from "fastify";
import { z } from "zod";
import { createAccount, findUserByEmail, getWorkspace } from "../lib/db.js";
import { signSession, verifySession } from "../lib/session.js";

const registerSchema = z.object({
  mode: z.enum(["personal", "business"]).default("personal"),
  name: z.string().min(1).default("Me.AI Personal"),
  email: z.string().email(),
  displayName: z.string().min(1).default("Me.AI User")
});

const loginSchema = z.object({ email: z.string().email() });

export async function authRoutes(app: FastifyInstance) {
  app.post("/api/auth/register", async (request, reply) => {
    const input = registerSchema.parse(request.body);
    const existing = await findUserByEmail(input.email);
    if (existing) {
      const token = signSession(existing.id);
      const workspace = await getWorkspace(existing.id);
      return reply.send({ token, workspace });
    }
    const created = await createAccount(input);
    return reply.send({ token: signSession(created.user.id), workspace: await getWorkspace(created.user.id) });
  });

  app.post("/api/auth/login", async (request, reply) => {
    const input = loginSchema.parse(request.body);
    const user = await findUserByEmail(input.email);
    if (!user) return reply.code(404).send({ error: "User not found" });
    return reply.send({ token: signSession(user.id), workspace: await getWorkspace(user.id) });
  });

  app.get("/api/accounts/me", async (request, reply) => {
    const session = verifySession(request.headers.authorization);
    if (!session) return reply.code(401).send({ error: "Unauthorized" });
    const workspace = await getWorkspace(session.userId);
    if (!workspace) return reply.code(404).send({ error: "Workspace not found" });
    return reply.send(workspace);
  });
}
