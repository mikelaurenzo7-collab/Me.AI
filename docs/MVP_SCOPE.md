# MVP scope

## Decision

The Me.AI MVP is regular iPhone-first. CarPlay is not required for the first useful product.

## MVP promise

Me.AI helps users manage calls from their iPhone:

- activate by Siri or shortcut
- screen or delegate calls
- place outbound call requests
- summarize calls
- confirm follow-up actions
- keep personal and business modes separated

## MVP user stories

### Activation

As a user, I can activate Me.AI from Siri, a widget, Action Button, Back Tap, or the app.

### Inbound call

As a user, I can let Me.AI screen a call, summarize who called, and tell me what needs attention.

### Outbound call

As a user, I can ask Me.AI to prepare or place an outbound call request with a clear objective.

### Confirmation

As a user, I can approve or decline follow-up actions before they happen.

### Call summary

As a user, I can review what happened after a call.

### Contact rules

As a user, I can define who Me.AI can handle, who should always ring through, and who should be screened.

## MVP screens

1. Today cockpit
2. Activation Setup
3. Setup checklist
4. Active call
5. Incoming call decision
6. Outbound request composer
7. Pending confirmation
8. Call summary
9. Call history
10. Contact rules
11. Settings

## MVP backend

1. accounts
2. users
3. agents
4. phone lines
5. device registrations
6. call logs
7. tool events
8. OpenAI realtime session route
9. provider webhook routes
10. summary and outcome persistence

## Deferred until after MVP

1. CarPlay entitlement-dependent UX
2. advanced business fleet controls
3. Apple Watch native app
4. deep third-party app integrations
5. advanced analytics
6. multi-agent business orchestration

## MVP success criteria

- The product is useful without CarPlay.
- A user can understand how to activate Me.AI in under one minute.
- A user can see call status and summaries on iPhone.
- Sensitive actions are confirmed before completion.
- The app can be tested through TestFlight without waiting for CarPlay approval.
