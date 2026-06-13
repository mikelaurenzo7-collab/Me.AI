import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname } from "node:path";
import { nanoid } from "nanoid";
import { env } from "./env.js";
import type { Account, AccountMode, Agent, AgentScenario, AgentScript, CallLog, DeviceRegistration, PhoneLine, ToolEvent, User } from "../domain/types.js";

type Database = {
  accounts: Account[];
  users: User[];
  agents: Agent[];
  agentScenarios: AgentScenario[];
  agentScripts: AgentScript[];
  phoneLines: PhoneLine[];
  devices: DeviceRegistration[];
  calls: CallLog[];
  toolEvents: ToolEvent[];
};

const empty = (): Database => ({ accounts: [], users: [], agents: [], agentScenarios: [], agentScripts: [], phoneLines: [], devices: [], calls: [], toolEvents: [] });
const now = () => new Date().toISOString();
const id = (prefix: string) => `${prefix}_${nanoid(12)}`;
let cache: Database | null = null;

function normalize(raw: Partial<Database>): Database {
  return { ...empty(), ...raw };
}

function seedDemoData(db: Database) {
  const timestamp = now();
  const acctId = "acct_demo_123";
  const usrId = "usr_demo_123";
  const agtId = "agt_demo_123";
  const lineId = "line_demo_123";

  const account: Account = {
    id: acctId,
    mode: "personal",
    name: "Michael Laurenzo",
    createdAt: timestamp,
    updatedAt: timestamp
  };

  const user: User = {
    id: usrId,
    accountId: acctId,
    email: "michael@me.ai",
    displayName: "Michael Laurenzo",
    role: "owner",
    createdAt: timestamp
  };

  const agent: Agent = {
    id: agtId,
    accountId: acctId,
    mode: "personal",
    name: "Me.AI",
    active: true,
    voice: "alloy",
    voiceStyle: "Calm, professional",
    responseStyle: "concise",
    systemInstructions: defaultAgentInstructions("personal"),
    welcomeMessage: "I am Me.AI. I can help with calls, routing, reminders, and safe handoffs.",
    aiDisclosure: "This is Me.AI, an AI assistant.",
    trainingNotes: "Protect the user's time, privacy, and attention.",
    createdAt: timestamp,
    updatedAt: timestamp
  };

  const line: PhoneLine = {
    id: lineId,
    accountId: acctId,
    agentId: agtId,
    e164: "+16305550199",
    label: "Main screening line",
    transferPhone: "+16305550199",
    active: true,
    createdAt: timestamp
  };

  const scenarios: AgentScenario[] = [
    {
      id: "scn_1",
      accountId: acctId,
      agentId: agtId,
      name: "Unknown caller",
      trigger: "Caller is not in contacts",
      goal: "Screen politely and identify reason for call",
      escalationRule: "Escalate if urgent, family-related, legal, medical, or time-sensitive",
      allowedActions: "Summarize, request callback window, create reminder after approval",
      createdAt: timestamp,
      updatedAt: timestamp
    },
    {
      id: "scn_2",
      accountId: acctId,
      agentId: agtId,
      name: "Running late",
      trigger: "User asks Me.AI to notify someone",
      goal: "Make a concise outbound update",
      escalationRule: "Ask for confirmation before placing call",
      allowedActions: "Prepare call, place call after approval, summarize result",
      createdAt: timestamp,
      updatedAt: timestamp
    }
  ];

  const scripts: AgentScript[] = [
    {
      id: "scr_1",
      accountId: acctId,
      agentId: agtId,
      name: "Inbound screening opener",
      purpose: "Screen unknown callers",
      body: "Hi, this is Me.AI. I can help route the call. What is this regarding?",
      whenToUse: "Unknown inbound caller",
      createdAt: timestamp,
      updatedAt: timestamp
    }
  ];

  const calls: CallLog[] = [
    {
      id: "call_demo_1",
      accountId: acctId,
      agentId: agtId,
      phoneLineId: lineId,
      direction: "inbound",
      status: "completed",
      fromNumber: "+16305550199",
      toNumber: "+16305559999",
      summary: "Caller asked for availability and requested a callback window.",
      outcome: "Needs callback",
      createdAt: new Date(Date.now() - 1800 * 1000).toISOString(),
      updatedAt: new Date(Date.now() - 1800 * 1000).toISOString()
    }
  ];

  const toolEvents: ToolEvent[] = [
    {
      id: "confirm-1",
      accountId: acctId,
      callLogId: "call_demo_1",
      toolName: "create_calendar_reminder",
      status: "requested",
      request: {
        title: "Place outbound call",
        detail: "Call the office and say you are running five minutes late.",
        actionLabel: "Approve call",
        risk: "Places a call"
      },
      createdAt: new Date(Date.now() - 1800 * 1000).toISOString(),
      updatedAt: new Date(Date.now() - 1800 * 1000).toISOString()
    }
  ];

  db.accounts.push(account);
  db.users.push(user);
  db.agents.push(agent);
  db.phoneLines.push(line);
  db.agentScenarios.push(...scenarios);
  db.agentScripts.push(...scripts);
  db.calls.push(...calls);
  db.toolEvents.push(...toolEvents);
}

