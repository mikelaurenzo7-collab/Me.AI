# Wireline reference imports

## Decision

Use Wireline as an architecture reference only. Do not import Wireline UI, branding, Supabase data, production database, or product shell into Me.AI.

## Patterns worth reusing

### Agent runtime purity

Wireline's agent runtime takes stored profile fields and produces runtime instructions without database or network side effects.

Me.AI should use the same pattern in Swift and backend code:

- profile in
- policy output out
- no hidden I/O
- testable functions

### Runtime policy inputs

Useful fields from Wireline's runtime model:

- timezone
- availability hours
- compliance mode
- disallowed topics
- escalation keywords
- runtime variables
- outcome focus
- response style

Me.AI adaptation:

- personal availability instead of business hours by default
- urgent escalation language
- Apple-safe confirmation language
- Agent Studio-driven training, scenarios, and scripts

### Tool dispatch discipline

Wireline routes tool calls through a shared dispatcher and returns a safe fallback when an action is unavailable.

Me.AI adaptation:

- native tool allowlist
- confirmation-first sensitive actions
- unavailable action fallback
- no arbitrary app control claims

### Voice profile discipline

Wireline treats fast turn-taking as a product fundamental rather than a paywalled feature.

Me.AI adaptation:

- concise default response style
- low-latency voice feel for all users
- separate voice style from billing tier
- no unsupported voice identity claims

### Per-agent phone-line discipline

Wireline distinguishes provider IDs from phone-number identifiers and prefers agent-specific phone lines.

Me.AI adaptation:

- validate provider number identifiers
- prefer active agent phone line
- keep personal mode simple with one primary line
- business mode can add multiple lines later

## Swift files created from these patterns

- `ios/Sources/AgentRuntimePolicy.swift`
- `ios/Sources/VoiceExperienceProfile.swift`
- `ios/Sources/PhoneLineRoutingPolicy.swift`
- `ios/Sources/ReadinessEngine.swift`

## Guardrails

- Do not copy Wireline product shell.
- Do not use Wireline Supabase project.
- Do not use Wireline credentials.
- Do not make CarPlay a required MVP dependency.
- Keep Me.AI iPhone-first.
