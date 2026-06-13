import { createHmac } from "node:crypto";
import { env } from "./env.js";

export function signSession(userId: string) {
  const payload = Buffer.from(JSON.stringify({ userId, iat: Date.now() })).toString("base64url");
  const sig = createHmac("sha256", env.SESSION_SECRET).update(payload).digest("base64url");
  return `${payload}.${sig}`;
}

export function verifySession(token?: string) {
  if (!token) return null;
  const [payload, sig] = token.replace(/^Bearer\s+/i, "").split(".");
  if (!payload || !sig) return null;
  const expected = createHmac("sha256", env.SESSION_SECRET).update(payload).digest("base64url");
  if (sig !== expected) return null;
  try {
    return JSON.parse(Buffer.from(payload, "base64url").toString("utf8")) as { userId: string; iat: number };
  } catch {
    return null;
  }
}
