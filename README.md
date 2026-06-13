# Me.AI

Me.AI is a native iOS and CarPlay-integrated personal AI voice agent powered by OpenAI.

The product direction is a trusted assistant that can answer, screen, place, summarize, and delegate calls while keeping personal and business accounts separated.

## Core idea

- Personal users get one primary Me.AI agent.
- Business users can upgrade into a fleet/workspace model.
- OpenAI powers realtime voice intelligence, tool-calling, summaries, and orchestration.
- Twilio handles phone numbers, inbound calls, outbound calls, and status webhooks.
- iOS handles Siri and App Intents, CallKit, PushKit, CarPlay-safe surfaces, Maps, Calendar, and supported media actions.

## Example commands

- Hey Siri, tell Me.AI to call the office and say I am running five minutes late.
- Hey Siri, route this call to Me.AI.
- Hey Siri, ask Me.AI to navigate to my next meeting.

## Repository plan

```txt
backend/   Node.js and TypeScript orchestration API
ios/       SwiftUI, App Intents, CallKit, PushKit, CarPlay skeleton
docs/      architecture, env vars, schema, and implementation plan
```

Wireline remains the reference system for voice provisioning, account models, and production discipline. Me.AI is the standalone product repo.