export async function loadDb(): Promise<Database> {
  if (cache) return cache;
  try {
    const raw = await readFile(env.DB_FILE, "utf8");
    cache = normalize(JSON.parse(raw) as Partial<Database>);
    return cache;
  } catch {
    cache = empty();
    seedDemoData(cache);
    await saveDb(cache);
    return cache;
  }
}

export async function saveDb(db: Database): Promise<void> {
  await mkdir(dirname(env.DB_FILE), { recursive: true });
  await writeFile(env.DB_FILE, JSON.stringify(db, null, 2));
  cache = db;
}

export async function createAccount(input: { mode: AccountMode; name: string; email: string; displayName: string }) {
  const db = await loadDb();
  const timestamp = now();
  const account: Account = { id: id("acct"), mode: input.mode, name: input.name, createdAt: timestamp, updatedAt: timestamp };
  const user: User = { id: id("usr"), accountId: account.id, email: input.email.toLowerCase(), displayName: input.displayName, role: "owner", createdAt: timestamp };
  const agent: Agent = {
    id: id("agt"),
    accountId: account.id,
    mode: input.mode,
    name: input.mode === "personal" ? "Me.AI" : "Me.AI Front Desk",
    active: true,
    voice: "alloy",
    voiceStyle: "Calm, professional",
    responseStyle: "concise",
    systemInstructions: defaultAgentInstructions(input.mode),
    welcomeMessage: input.mode === "personal" ? "I am Me.AI. I can help with calls, routing, reminders, and safe handoffs." : "You reached Me.AI. I can route your call and help the team respond quickly.",
    aiDisclosure: "This is Me.AI, an AI assistant.",
    trainingNotes: input.mode === "personal" ? "Protect the user's time, privacy, and attention." : "Follow workspace routing rules, scripts, and escalation paths.",
    createdAt: timestamp,
    updatedAt: timestamp
  };
  db.accounts.push(account);
  db.users.push(user);
  db.agents.push(agent);
  await saveDb(db);
  return { account, user, agent };
}

export async function findUserByEmail(email: string) {
  const db = await loadDb();
  return db.users.find((user) => user.email === email.toLowerCase());
}

export async function getWorkspace(userId: string) {
  const db = await loadDb();
  const user = db.users.find((item) => item.id === userId);
  if (!user) return null;
  const account = db.accounts.find((item) => item.id === user.accountId);
  if (!account) return null;
  const agents = db.agents.filter((item) => item.accountId === account.id);
  const phoneLines = db.phoneLines.filter((item) => item.accountId === account.id);
  return { account, user, agents, phoneLines };
}

export async function addAgent(accountId: string, input: Pick<Agent, "name" | "voice" | "systemInstructions" | "welcomeMessage">) {
  const db = await loadDb();
  const account = db.accounts.find((item) => item.id === accountId);
  if (!account) throw new Error("Account not found");
  if (account.mode === "personal" && db.agents.some((agent) => agent.accountId === accountId && agent.active)) {
    throw new Error("Personal accounts are limited to one active agent");
  }
  const timestamp = now();
  const agent: Agent = { id: id("agt"), accountId, mode: account.mode, active: true, createdAt: timestamp, updatedAt: timestamp, ...input };
  db.agents.push(agent);
  await saveDb(db);
  return agent;
}

export async function getActiveAgent(accountId: string) {
  const db = await loadDb();
  return db.agents.find((agent) => agent.accountId === accountId && agent.active) ?? null;
}

export async function updateActiveAgent(accountId: string, input: Partial<Pick<Agent, "name" | "voice" | "voiceStyle" | "responseStyle" | "systemInstructions" | "welcomeMessage" | "aiDisclosure" | "trainingNotes">>) {
  const db = await loadDb();
  const agent = db.agents.find((item) => item.accountId === accountId && item.active);
  if (!agent) return null;
  Object.assign(agent, input, { updatedAt: now() });
  await saveDb(db);
  return agent;
}

