# Me.AI architecture

## Product

Me.AI is the standalone repo for Wingman, an OpenAI-powered personal voice agent for iOS, Siri, CallKit, and CarPlay-safe driving workflows.

## Modes

### Personal

- One account.
- One primary agent.
- One primary phone line.
- Simple controls for voice, instructions, contacts, call handling, quiet hours, and permissions.

### Business

- Workspace account.
- Multiple users.
- Multiple agents.
- Multiple numbers.
- Fleet view, routing, transcripts, analytics, and admin controls.

## Provider roles

- OpenAI: realtime voice, reasoning, tool-calling, summaries, memory extraction, and agent orchestration.
- Twilio: phone numbers, inbound calls, outbound calls, and call status webhooks.
- Supabase: production database, auth, RLS, and audit history.
- Apple: Siri/App Intents, CallKit, PushKit, MapKit, EventKit, and CarPlay-safe UI.

## Wireline reference areas

Bring over ideas and patterns, not the product shell:

- Voice provisioning architecture.
- Agent readiness model.
- Account and workspace separation.
- Supabase/RLS discipline.
- Production env naming discipline.
- Business fleet concepts.

Do not merge Wireline UI, branding, marketing pages, or authenticated app shell into Me.AI unless explicitly chosen later.
