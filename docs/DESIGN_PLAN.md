# Me.AI design plan

## Decision

Me.AI is iPhone-first. Do not wait on design, but focus design energy on the regular iPhone experience before CarPlay polish.

CarPlay remains a premium extension, not the MVP center.

## Design principle

Me.AI should feel like a calm personal operator, not a dashboard-heavy enterprise app.

The product should be:

- voice-first
- low distraction
- high trust
- fast to activate
- fast to confirm
- useful outside the car
- safe while driving when CarPlay is available
- personal by default, business-capable when upgraded

## Surfaces

### iPhone cockpit

Purpose: setup, trust, permissions, activation, active call handling, summaries, history, and deeper control.

Primary screens:

1. Today
2. Activation Setup
3. Active Call
4. Incoming Call Decision
5. Outbound Request Composer
6. Pending Confirmation
7. Call Summary
8. Call History
9. Contacts and Rules
10. Native Tools
11. Business Workspace
12. Settings

### Siri, Shortcuts, and widgets

Purpose: reach Me.AI without hunting for the app.

Primary activation surfaces:

1. Siri phrase
2. Action Button shortcut
3. Back Tap shortcut
4. Lock Screen widget
5. Home Screen widget
6. Live Activity
7. Apple Watch shortcut later

### CarPlay surface

Purpose: glance, delegate, answer, decline, and confirm only when the user is driving and CarPlay is available.

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

- Large activation cards
- Large confirmation cards
- Rounded native surfaces
- Clear call-state chips
- One primary action per state
- Destructive actions separated and confirmed
- Minimal motion

## Information hierarchy

The app should answer four questions instantly:

1. Is Me.AI ready?
2. How do I activate Me.AI right now?
3. Who or what is Me.AI handling?
4. What needs my confirmation?

## Key flows to design first

1. First-run setup
2. Activation Setup
3. Connect phone number
4. Choose personal or business mode
5. Grant Siri, notifications, contacts, calendar, reminders, and location permissions
6. Inbound call: answer myself, delegate, decline
7. Outbound Siri call: confirm target and objective
8. Native tool confirmation: route, reminder, message draft, media handoff
9. Post-call summary and action items
10. Widget/Live Activity states

## Design QA bar

- The iPhone app should feel complete without CarPlay.
- No screen should require reading while driving.
- CarPlay should never show dense paragraphs.
- Every high-impact action should have a clear confirmation state.
- Personal mode should never look like an enterprise dashboard.
- Business mode should add fleet controls without polluting personal mode.
- Copy should use Me.AI everywhere.
