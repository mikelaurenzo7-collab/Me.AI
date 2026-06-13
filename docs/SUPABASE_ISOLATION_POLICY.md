# Supabase isolation policy

## Decision

Me.AI must not use or modify the existing Wireline Supabase project.

The existing connected Supabase project may be used only as a reference for architecture patterns. Do not run Me.AI migrations, create Me.AI tables, deploy Me.AI functions, or change database settings there.

## Preferred path

Create a dedicated Supabase project for Me.AI.

Suggested project name: `me-ai`

Purpose:

- isolated database
- isolated auth
- isolated storage
- isolated logs
- isolated project settings

## Backup path

Use an isolated development branch only if project creation is not available and only if it does not affect the default branch.

Suggested branch name: `me-ai-dev`

Rules:

- no Me.AI writes to the existing default branch
- no Me.AI migrations on the existing default branch
- no shared product configuration between Wireline and Me.AI

## Current status

A Supabase organization is connected, but only one existing project was found. Treat that project as Wireline-related unless Michael explicitly confirms otherwise.

Do not apply `docs/SUPABASE_SCHEMA.sql` or any future Me.AI migration to the existing project unless Michael explicitly authorizes a safe branch or a separate project is created.

## Repo-safe work

It is safe to continue building:

- SQL migration files
- local schema docs
- backend Supabase adapter interfaces
- RLS policy files
- seed files
- deployment instructions

These files can be prepared in the repo without touching a live Supabase database.

## Required before live Supabase writes

- dedicated Me.AI Supabase project, or
- isolated Me.AI branch with no impact on the existing default branch
- confirmed project ref
- confirmed environment variable names
- migration dry-run plan
