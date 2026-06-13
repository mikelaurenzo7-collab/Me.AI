# Product modules roadmap

## Strategy

Me.AI should feel creative and powerful, but every module must fit Apple's safety, privacy, metadata, and review expectations.

## Module 1: Activation Center

Purpose: make Me.AI reachable from the iPhone without hunting for the app.

Surfaces:

- Siri phrase
- Action Button shortcut
- Back Tap shortcut
- Lock Screen widget
- Home Screen widget
- Live Activity
- app button
- Apple Watch later

Apple-safe rule: user-configured shortcuts and clear permission explanations only.

## Module 2: Agent Studio

Purpose: customize how the agent behaves.

Controls:

- name
- voice
- voice style
- response style
- welcome message
- disclosure wording
- behavior instructions
- training notes
- scenarios
- scripts
- test prompt

Apple-safe rule: avoid deceptive identity claims and keep AI disclosure visible.

## Module 3: Call Rules

Purpose: define who Me.AI handles and how.

Controls:

- family always rings
- favorites always ring
- unknown callers screen first
- vendors delegate
- work calls follow business script
- quiet hours
- VIP bypass
- blocked/spam handling

Apple-safe rule: do not contact people from Contacts except at the user's explicit individualized initiative.

## Module 4: Confirmations

Purpose: prevent accidental or unsafe actions.

Confirm before:

- placing calls
- sending messages
- creating reminders
- changing calendar items
- sharing private information
- escalating to business workflow

Apple-safe rule: sensitive actions always need clear user approval.

## Module 5: Call Memory

Purpose: make calls useful after they happen.

Features:

- summary
- outcome
- action items
- callback reminders
- unresolved questions
- contact insights
- user-editable notes

Apple-safe rule: transcripts/summaries should be user-visible, user-controllable, and deletable.

## Module 6: Demo Mode

Purpose: make App Review and early testing easier without relying on live calls.

Features:

- sample agent
- sample call history
- sample pending confirmations
- simulated active call
- simulated Agent Studio test prompt
- no real provider actions

Apple-safe rule: demo mode should demonstrate actual core functionality and be clearly labeled.

## Module 7: Privacy Center

Purpose: centralize data and permission control.

Features:

- permission status
- transcript retention
- summary retention
- export data
- delete call history
- delete account
- disable agent

Apple-safe rule: provide accessible privacy policy, consent withdrawal, and account deletion path.

## Module 8: Review Mode

Purpose: make the app understandable to Apple reviewers.

Features:

- reviewer checklist
- demo credentials flow
- safe simulated calls
- visible explanation of provider-limited flows
- disabled CarPlay section if entitlement not included

Apple-safe rule: no hidden or undocumented features. Review notes must match build behavior.

## Module 9: Business Upgrade

Purpose: add workspace/fleet power later.

Features:

- multiple agents
- multiple phone lines
- team routing
- scripts by department
- role permissions
- audit logs

Apple-safe rule: business features must not pollute personal mode and must remain reviewable if included.

## Recommended build order

1. Activation Center
2. Agent Studio
3. Call Rules
4. Confirmations
5. Call Memory
6. Demo Mode
7. Privacy Center
8. Review Mode
9. Business Upgrade
10. CarPlay extension
