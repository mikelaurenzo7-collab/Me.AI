# CarPlay entitlement request draft

## App name

Me.AI

## Category requested

Communication / VoIP and voice-based conversational assistant for CarPlay-safe call handling.

## What the app does

Me.AI helps users manage calls hands-free while driving. The user can ask Siri to create an outbound call request, delegate a supported call flow to Me.AI, receive a short call summary, and approve simple native actions such as route handoff or reminder creation.

## Why CarPlay is needed

The product's core use case happens while the user is driving. The CarPlay experience is intentionally limited to glanceable status and safe call controls so the user does not need to pick up the phone.

## CarPlay surfaces

- Me.AI status
- WidgetKit operator status companion for non-driving glanceability
- active call status
- delegate or take-over call action
- confirmation required notification
- recent call summary shortcut

## Safety controls

- No dense reading in CarPlay.
- No long transcripts in CarPlay.
- No arbitrary control of third-party apps.
- No sensitive action without confirmation.
- Call actions are routed through CallKit-compatible flows.
- Siri/App Intents are used for hands-free initiation.
- Native tools are allowlisted.

## Data and privacy

Me.AI processes call metadata, transcripts when enabled, summaries, user instructions, device tokens, and native tool requests. Secrets are stored only on the backend. The iOS app does not contain OpenAI, Twilio, or Supabase service keys.

## Test instructions for Apple

1. Install the TestFlight build.
2. Sign in with the review account.
3. Complete setup permissions.
4. Open CarPlay Simulator.
5. Confirm the Me.AI status template appears.
6. Trigger an active-call demo state.
7. Confirm only status, delegate, take-over, and confirmation actions are visible.
8. Add the Me.AI widget to the Home Screen or Lock Screen and confirm it shows the same high-level operator readiness without transcripts or sensitive call content.
