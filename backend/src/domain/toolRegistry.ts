import type { NativeToolName } from "./types.js";

export type NativeToolDefinition = {
  name: NativeToolName;
  description: string;
  requiresConfirmation: boolean;
  carPlaySafe: boolean;
  schema: Record<string, unknown>;
};

export const nativeTools: NativeToolDefinition[] = [
  {
    name: "route_to_location",
    description: "Ask the iOS app to open a route in Apple Maps or another user-approved navigation app.",
    requiresConfirmation: true,
    carPlaySafe: true,
    schema: { type: "object", additionalProperties: false, required: ["destination"], properties: { destination: { type: "string" }, reason: { type: "string" } } }
  },
  {
    name: "create_calendar_reminder",
    description: "Ask the iOS app to create a calendar item or reminder after user confirmation.",
    requiresConfirmation: true,
    carPlaySafe: true,
    schema: { type: "object", additionalProperties: false, required: ["title"], properties: { title: { type: "string" }, dueAt: { type: "string" }, notes: { type: "string" } } }
  },
  {
    name: "handoff_music_request",
    description: "Prepare a media request for the iOS app. The app must use approved media integrations and user permissions.",
    requiresConfirmation: false,
    carPlaySafe: true,
    schema: { type: "object", additionalProperties: false, required: ["query"], properties: { query: { type: "string" }, provider: { type: "string" } } }
  },
  {
    name: "send_message_draft",
    description: "Draft a message for user review. Do not send without native confirmation.",
    requiresConfirmation: true,
    carPlaySafe: true,
    schema: { type: "object", additionalProperties: false, required: ["recipient", "body"], properties: { recipient: { type: "string" }, body: { type: "string" } } }
  },
  {
    name: "request_user_confirmation",
    description: "Ask the active iOS device to show a simple approve or decline prompt.",
    requiresConfirmation: false,
    carPlaySafe: true,
    schema: { type: "object", additionalProperties: false, required: ["question"], properties: { question: { type: "string" }, risk: { type: "string" } } }
  }
];

export function toOpenAITools() {
  return nativeTools.map((tool) => ({
    type: "function",
    name: tool.name,
    description: tool.description,
    parameters: tool.schema,
    strict: true
  }));
}

export function toVapiTools() {
  return nativeTools.map((tool) => ({
    type: "function",
    async: false,
    messages: [
      {
        type: "request-start",
        content: tool.requiresConfirmation
          ? "I am sending that to Michael's iPhone for confirmation."
          : "Processing that request now."
      }
    ],
    function: {
      name: tool.name,
      description: tool.description,
      parameters: tool.schema
    }
  }));
}
