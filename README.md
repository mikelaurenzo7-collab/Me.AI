# Me.AI

Me.AI is an iPhone-first personal AI call operator powered by OpenAI, with CarPlay as a premium extension when available.

The product direction is a trusted assistant that can answer, screen, place, summarize, and delegate calls while keeping personal and business accounts separated.

## Core idea

- Personal users get one primary Me.AI agent.
- Business users can upgrade into a fleet/workspace model.
- OpenAI powers realtime voice intelligence, tool-calling, summaries, and orchestration.
- Twilio handles phone numbers, inbound calls, outbound calls, and status webhooks.
- iPhone handles Siri and App Intents, CallKit, PushKit, widgets, Live Activities, Action Button, Back Tap, Maps, Calendar, and supported media actions.
- CarPlay remains a nice-to-have surface for safe, glanceable call state and confirmations.

## MVP focus

Me.AI should be useful even if a user never connects to CarPlay.

Primary MVP surfaces:

- iPhone cockpit
- Siri/App Intents
- CallKit call state
- Activation Setup
- inbound call screening/delegation
- outbound call request creation
- post-call summary
- pending action confirmations
- Lock Screen/Home Screen widgets

## Design

Figma blueprint: https://www.figma.com/design/29vo2CJbeKW3B1xvCJzbrM

The design system is now iPhone-first: iPhone for the main product, widgets and Live Activities for ambient status, Siri/Shortcuts for activation, and CarPlay for optional safe driving surfaces.

## Example commands

- Hey Siri, ask Me.AI.
- Hey Siri, tell Me.AI to call the office and say I am running five minutes late.
- Hey Siri, tell Me.AI to screen my next call.
- Hey Siri, ask Me.AI to summarize my last call.

## Repository plan

```txt
backend/   Node.js and TypeScript orchestration API
ios/       SwiftUI, App Intents, CallKit, PushKit, widgets, and CarPlay skeleton
docs/      architecture, env vars, schema, design, Apple submission, and production plans
```

## Submission status

Me.AI is not ready for Apple submission yet. The repo now tracks submission gates for architecture, local build, provider integration, Apple entitlement approval, TestFlight, and App Store review.

Key docs:

- `docs/IPHONE_FIRST_PRODUCT_STRATEGY.md`
- `docs/REGULAR_PHONE_ACTIVATION.md`
- `docs/ACTIVATION_SURFACES_RESEARCH.md`
- `docs/APPLE_SUBMISSION_READINESS.md`
- `docs/CARPLAY_ENTITLEMENT_REQUEST.md`
- `docs/APP_STORE_METADATA.md`
- `docs/APP_REVIEW_NOTES.md`
- `docs/SUBMISSION_GATES.md`
- `docs/TEST_PLAN.md`
- `docs/PRODUCTION_WIRING.md`

Wireline remains the reference system for voice provisioning, account models, and production discipline. Me.AI is the standalone product repo.
