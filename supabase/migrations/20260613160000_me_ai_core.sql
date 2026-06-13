-- Me.AI core schema
-- Apply only to a dedicated Me.AI Supabase project or an isolated Me.AI branch.

create extension if not exists pgcrypto;

create type if not exists account_mode as enum ('personal', 'business');
create type if not exists user_role as enum ('owner', 'admin', 'member');
create type if not exists call_direction as enum ('inbound', 'outbound');
create type if not exists call_status as enum ('queued', 'ringing', 'active', 'completed', 'failed', 'missed');
create type if not exists response_style as enum ('concise', 'balanced', 'detailed', 'warm', 'formal', 'direct');
create type if not exists tool_status as enum ('requested', 'sent_to_device', 'completed', 'failed', 'denied');

create table if not exists accounts (
  id uuid primary key default gen_random_uuid(),
  mode account_mode not null default 'personal',
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  email text not null unique,
  display_name text not null,
  role user_role not null default 'owner',
  created_at timestamptz not null default now()
);

create table if not exists agents (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  mode account_mode not null default 'personal',
  name text not null default 'Me.AI',
  active boolean not null default true,
  voice text not null default 'alloy',
  voice_style text not null default 'Calm, professional',
  response_style response_style not null default 'concise',
  system_instructions text not null,
  welcome_message text not null,
  ai_disclosure text not null default 'This is Me.AI, an AI assistant.',
  training_notes text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists agent_scenarios (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  agent_id uuid not null references agents(id) on delete cascade,
  name text not null,
  trigger text not null default '',
  goal text not null default '',
  escalation_rule text not null default '',
  allowed_actions text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists agent_scripts (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  agent_id uuid not null references agents(id) on delete cascade,
  name text not null,
  purpose text not null default '',
  body text not null default '',
  when_to_use text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists phone_lines (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  agent_id uuid not null references agents(id) on delete cascade,
  e164 text not null unique,
  label text not null,
  provider_number_id text,
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
  call_log_id uuid references call_logs(id) on delete set null,
  tool_name text not null,
  status tool_status not null default 'requested',
  request jsonb not null default '{}'::jsonb,
  result jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table accounts enable row level security;
alter table users enable row level security;
alter table agents enable row level security;
alter table agent_scenarios enable row level security;
alter table agent_scripts enable row level security;
alter table phone_lines enable row level security;
alter table device_registrations enable row level security;
alter table call_logs enable row level security;
alter table tool_events enable row level security;
