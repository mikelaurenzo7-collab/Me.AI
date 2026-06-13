import { describe, expect, it } from "vitest";
import { buildApp } from "../app.js";

describe("history routes", () => {
  it("requires auth for call history", async () => {
    const app = await buildApp();
    const response = await app.inject({ method: "GET", url: "/api/calls/history" });
    expect(response.statusCode).toBe(401);
    await app.close();
  });

  it("requires auth for pending confirmations", async () => {
    const app = await buildApp();
    const response = await app.inject({ method: "GET", url: "/api/tools/pending" });
    expect(response.statusCode).toBe(401);
    await app.close();
  });
});
