# Agent Studio

## Decision

Agent Studio should be a first-class Me.AI module. It is where a personal user or business client customizes how their Me.AI agent sounds, responds, handles calls, follows scripts, and behaves in scenarios.

## Why it matters

Me.AI is not just a phone tool. The value is a trusted personal or business operator that behaves the way the user wants.

## MVP Agent Studio fields

### Identity

- Agent name
- Owner or workspace name
- Personal or business mode
- Welcome message
- AI disclosure wording

### Voice

- Voice selection
- Voice label for user-facing setup
- Optional perceived style label such as warm, calm, professional, energetic

Do not overpromise biological sex. Use voice labels and style descriptors instead of claiming fixed male/female capability unless the provider officially exposes that metadata.

### Response style

- Concise
- Balanced
- Detailed
- Warm
- Formal
- Direct

Default: concise and calm.

### Behavior instructions

- System instructions
- Escalation rules
- Privacy rules
- Confirmation rules
- What Me.AI should never do

### Training notes

- User preferences
- Common context
- Business facts
- FAQ-style guidance
- Contact-specific notes

### Scenarios

Examples:

- Unknown caller
- Family call
- Work call
- Appointment call
- Sales/vendor call
- Emergency or urgent call
- Follow-up needed
- Voicemail summary

Each scenario should have:

- trigger
- goal
- script notes
- escalation rule
- allowed actions

### Scripts

Examples:

- inbound screening opener
- outbound lateness call
- appointment confirmation
- callback request
- voicemail follow-up
- business front-desk greeting

Each script should have:

- name
- purpose
- script body
- variables
- when to use

## MVP screens

1. Agent Studio overview
2. Identity and voice
3. Response style
4. Behavior instructions
5. Training notes
6. Scenarios
7. Scripts
8. Test agent prompt

## Personal mode

Personal users get one primary agent. The UI should feel simple and personal, not like an enterprise dashboard.

## Business mode

Business users can eventually manage multiple agents, phone lines, scripts, and scenarios. This should be feature-flagged until the personal agent flow is strong.

## Backend requirements

- Store agent profile fields.
- Update active agent.
- Store training notes.
- Store scenario definitions.
- Store scripts.
- Compile the active agent into OpenAI instructions at session creation.
- Keep personal account limited to one active agent.

## Product rule

Agent Studio should be powerful, but the default setup must remain simple. A user should be able to launch with defaults and improve the agent over time.
