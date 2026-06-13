# Me.AI architecture

## Product

Me.AI is an iPhone-first, OpenAI-powered personal call operator for native iOS, Siri, App Intents, CallKit, widgets, Live Activities, and optional CarPlay-safe driving workflows.

## Modes

### Personal

- One account.
- One primary Me.AI agent.
- One primary phone line.
- Simple controls for activation, voice, instructions, contacts, call handling, quiet hours, and permissions.

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
- Apple: Siri/App Intents, Shortcuts, CallKit, PushKit, MapKit, EventKit, Live Activities, WidgetKit, Action Button/Back Tap configuration guidance, and optional CarPlay-safe UI.

## iPhone-first architecture

- App scene: SwiftUI cockpit for setup, activation, account mode, permissions, call history, active call state, summaries, and pending confirmations.
- Activation layer: App Intents and App Shortcuts expose high-level Me.AI commands for Siri, widgets, Action Button, Back Tap, and Shortcuts.
- Call layer: `CXProvider` and `CXCallController` handle incoming, delegated, and outbound VoIP call states.
- Widget/Live Activity layer: glanceable status entry points for call state, pending confirmation, and summary readiness.
- Native tool bus: backend-approved tool calls are executed only through permissioned iOS handlers.

## CarPlay extension architecture

- CarPlay scene: `CPTemplateApplicationSceneDelegate` renders system-approved templates when CarPlay connects.
- CarPlay mirrors only the minimum safe call state and confirmation actions.
- CarPlay must not block the main iPhone MVP or TestFlight path.

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