export async function listAgentStudio(accountId: string, agentId: string) {
  const db = await loadDb();
  return {
    scenarios: db.agentScenarios.filter((item) => item.accountId === accountId && item.agentId === agentId),
    scripts: db.agentScripts.filter((item) => item.accountId === accountId && item.agentId === agentId)
  };
}

export async function upsertAgentScenario(input: Omit<AgentScenario, "id" | "createdAt" | "updatedAt"> & { id?: string }) {
  const db = await loadDb();
  const existing = input.id ? db.agentScenarios.find((item) => item.id === input.id && item.accountId === input.accountId && item.agentId === input.agentId) : null;
  if (existing) {
    Object.assign(existing, input, { updatedAt: now() });
    await saveDb(db);
    return existing;
  }
  const timestamp = now();
  const scenario: AgentScenario = { id: input.id ?? id("scn"), createdAt: timestamp, updatedAt: timestamp, ...input };
  db.agentScenarios.push(scenario);
  await saveDb(db);
  return scenario;
}

export async function upsertAgentScript(input: Omit<AgentScript, "id" | "createdAt" | "updatedAt"> & { id?: string }) {
  const db = await loadDb();
  const existing = input.id ? db.agentScripts.find((item) => item.id === input.id && item.accountId === input.accountId && item.agentId === input.agentId) : null;
  if (existing) {
    Object.assign(existing, input, { updatedAt: now() });
    await saveDb(db);
    return existing;
  }
  const timestamp = now();
  const script: AgentScript = { id: input.id ?? id("scr"), createdAt: timestamp, updatedAt: timestamp, ...input };
  db.agentScripts.push(script);
  await saveDb(db);
  return script;
}

export async function addCall(input: Omit<CallLog, "id" | "createdAt" | "updatedAt">) {
  const db = await loadDb();
  const timestamp = now();
  const call: CallLog = { id: id("call"), createdAt: timestamp, updatedAt: timestamp, ...input };
  db.calls.push(call);
  await saveDb(db);
  return call;
}

export async function listCallsForAccount(accountId: string) {
  const db = await loadDb();
  return db.calls.filter((call) => call.accountId === accountId).sort((a, b) => b.createdAt.localeCompare(a.createdAt));
}

export async function findPhoneLineByE164(e164: string) {
  const db = await loadDb();
  return db.phoneLines.find((line) => line.e164 === e164 && line.active) ?? null;
}

export async function upsertDevice(input: Omit<DeviceRegistration, "id" | "lastSeenAt">) {
  const db = await loadDb();
  const existing = db.devices.find((item) => item.userId === input.userId && item.deviceId === input.deviceId);
  if (existing) {
    Object.assign(existing, input, { lastSeenAt: now() });
    await saveDb(db);
    return existing;
  }
  const device: DeviceRegistration = { id: id("dev"), lastSeenAt: now(), ...input };
  db.devices.push(device);
  await saveDb(db);
  return device;
}

export async function addToolEvent(input: Omit<ToolEvent, "id" | "createdAt" | "updatedAt">) {
  const db = await loadDb();
  const timestamp = now();
  const event: ToolEvent = { id: id("tool"), createdAt: timestamp, updatedAt: timestamp, ...input };
  db.toolEvents.push(event);
  await saveDb(db);
  return event;
}

export async function listPendingToolEventsForAccount(accountId: string) {
  const db = await loadDb();
  return db.toolEvents.filter((event) => event.accountId === accountId && ["requested", "sent_to_device"].includes(event.status)).sort((a, b) => b.createdAt.localeCompare(a.createdAt));
}

export async function resolveToolEvent(accountId: string, eventId: string, status: "completed" | "denied" | "failed") {
  const db = await loadDb();
  const event = db.toolEvents.find((item) => item.accountId === accountId && item.id === eventId);
  if (!event) return null;
  event.status = status;
  event.updatedAt = now();
  await saveDb(db);
  return event;
}

export async function findCallByProviderId(providerCallId: string) {
  const db = await loadDb();
  return db.calls.find((call) => call.providerCallId === providerCallId) ?? null;
}

function defaultAgentInstructions(mode: AccountMode) {
  const base = "You are Me.AI, a concise, calm AI voice agent. You help with calls, routing, reminders, and safe delegation. Never claim to complete an action unless the iOS device or backend confirms it.";
  return mode === "personal" ? `${base} You represent one person and protect their time, privacy, and attention.` : `${base} You represent a business workspace and must follow routing rules, escalation paths, and workspace permissions.`;
}
