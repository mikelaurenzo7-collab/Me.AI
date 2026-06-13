import { describe, expect, it } from "vitest";
import { buildApp } from "./app.js";

describe("app", () => {
  it("returns health status", async () => {
    const app = await buildApp();
    const response = await app.inject({ method: "GET", url: "/health" });
    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({ ok: true, service: "me-ai-backend" });
    await app.close();
  });

  it("exposes submission gates", async () => {
    const app = await buildApp();
    const response = await app.inject({ method: "GET", url: "/api/submission/gates" });
    expect(response.statusCode).toBe(200);
    expect(response.json().gates.length).toBeGreaterThan(0);
    await app.close();
  });
});
