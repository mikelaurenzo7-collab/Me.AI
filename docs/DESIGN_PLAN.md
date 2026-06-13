# Me.AI design plan

## Decision

Do not wait on design. Start the design system now, but avoid final pixel-perfect polish until the Xcode project, CarPlay entitlement path, and live call states are stable.

## Design principle

Me.AI should feel like a calm personal operator, not a dashboard-heavy enterprise app.

The product should be:

- voice-first
- low distraction
- high trust
- fast to confirm
- visibly safe while driving
- personal by default, business-capable when upgraded

## Surfaces

### iPhone cockpit

Purpose: setup, trust, permissions, history, and deeper control.

Primary screens:

1. Today
2. Active Call
3. Agent Setup
4. Contacts and Rules
5. Call History
6. Native Tools
7. Business Workspace
8. Settings

### CarPlay surface

Purpose: glance, delegate, answer, decline, and confirm only.

Primary templates:

1. Me.AI Status
2. Active Call
3. Call Delegation
4. Recent Call Summary
5. Safe Confirmations

Avoid dense settings, long transcripts, large forms, or broad app control claims in CarPlay.

### Widget and Live Activity

Purpose: ambient entry point and real-time status.

States:

- Ready
- Screening call
- Delegated call active
- Action needs confirmation
- Summary ready

## Visual direction

### Tone

Calm, premium, native, private, and human.

### Palette

- Base: soft near-white or warm neutral
- Ink: high-contrast charcoal
- Accent: focused electric blue or deep iris
- Status: system semantic colors for live, waiting, warning, and complete

### Typography

Use native Apple typography and Dynamic Type first. Do not over-customize fonts before App Store and CarPlay constraints are known.

### Component style

- Large confirmation cards
- Rounded native surfaces
- Clear call-state chips
- One primary action per state
- Destructive actions separated and confirmed
- Minimal motion

## Information hierarchy

The app should answer three questions instantly:

1. Is Me.AI ready?
2. Who or what is Me.AI handling?
3. What needs my confirmation?

## Key flows to design first

1. First-run setup
2. Connect phone number
3. Choose personal or business mode
4. Grant Siri, notifications, contacts, calendar, reminders, and location permissions
5. Inbound call: answer myself, delegate, decline
6. Outbound Siri call: confirm target and objective
7. Native tool confirmation: route, reminder, message draft, media handoff
8. Post-call summary and action items

## Design QA bar

- No screen should require reading while driving.
- CarPlay should never show dense paragraphs.
- Every high-impact action should have a clear confirmation state.
- Personal mode should never look like an enterprise dashboard.
- Business mode should add fleet power without polluting personal mode.
- Copy should use Me.AI everywhere.
