# Production wiring

## Backend hosting

Recommended path:

1. Deploy backend API to Vercel or another Node-compatible host.
2. Store all provider credentials as encrypted environment variables.
3. Require HTTPS for all iOS API calls.
4. Add rate limiting and webhook signature validation before public launch.
5. Move local JSON persistence to Supabase before TestFlight with real users.

## OpenAI

- Keep `OPENAI_API_KEY` server-side only.
- Use realtime sessions for live voice interaction.
- Use structured tool calls for native iOS actions.
- Use a separate model setting for summaries and post-call analysis.
- Add safety identifiers for account/user traceability.

## Twilio

- Use Twilio only from backend routes.
- Provision phone lines per account.
- Map inbound numbers to account, phone line, and active agent.
- Validate webhook signatures.
- Store provider call IDs in `call_logs`.
- Bridge audio to the realtime voice layer after MVP routing is stable.

## Supabase

- Apply `docs/SUPABASE_SCHEMA.sql`.
- Add RLS policies before production.
- Use service role only on backend.
- Use anon key only when safe for client-side reads.
- Add audit records for tool calls and call state changes.

## Apple

- Create bundle ID.
- Configure Siri, Push Notifications, Background Modes, and CarPlay entitlement after approval.
- Add APNs key and push provider.
- Build through Xcode or Xcode Cloud.
- Submit to TestFlight before App Store review.
