# iOS and CarPlay blueprint

## North star

Me.AI is a voice-first communication agent for iPhone and CarPlay. It answers, screens, delegates, and places calls while offering narrow, permissioned action handoffs to native iOS capabilities.

## CarPlay scene manifest

The app target should declare a multi-scene lifecycle and a CarPlay template scene role:

- `UIApplicationSceneManifest`
- `UIApplicationSupportsMultipleScenes = true`
- `UISceneConfigurations`
- `CPTemplateApplicationSceneSessionRoleApplication`
- `UISceneDelegateClassName = CarPlaySceneDelegate`

## Entitlements

CarPlay communication apps require Apple-managed approval before the signed app can appear on a vehicle head unit.

Planned entitlement keys:

- `com.apple.developer.carplay-communication`
- `com.apple.developer.carplay-messaging` only if needed for backward compatibility
- Push notifications
- App Groups if widgets and app extension need shared state
- Siri capability

## Inbound call flow

1. Twilio receives call.
2. Backend resolves phone line to account and active Me.AI agent.
3. Backend starts a realtime/OpenAI voice session or bridge.
4. Backend sends VoIP push to iPhone.
5. iOS reports the call through CallKit.
6. User can answer, decline, delegate, or take over.
7. Backend stores transcript, summary, outcome, and native actions.

## Outbound Siri flow

1. User says a Me.AI Siri phrase.
2. App Intent validates recipient, purpose, and account mode.
3. iOS sends `/api/calls/outbound` to the backend.
4. Backend queues call and prepares the OpenAI prompt.
5. Twilio/OpenAI SIP bridge performs live call once configured.
6. Active call state returns to CallKit and CarPlay.

## Cross-app action model

Supported actions should stay narrow:

- route to a destination
- create calendar/reminder item
- draft a message
- hand off music/media request
- ask for user confirmation

Execution vectors:

- native framework action, when supported
- universal link, when the target app supports it
- Shortcuts handoff, only through an allowlist
- no arbitrary background automation

## Review checklist

- Test CarPlay scene with Xcode CarPlay Simulator.
- Test touch, knob, and voice-only flows.
- Confirm all call actions are CallKit-backed.
- Confirm no action executes without permission or allowlist.
- Confirm Live Activities and widgets are glanceable and not distracting.
- Confirm app copy says Me.AI everywhere.
