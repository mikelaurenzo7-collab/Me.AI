# Supabase setup plan

## Current decision

Do not use the existing Wireline-related Supabase project for Me.AI.

## Safe live setup options

### Option A: dedicated project

Create a new Supabase project named `me-ai` under the connected organization.

Recommended.

### Option B: isolated branch

Create a branch named `me-ai-dev` only if project creation is not available and the branch does not affect the existing default branch.

Acceptable only for development.

## Repo work completed

The repo now includes isolated Supabase migration files:

- `supabase/migrations/20260613160000_me_ai_core.sql`
- `supabase/migrations/20260613160500_me_ai_rls.sql`

These files are not applied to any live database yet.

## Required live setup steps

1. Create dedicated Supabase project or safe branch.
2. Confirm project ref.
3. Add backend environment variables for the Me.AI backend only.
4. Apply core schema migration.
5. Apply RLS migration.
6. Run a smoke test for account creation, Agent Studio, call history, and privacy export.
7. Do not connect production iOS builds until auth and policy behavior are verified.

## Guardrails

- Do not modify the existing Wireline project default branch.
- Do not apply Me.AI migrations to Wireline production.
- Do not reuse Wireline product data.
- Do not share live provider configuration between Wireline and Me.AI.
