import { describe, expect, it } from "vitest";
import { nativeTools, toOpenAITools } from "./toolRegistry.js";

describe("native tool registry", () => {
  it("keeps native tools allowlisted", () => {
    expect(nativeTools.map((tool) => tool.name)).toEqual([
      "route_to_location",
      "create_calendar_reminder",
      "handoff_music_request",
      "send_message_draft",
      "request_user_confirmation"
    ]);
  });

  it("exports strict OpenAI tool definitions", () => {
    const tools = toOpenAITools();
    expect(tools).toHaveLength(nativeTools.length);
    expect(tools.every((tool) => tool.type === "function")).toBe(true);
    expect(tools.every((tool) => tool.strict === true)).toBe(true);
  });
});
