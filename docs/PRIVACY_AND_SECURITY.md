# Privacy and security model

## Core rule

Me.AI must protect user attention, communication privacy, and provider credentials.

## Data categories

Me.AI may process:

- account profile
- email address
- phone numbers
- call metadata
- call transcript when enabled
- call summary
- user instructions
- tool request payloads
- device push tokens
- diagnostics and crash logs

## Sensitive data handling

- Store provider credentials only in backend secret storage.
- Do not ship provider service keys in the iOS app.
- Require confirmation before message drafts, calendar or reminder changes, and sensitive actions.
- Avoid showing long transcripts on CarPlay.
- Keep CarPlay content glanceable and minimal.
- Use account and workspace boundaries for personal and business data.

## AI disclosure

Me.AI should disclose that it is an AI assistant when interacting with third parties where appropriate. The product must not imply that the AI is a human caller.

## Backend security requirements

- Validate webhook signatures before production.
- Add rate limits before public release.
- Add audit logs for tool calls and call state changes.
- Add RLS policies before moving from local JSON to Supabase.
- Use least-privilege API keys where possible.
- Redact credentials from logs.

## iOS security requirements

- Store auth tokens in Keychain.
- Use HTTPS endpoints in production.
- Use APNs tokens only for the owning account.
- Handle denied permissions gracefully.
- Keep all provider calls behind the backend.

## Retention policy draft

- Call metadata: retained until user deletes account or workspace policy removes it.
- Transcripts: optional, user-controllable, deletable.
- Summaries: deletable from call history.
- Device tokens: removed on logout or device unlink.
