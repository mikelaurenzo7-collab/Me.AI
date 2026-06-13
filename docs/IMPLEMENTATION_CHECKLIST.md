# Implementation checklist

## Done in initial scaffold

- Standalone Me.AI repo initialized.
- Backend TypeScript workspace added.
- Local JSON persistence added.
- Personal and business account modes added.
- One-agent personal-account guard added.
- OpenAI realtime session route added.
- Native tool registry added.
- Outbound call queue route added.
- Device registration route added.
- Twilio/OpenAI webhook placeholders added.
- iOS CarPlay manifest and entitlement templates added.
- Swift source skeleton added for dashboard, CallKit, CarPlay, App Intents, native tools, and API client.
- Supabase schema draft added.

## Next backend work

1. Replace unresolved inbound webhook account lookup with phone-line resolution.
2. Add Twilio number search and provisioning routes.
3. Add Twilio media/SIP bridge or OpenAI SIP connection.
4. Add long-lived device WebSocket or push-notification delivery for native tool calls.
5. Add transcript and summary persistence.
6. Add RLS policies before using Supabase in production.
7. Add tests for personal vs business boundaries.

## Next iOS work

1. Generate the Xcode project around `ios/Sources`.
2. Add signed bundle ID and provisioning profiles.
3. Request Apple CarPlay communication entitlement.
4. Add PushKit token registration.
5. Wire API auth token storage in Keychain.
6. Wire App Intents to backend routes.
7. Add Live Activity and WidgetKit target.
8. Test CarPlay with Xcode simulator.

## App Store review risks

- CarPlay entitlement approval is not automatic.
- Cross-app automation must be allowlisted and permissioned.
- Do not claim arbitrary control of all CarPlay apps.
- Outbound AI calling needs clear user initiation and transparency.
- Sensitive actions require confirmation.
