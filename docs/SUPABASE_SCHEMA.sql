create extension if not exists "pgcrypto";

create type account_mode as enum ('personal', 'business');
create type call_direction as enum ('inbound', 'outbound');
create type call_status as enum ('queued', 'ringing', 'active', 'completed', 'failed', 'missed');
create type tool_status as enum ('requested', 'sent_to_device', 'completed', 'failed', 'denied');

create table if not exists accounts (
  id uuid primary key default gen_random_uuid(),
  mode account_mode not null,
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  email text not null unique,
  display_name text not null,
  role text not null default 'owner',
  created_at timestamptz not null default now()
);

create table if not exists agents (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  mode account_mode not null,
  name text not null,
  active boolean not null default true,
  voice text not null default 'alloy',
  system_instructions text not null,
  welcome_message text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists one_active_personal_agent on agents(account_id) where mode = 'personal' and active = true;

create table if not exists phone_lines (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  agent_id uuid not null references agents(id) on delete cascade,
  e164 text not null unique,
  label text not null,
  twilio_number_sid text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists device_registrations (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  user_id uuid not null references users(id) on delete cascade,
  device_id text not null,
  voip_token text,
  push_token text,
  last_seen_at timestamptz not null default now(),
  unique(user_id, device_id)
);

create table if not exists call_logs (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  agent_id uuid not null references agents(id) on delete cascade,
  phone_line_id uuid references phone_lines(id) on delete set null,
  direction call_direction not null,
  status call_status not null default 'queued',
  from_number text,
  to_number text,
  provider_call_id text,
  transcript text,
  summary text,
  outcome text,
  started_at timestamptz,
  ended_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists tool_events (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  call_log_id uuid references call_logs(id) on delete cascade,
  tool_name text not null,
  status tool_status not null default 'requested',
  request_payload jsonb not null default '{}'::jsonb,
  result_payload jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table accounts enable row level security;
alter table users enable row level security;
alter table agents enable row level security;
alter table phone_lines enable row level security;
alter table device_registrations enable row level security;
alter table call_logs enable row level security;
alter table tool_events enable row level security;
