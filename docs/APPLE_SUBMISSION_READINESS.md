# Apple submission readiness

## Current status

Me.AI is in pre-submission architecture and scaffold stage. It is not ready for TestFlight or App Store submission yet.

## Submission blockers

These cannot be completed honestly from code alone:

1. Apple Developer account access and paid membership.
2. Bundle ID creation for `com.meai.app` or the final chosen identifier.
3. Provisioning profiles and signing certificates.
4. Apple-managed CarPlay communication entitlement approval.
5. Push notification capability and APNs keys.
6. Live Twilio credentials and phone number provisioning.
7. Live OpenAI API key configured only in backend/server secret storage.
8. App Store Connect listing, screenshots, privacy answers, export compliance, and review notes.
9. Physical or simulator testing with the CarPlay simulator and real iPhone device.

## Apple positioning

Me.AI should be submitted as a communication and voice-based conversational app with CarPlay-safe surfaces. The App Store and entitlement review narrative should emphasize:

- user-initiated call handling
- CallKit-backed communication flows
- Siri/App Intents for hands-free actions
- glanceable CarPlay UI only
- no dense reading while driving
- no arbitrary control of third-party apps
- explicit confirmation for sensitive actions

## MVP submission scope

The first Apple-reviewable build should include:

- account setup
- personal mode
- phone number connection or placeholder if TestFlight-only
- Siri/App Intents for safe request creation
- CallKit incoming/outgoing skeleton
- WidgetKit operator status widget for Home Screen, Lock Screen, and StandBy glanceability
- CarPlay status and active-call templates
- notifications for confirmations and summaries
- post-call summary screen
- privacy policy link
- clear AI disclosure

Business fleet mode should remain hidden or feature-flagged until personal mode is stable.

## Definition of ready for TestFlight

- Xcode project builds without warnings that affect signing or entitlements.
- Main app and WidgetKit extension use the same approved App Group identifier.
- All permissions have accurate purpose strings.
- App does not crash when permissions are denied.
- CallKit actions have predictable state transitions.
- No secret keys are shipped in the iOS bundle.
- CarPlay entitlement request has been submitted or approved.
- Privacy manifest is present.
- Test accounts and review notes are prepared.

## Definition of ready for App Store review

- All TestFlight smoke tests pass.
- CarPlay behavior is validated in simulator.
- App Store metadata and screenshots are complete.
- Privacy nutrition labels match actual data collection.
- Review notes explain CarPlay entitlement usage, AI calling disclosure, and test flow.
- Provider credentials are production-grade and monitored.
