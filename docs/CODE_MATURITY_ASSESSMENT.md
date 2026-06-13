# Code maturity assessment

## Summary

Me.AI is currently an early scaffold / prototype, not a mature MVP, beta, or production-ready iOS app.

The product strategy, architecture, Apple readiness docs, and design direction are relatively mature. The actual runnable code is still young.

## Maturity scale

- 0: idea only
- 1: scaffold
- 2: prototype skeleton
- 3: early MVP foundation
- 4: local MVP
- 5: internal alpha
- 6: TestFlight beta
- 7: public beta
- 8: production v1
- 9: mature production
- 10: scaled production

## Current score by area

### Product strategy: 7/10

The iPhone-first MVP direction is clear. CarPlay is properly treated as a later extension. Activation, call handling, summaries, and confirmations are now the core.

### Design and UX: 5/10

Figma and SwiftUI screens exist for the main direction, but the app still needs complete clickable flows, final visual polish, real data states, empty states, error states, and simulator review.

### Backend architecture: 3/10

The backend has a real Fastify app structure, routes, domain models, OpenAI realtime session route, submission gates route, tool registry, and basic tests. It is not production-integrated yet.

### Backend production readiness: 1.5/10

Missing live provider validation, Twilio provisioning, webhook signature validation, real database integration, RLS policies, rate limiting, monitoring, and deployment hardening.

### iOS app code: 2/10

The app has SwiftUI screens, App Intents, CallKit scaffold, CarPlay scaffold, API client scaffold, design tokens, and an XcodeGen project spec. It has not been locally compiled or run in Xcode yet.

### iOS production readiness: 1/10

Missing local build validation, signing, real auth token storage, PushKit wiring, widget target, Live Activity target, real CallKit state machine, device testing, and App Store packaging.

### Integrations: 1/10

OpenAI session creation route exists, but live voice sessions, Twilio call routing, PushKit, Supabase production persistence, and provider loops are not wired end-to-end.

### Tests and CI: 2/10

Backend Vitest setup and smoke tests exist. iOS tests, provider integration tests, build validation, and E2E tests do not exist yet.

### Apple submission readiness: 2/10

Apple submission docs, privacy manifest draft, metadata draft, review notes, and submission gates exist. Actual Apple Developer signing, TestFlight upload, screenshots, App Store Connect metadata, and entitlement approval are not done.

## Honest status

Me.AI has a strong foundation and a clear product path, but it is still a young codebase.

A realistic label is:

Early iPhone-first prototype scaffold with strong architecture/docs, not yet a runnable validated MVP.

## What must happen to become a real MVP

1. Generate the Xcode project locally.
2. Fix Swift compile issues.
3. Run the app in iPhone Simulator.
4. Wire navigation and state across actual flows.
5. Add real auth/session handling.
6. Add real phone number provisioning.
7. Connect inbound and outbound call flows.
8. Wire CallKit and PushKit on a real device.
9. Persist call history and summaries in Supabase.
10. Add widget and Live Activity targets.
11. Add provider webhooks and validation.
12. Add proper tests and smoke-test scripts.

## Confidence note

The next major truth test is a local Xcode build. Until it compiles and runs on iPhone Simulator, the iOS side should be considered source scaffold, not a working app.
