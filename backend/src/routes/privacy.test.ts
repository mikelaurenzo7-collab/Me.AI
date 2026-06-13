import { describe, expect, it } from "vitest";
import { buildApp } from "../app.js";

describe("privacy routes", () => {
  it("requires auth for privacy export", async () => {
    const app = await buildApp();
    const response = await app.inject({ method: "GET", url: "/api/privacy/export" });
    expect(response.statusCode).toBe(401);
    await app.close();
  });

  it("requires auth for privacy summary", async () => {
    const app = await buildApp();
    const response = await app.inject({ method: "GET", url: "/api/privacy/summary" });
    expect(response.statusCode).toBe(401);
    await app.close();
  });
});
