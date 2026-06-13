# Me.AI architecture

## Product

Me.AI is an OpenAI-powered personal voice agent for native iOS, Siri, CallKit, and CarPlay-safe driving workflows.

## Modes

### Personal

- One account.
- One primary Me.AI agent.
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
- Apple: Siri/App Intents, CallKit, PushKit, MapKit, EventKit, Live Activities, WidgetKit, and CarPlay-safe UI.

## iOS architecture

- App scene: SwiftUI cockpit for setup, account mode, permissions, call history, and active call state.
- CarPlay scene: `CPTemplateApplicationSceneDelegate` renders system-approved templates when CarPlay connects.
- Call layer: `CXProvider` and `CXCallController` handle incoming, delegated, and outbound VoIP call states.
- Siri/App Intents: App Intents expose high-level Me.AI commands such as start call, delegate call, route destination, and create reminder.
- Widget/Live Activity layer: small glanceable status entry points for call state and automation progress.
- Native tool bus: backend-approved tool calls are executed only through permissioned iOS handlers.

## CarPlay guardrails

Me.AI must not claim arbitrary control over all CarPlay apps. The safe route is to expose approved App Intents, universal-link handoffs, Shortcuts handoffs, CallKit flows, Maps routing, EventKit reminders, and supported media handoffs. Every high-impact action should be confirmed by the user or constrained by an explicit allowlist.

## Wireline reference areas

Bring over ideas and patterns, not the product shell:

- Voice provisioning architecture.
- Agent readiness model.
- Account and workspace separation.
- Supabase/RLS discipline.
- Production env naming discipline.
- Business fleet concepts.

Do not merge Wireline UI, branding, marketing pages, or authenticated app shell into Me.AI unless explicitly chosen later.
