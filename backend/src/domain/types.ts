export type AccountMode = "personal" | "business";
export type UserRole = "owner" | "admin" | "member";
export type CallDirection = "inbound" | "outbound";
export type CallStatus = "queued" | "ringing" | "active" | "completed" | "failed" | "missed";
export type AgentResponseStyle = "concise" | "balanced" | "detailed" | "warm" | "formal" | "direct";
export type NativeToolName =
  | "route_to_location"
  | "create_calendar_reminder"
  | "handoff_music_request"
  | "send_message_draft"
  | "request_user_confirmation";

export type Account = {
  id: string;
  mode: AccountMode;
  name: string;
  createdAt: string;
  updatedAt: string;
};

export type User = {
  id: string;
  accountId: string;
  email: string;
  displayName: string;
  role: UserRole;
  createdAt: string;
};

export type Agent = {
  id: string;
  accountId: string;
  mode: AccountMode;
  name: string;
  active: boolean;
  voice: string;
  voiceStyle?: string;
  responseStyle?: AgentResponseStyle;
  systemInstructions: string;
  welcomeMessage: string;
  aiDisclosure?: string;
  trainingNotes?: string;
  createdAt: string;
  updatedAt: string;
};

export type AgentScenario = {
  id: string;
  accountId: string;
  agentId: string;
  name: string;
  trigger: string;
  goal: string;
  escalationRule: string;
  allowedActions: string;
  createdAt: string;
  updatedAt: string;
};

export type AgentScript = {
  id: string;
  accountId: string;
  agentId: string;
  name: string;
  purpose: string;
  body: string;
  whenToUse: string;
  createdAt: string;
  updatedAt: string;
};

export type PhoneLine = {
  id: string;
  accountId: string;
  agentId: string;
  e164: string;
  label: string;
  twilioNumberSid?: string;
  active: boolean;
  createdAt: string;
};

export type DeviceRegistration = {
  id: string;
  accountId: string;
  userId: string;
  deviceId: string;
  voipToken?: string;
  pushToken?: string;
  lastSeenAt: string;
};

export type CallLog = {
  id: string;
  accountId: string;
  agentId: string;
  phoneLineId?: string;
  direction: CallDirection;
  status: CallStatus;
  fromNumber?: string;
  toNumber?: string;
  providerCallId?: string;
  transcript?: string;
  summary?: string;
  outcome?: string;
  startedAt?: string;
  endedAt?: string;
  createdAt: string;
  updatedAt: string;
};

export type ToolEvent = {
  id: string;
  accountId: string;
  callLogId?: string;
  toolName: NativeToolName;
  status: "requested" | "sent_to_device" | "completed" | "failed" | "denied";
  request: Record<string, unknown>;
  result?: Record<string, unknown>;
  createdAt: string;
  updatedAt: string;
};
