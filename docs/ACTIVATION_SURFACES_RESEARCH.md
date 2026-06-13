# Activation surfaces research

## Product question

Can a user press one thing in the car or on the phone to send a call/request to Me.AI?

## Short answer

Yes, but not as one universal custom hardware button across all vehicles.

Me.AI should support a ladder of activation surfaces:

1. Siri phrase
2. CarPlay touchscreen item
3. CarPlay widget / Live Activity interaction where allowed
4. iPhone Action Button shortcut
5. iPhone Back Tap shortcut
6. Home Screen / Lock Screen widget
7. Apple Watch shortcut
8. In-app big action button
9. CallKit answer/delegate/take-over controls

## What is realistic

### 1. Siri phrase

Best universal hands-free route.

Examples:

- "Hey Siri, ask Me.AI to handle this."
- "Hey Siri, tell Me.AI to call the office."
- "Hey Siri, ask Me.AI to route me to my next meeting."

Implementation:

- App Intents
- App Shortcuts
- Shortcuts support
- Backend route to queue call/tool action

### 2. CarPlay touchscreen item

Best direct in-car tap route if CarPlay entitlement is approved.

Examples:

- Me.AI status tile
- Delegate current call
- Start Me.AI request
- Approve route/reminder
- Take over call

Implementation:

- CarPlay framework templates
- CPListTemplate / CPAlertTemplate / communication-safe templates
- Keep copy short and actions limited

### 3. CarPlay widget / Live Activity

Strong glanceable route for status and light interaction.

Examples:

- Ready
- Screening call
- Delegated call active
- Action needs confirmation
- Summary ready

Implementation:

- WidgetKit
- ActivityKit
- App Intent-backed widget actions where safe

### 4. iPhone Action Button

Excellent shortcut route on supported iPhones.

Examples:

- Press Action Button to open Me.AI quick menu
- Press Action Button to start "Delegate next call"
- Press Action Button to create a Me.AI request

Implementation:

- User maps iPhone Action Button to a Me.AI Shortcut
- Shortcut invokes Me.AI App Intent

### 5. iPhone Back Tap

Useful accessibility fallback.

Examples:

- Double tap back of iPhone to run "Ask Me.AI"
- Triple tap back of iPhone to open Me.AI cockpit

Implementation:

- User maps Back Tap to a Me.AI Shortcut

### 6. Home Screen / Lock Screen widget

Useful outside CarPlay.

Examples:

- Delegate next call
- Start outbound request
- Review summary
- Approve pending action

Implementation:

- WidgetKit
- App Intents

### 7. Apple Watch shortcut

Useful when driving, walking, or working.

Examples:

- Tap complication/shortcut
- Ask Siri on Watch
- Approve/decline action

Implementation:

- Shortcuts/App Intents first
- Native Watch app later if demand is high

## What is not realistic for MVP

### Universal steering wheel button hijack

Me.AI should not depend on intercepting arbitrary vehicle steering wheel buttons. In most CarPlay contexts, the vehicle voice button is expected to activate Siri or the vehicle's native assistant. Me.AI can be reached through Siri/App Intents, but should not claim it can globally capture all vehicle hardware buttons.

### Arbitrary third-party app control

Me.AI cannot safely promise universal control of every app on the phone or CarPlay. It should use App Intents, Shortcuts, universal links, and supported native frameworks.

## Product decision

Me.AI should ship a feature called Activation Shortcuts.

Activation Shortcuts should include:

- Set up Siri phrase
- Add Action Button shortcut
- Add Back Tap shortcut
- Add Home Screen widget
- Add Lock Screen widget
- Add CarPlay widget if available
- Add Apple Watch shortcut later

## First build requirements

- Add App Intents for "Start Me.AI call", "Delegate to Me.AI", "Open Me.AI cockpit", and "Approve pending action".
- Add setup screen explaining each activation method.
- Add a one-tap "Create Shortcut" or instruction flow where Apple requires user configuration.
- Add CarPlay-safe action tiles after entitlement approval.
- Add fallback path when CarPlay entitlement is not approved yet.
