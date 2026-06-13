# Submission gates

## Gate 1: architecture locked

Status: in progress

Required:

- Product name is Me.AI everywhere.
- Personal and business modes are separated.
- CarPlay scope is limited and safe.
- OpenAI, Twilio, Supabase, and Apple roles are documented.
- Figma blueprint exists.

## Gate 2: local build

Status: not complete

Required:

- Xcode project exists.
- App target builds.
- Widget target builds.
- App Intents compile.
- Backend typecheck passes.
- Local backend smoke tests pass.

## Gate 3: provider integration

Status: not complete

Required:

- OpenAI realtime session works from backend.
- Twilio number provisioning works.
- Inbound webhook resolves account and phone line.
- PushKit notification reaches device.
- CallKit reports incoming call.
- Native tool events round-trip from OpenAI to iOS and back.

## Gate 4: Apple entitlement path

Status: not complete

Required:

- Apple Developer account configured.
- Bundle ID created.
- Capabilities configured.
- CarPlay communication entitlement request submitted.
- Entitlement approved or fallback non-CarPlay TestFlight plan chosen.

## Gate 5: TestFlight

Status: not complete

Required:

- Signed archive uploads.
- Internal TestFlight build installs.
- Reviewer/demo account works.
- Crash-free smoke test passes.
- Privacy manifest included.
- Review notes prepared.

## Gate 6: App Store submission

Status: not complete

Required:

- App Store metadata finalized.
- Screenshots finalized.
- Privacy nutrition labels completed.
- Support and privacy URLs live.
- Review notes complete.
- Production monitoring enabled.
