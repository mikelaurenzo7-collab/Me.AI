# App Review notes draft

## Summary for reviewer

Me.AI is a voice-first communication assistant for iPhone and CarPlay. The app helps users create call requests, delegate supported call flows, receive summaries, and approve simple native actions.

## CarPlay explanation

The CarPlay interface is limited to glanceable communication states:

- Me.AI readiness
- active call status
- delegate or take-over action
- confirmation required state
- recent summary shortcut

The app does not show long transcripts, dense settings, or arbitrary third-party app controls in CarPlay.

## AI disclosure

Me.AI is an AI assistant. When communicating in contexts where disclosure is appropriate, the assistant should be transparent that it is an AI assistant.

## Test account

To be filled before TestFlight/App Store review:

- Email:
- Password or sign-in method:
- Test phone number:
- Demo mode instructions:

## Test flow

1. Install the app.
2. Sign in with the test account.
3. Complete or skip provider setup in demo mode.
4. Open the Today cockpit.
5. Open setup flow.
6. Open active-call demo state.
7. Connect CarPlay Simulator.
8. Confirm Me.AI CarPlay template appears.
9. Verify no dense text or unsafe controls appear on CarPlay.
10. Confirm summary and native-action confirmation states.

## Known limitations for first build

- Business fleet mode may be hidden or limited.
- Live phone routing requires configured provider credentials.
- CarPlay availability depends on Apple entitlement approval.
