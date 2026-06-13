# iPhone-first product strategy

## Decision

Me.AI should be iPhone-first. CarPlay remains important, but it should be treated as a premium extension rather than the center of the MVP.

## Why

Most users receive and manage more calls outside the car than inside it. Not every user has CarPlay, but every target user has an iPhone. The fastest path to product-market fit is therefore the regular iPhone experience:

- Siri activation
- regular incoming calls
- regular outbound calls
- CallKit experience
- Action Button shortcut
- Back Tap shortcut
- Lock Screen widget
- Home Screen widget
- Live Activity
- Apple Watch later
- CarPlay later

## New MVP priority

### Must-have for MVP

1. iPhone cockpit
2. Siri/App Intents activation
3. CallKit call state
4. phone number connection
5. inbound call screening/delegation
6. outbound call request creation
7. post-call summary
8. pending action confirmations
9. Activation Setup screen
10. Lock Screen/Home Screen widget plan

### Should-have soon after MVP

1. Action Button shortcut setup
2. Back Tap shortcut setup
3. Apple Watch shortcut support
4. richer call history
5. contact-specific rules
6. quiet hours
7. business mode feature flag

### Nice-to-have / later

1. CarPlay status template
2. CarPlay active call template
3. CarPlay confirmation template
4. CarPlay widget/Live Activity support
5. deeper vehicle-specific testing

## Product positioning

Me.AI is not primarily a CarPlay app. It is a personal AI call operator for iPhone that also works beautifully in the car when CarPlay is available.

## User promise

Me.AI should help users answer, screen, delegate, place, summarize, and follow up on calls from their iPhone first.

CarPlay promise:

When users are driving, Me.AI should provide safe, glanceable control only.

## Design implications

### iPhone

The iPhone app becomes the main product surface. It should feel polished, trustworthy, and useful even with zero CarPlay usage.

Primary screens:

- Today cockpit
- Activation setup
- Active call
- Incoming call decision
- Outbound request composer
- Pending confirmation
- Call summary
- Call history
- Contact rules
- Settings

### CarPlay

CarPlay should not define the product. It should mirror only the minimum safe call state and confirmation actions.

## Engineering implications

- Prioritize App Intents and Shortcuts.
- Prioritize CallKit flows.
- Prioritize phone number provisioning and routing.
- Prioritize Lock Screen/Home Screen widget architecture.
- Prioritize backend call state and summaries.
- Do not block TestFlight on CarPlay entitlement unless Apple timing aligns.
- Keep CarPlay entitlement work moving in parallel, but not on the critical MVP path.

## Submission implications

The first TestFlight build can be iPhone-first without waiting for CarPlay approval.

CarPlay can be submitted as an enhancement once entitlement approval and simulator testing are ready.
