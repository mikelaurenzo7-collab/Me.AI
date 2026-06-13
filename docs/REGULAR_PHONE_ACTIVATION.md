# Regular phone activation

## Product question

How do users ask Me.AI when they are not in the car?

## Answer

Regular iPhone use should be easier than CarPlay because the user has more input options. Me.AI should support voice, touch, physical shortcuts, widgets, and watch-based activation.

## Primary activation paths

### 1. Siri voice commands

Best default path.

Examples:

- "Siri, ask Me.AI to call Mom and say I am running late."
- "Siri, tell Me.AI to screen my next call."
- "Siri, ask Me.AI to summarize my last call."
- "Siri, tell Me.AI to remind me to call the doctor tomorrow."
- "Siri, ask Me.AI what needs my attention."

Implementation:

- App Intents
- App Shortcuts
- Shortcuts support
- Backend request queue
- Confirmation rules for sensitive actions

### 2. Action Button shortcut

Best physical-button path on supported iPhones.

Examples:

- Long-press Action Button to open Me.AI quick command.
- Long-press Action Button to delegate the next call.
- Long-press Action Button to start a voice note/request.

Implementation:

- User maps Action Button to a Me.AI shortcut.
- Shortcut calls a Me.AI App Intent.
- App shows quick confirmation or sends safe request to backend.

### 3. Back Tap shortcut

Best universal accessibility-style shortcut.

Examples:

- Double Tap back of iPhone: open Me.AI.
- Triple Tap back of iPhone: create a Me.AI request.

Implementation:

- User maps Back Tap to a Me.AI Shortcut in Accessibility settings.

### 4. Lock Screen and Home Screen widgets

Best touch path.

Widget actions:

- Ask Me.AI
- Delegate next call
- Review pending confirmation
- Last call summary
- Call someone with Me.AI

Implementation:

- WidgetKit
- AppIntent-backed widget buttons
- Deep link to focused app screen when needed

### 5. Control Center shortcut

Useful quick-access route.

Examples:

- Control Center button opens Me.AI quick action.
- Control Center button starts a Me.AI request.

Implementation:

- Shortcut exposed to Control Center where supported.

### 6. Apple Watch

Useful later-phase companion.

Examples:

- Tap Watch complication to ask Me.AI.
- Ask Siri on Apple Watch to run Me.AI shortcut.
- Approve or decline pending action.

Implementation:

- Start with Shortcuts/App Intents.
- Native Watch app later only after iPhone MVP is stable.

## Core App Intents to add

- StartMeAICallIntent
- DelegateToMeAIIntent
- OpenMeAICockpitIntent
- ApprovePendingMeAIActionIntent
- SummarizeLastCallIntent
- CreateMeAIRequestIntent

## Safety and lock-state rules

- If an action could place a call, send a message, modify calendar/reminder data, or share sensitive information, require confirmation.
- If the phone is locked and Apple requires unlock, explain that unlock is needed.
- Do not promise fully background execution for every task.
- Safe status queries and non-sensitive request creation can be lightweight.

## Setup screen copy

Title: Activate Me.AI anywhere

Body: Use Siri, widgets, the Action Button, Back Tap, or Apple Watch to reach Me.AI without hunting for the app.

Rows:

- Siri phrase: "Ask Me.AI"
- Action Button: Long-press to open Me.AI
- Back Tap: Double tap your iPhone to ask Me.AI
- Lock Screen widget: Review pending actions
- Home Screen widget: Start a request
- Apple Watch: Ask or approve from your wrist

## Product decision

Add a dedicated Activation screen during onboarding and settings. This screen should explain every available activation path and whether it is automatic, user-configured, or coming later.
