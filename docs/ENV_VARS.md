# Environment variables

Do not commit real secrets. Use local `.env` files and Vercel/Supabase secret stores.

## Backend

```bash
NODE_ENV=development
PORT=8787
PUBLIC_BASE_URL=http://localhost:8787
SESSION_SECRET=replace-with-local-secret
DB_FILE=.data/meai.json
```

## OpenAI

```bash
OPENAI_API_KEY=
OPENAI_REALTIME_MODEL=gpt-realtime
OPENAI_PLANNING_MODEL=gpt-5.5-thinking
```

## Twilio

```bash
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_DEFAULT_AREA_CODE=630
TWILIO_VOICE_WEBHOOK_PATH=/api/webhooks/twilio/voice
TWILIO_STATUS_WEBHOOK_PATH=/api/webhooks/twilio/status
```

## Supabase

```bash
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
```

## iOS

```bash
MEAI_API_BASE_URL=http://localhost:8787
MEAI_WS_BASE_URL=ws://localhost:8787
IOS_BUNDLE_ID=com.meai.app
```
