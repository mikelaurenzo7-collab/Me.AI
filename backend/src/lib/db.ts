import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname } from "node:path";
import { nanoid } from "nanoid";
import { env } from "./env.js";
import type { Account, AccountMode, Agent, CallLog, DeviceRegistration, PhoneLine, ToolEvent, User } from "../domain/types.js";

type Database = {
  accounts: Account[];
  users: User[];
  agents: Agent[];
  phoneLines: PhoneLine[];
  devices: DeviceRegistration[];
  calls: CallLog[];
  toolEvents: ToolEvent[];
};

const empty = (): Database => ({ accounts: [], users: [], agents: [], phoneLines: [], devices: [], calls: [], toolEvents: [] });
const now = () => new Date().toISOString();
const id = (prefix: string) => `${prefix}_${nanoid(12)}`;
let cache: Database | null = null;

export async function loadDb(): Promise<Database> {
  if (cache) return cache;
  try {
    const raw = await readFile(env.DB_FILE, "utf8");
    cache = JSON.parse(raw) as Database;
    return cache;
  } catch {
    cache = empty();
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
    systemInstructions: defaultAgentInstructions(input.mode),
    welcomeMessage: input.mode === "personal" ? "I am Me.AI. I can help with calls, routing, reminders, and driving-safe handoffs." : "You reached Me.AI. I can route your call and help the team respond quickly.",
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
  return db.calls
    .filter((call) => call.accountId === accountId)
    .sort((a, b) => b.createdAt.localeCompare(a.createdAt));
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
  return db.toolEvents
    .filter((event) => event.accountId === accountId && ["requested", "sent_to_device"].includes(event.status))
    .sort((a, b) => b.createdAt.localeCompare(a.createdAt));
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

function defaultAgentInstructions(mode: AccountMode) {
  const base = "You are Me.AI, a concise, calm AI voice agent. You help with calls, routing, reminders, and driving-safe delegation. Never claim to complete an action unless the iOS device or backend confirms it.";
  return mode === "personal" ? `${base} You represent one person and protect their time, privacy, and attention.` : `${base} You represent a business workspace and must follow routing rules, escalation paths, and workspace permissions.`;
}
