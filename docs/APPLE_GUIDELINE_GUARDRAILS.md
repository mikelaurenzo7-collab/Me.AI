# Apple guideline guardrails

## Purpose

This file translates Apple review expectations into Me.AI product rules. It is not legal advice, but it should guide product, design, engineering, and review notes.

## Core review posture

Me.AI should be presented as an iPhone-first AI call operator that helps users manage their own calls, summaries, and follow-up actions. It should not be presented as a hidden automation system, prank caller, emergency service, universal phone-call interceptor, or unrestricted third-party app controller.

## Product rules

### 1. Be honest about what Me.AI can do

- Do not claim Me.AI can control arbitrary iOS apps.
- Do not claim Me.AI can take over all phone calls.
- Do not claim Me.AI can capture steering-wheel buttons.
- Do not claim CarPlay support is available before entitlement approval.
- Do not hide unfinished or entitlement-dependent features from reviewers.

### 2. Keep user consent central

- Require user confirmation before placing calls.
- Require user confirmation before sending messages.
- Require user confirmation before creating reminders or calendar items.
- Require user confirmation before sharing private information.
- Give users clear ways to pause, disable, or delete agent behavior.

### 3. Protect privacy

- Request only permissions tied to core functionality.
- Explain why each permission is needed.
- Allow useful behavior when optional permissions are denied.
- Store provider credentials only on the backend.
- Do not include provider service keys in the iOS app.
- Keep transcripts and summaries user-visible and deletable.

### 4. Use accurate metadata

- Screenshots must match the submitted build.
- App description must describe actual features, not future roadmap.
- Review notes must explain AI calling, call summaries, activation shortcuts, and any non-obvious flows.
- CarPlay should not be promoted in metadata until entitlement path is real.

### 5. Avoid unsafe use cases

- Do not position Me.AI as an emergency service.
- Do not provide medical, legal, financial, or safety-critical decisions as autonomous agent actions.
- Add escalation copy for emergencies or urgent human situations.
- Avoid anything that looks like spoofing, prank calling, or impersonation.

### 6. Keep AI disclosure clear

- Me.AI should not pretend to be human.
- Agent Studio should include AI disclosure wording.
- Business scripts should avoid deceptive identity claims.
- Users should know when an AI assistant is acting or speaking.

### 7. Review-ready demo mode

- Provide an active demo account or built-in demo mode.
- Backend services must be live during review.
- Review notes should explain how to test activation, Agent Studio, call history, pending confirmations, and any provider-limited flows.

## Engineering rules

- Add tests for permission-denied states.
- Add audit logs for sensitive tool events.
- Add rate limits before public release.
- Validate provider webhooks before production.
- Add account deletion flow before App Store submission.
- Add privacy policy and support URL before App Store submission.

## Design rules

- Every sensitive action gets an explicit approval state.
- No feature should require CarPlay to understand the core product.
- Settings should clearly show what the agent is allowed to do.
- Agent Studio should be powerful but safe by default.
- Default response style should be concise and calm.

## App Review notes checklist

Before submission, explain:

- what Me.AI does
- what AI does and does not do
- how to test demo mode
- how to test Agent Studio
- how to test activation shortcuts
- how to test call summaries
- how to test confirmations
- which features are disabled or not included in the submitted build
- whether CarPlay is included in that build
