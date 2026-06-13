-- Me.AI RLS policies
-- Apply only to a dedicated Me.AI Supabase project or an isolated Me.AI branch.

create or replace function app.current_account_id()
returns uuid
language sql
stable
as $$
  select nullif(current_setting('request.jwt.claims', true)::jsonb ->> 'account_id', '')::uuid
$$;

create policy accounts_select_own on accounts
  for select using (id = app.current_account_id());

create policy users_select_own_account on users
  for select using (account_id = app.current_account_id());

create policy agents_select_own_account on agents
  for select using (account_id = app.current_account_id());

create policy agent_scenarios_select_own_account on agent_scenarios
  for select using (account_id = app.current_account_id());

create policy agent_scripts_select_own_account on agent_scripts
  for select using (account_id = app.current_account_id());

create policy phone_lines_select_own_account on phone_lines
  for select using (account_id = app.current_account_id());

create policy device_registrations_select_own_account on device_registrations
  for select using (account_id = app.current_account_id());

create policy call_logs_select_own_account on call_logs
  for select using (account_id = app.current_account_id());

create policy tool_events_select_own_account on tool_events
  for select using (account_id = app.current_account_id());

-- Writes should go through the trusted backend service role only for MVP.
-- Direct client writes can be added later with narrower policies after the auth model is finalized.
