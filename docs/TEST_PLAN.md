# Test plan

## Local backend smoke tests

- `GET /health` returns service status.
- Register personal account.
- Register business account.
- Personal account rejects a second active agent.
- OpenAI realtime session route returns configuration when API key is missing.
- Outbound call route queues a call without dialing in local mode.
- Device registration accepts push and VoIP token placeholders.
- Native tool list returns allowlisted tools only.
- Native tool dispatch creates an event.

## iOS simulator tests

- App launches to Today cockpit.
- Account mode picker works.
- Setup rows are visible.
- Permission-denied states do not crash.
- Active call demo state displays take-over and keep-screening actions.
- Native tool confirmation states are clear.

## CarPlay simulator tests

- CarPlay scene appears after simulator connection.
- Root template title is Me.AI.
- Status is glanceable.
- Active-call template avoids long text.
- Confirmation state has clear approve and decline path.
- Touch, knob, and voice-only paths remain usable.

## Provider integration tests

- Twilio webhook signature validation passes.
- Inbound phone number resolves to account and agent.
- PushKit VoIP token receives call notification.
- CallKit reports incoming call.
- User can answer, decline, delegate, and take over.
- OpenAI session starts and tool calls are emitted.
- Native tool event is delivered to iOS device.
- Summary is stored after call completion.

## App Store review tests

- Fresh install setup flow is complete.
- Demo account is available.
- No provider credentials are present in iOS bundle.
- Privacy manifest matches actual data collection.
- App works without CarPlay connected.
- CarPlay templates appear only after entitlement-approved build.
