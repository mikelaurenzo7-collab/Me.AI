import { z } from "zod";

const schema = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  PORT: z.coerce.number().default(3000),
  PUBLIC_BASE_URL: z.string().url().default("http://localhost:3000"),
  SESSION_SECRET: z.string().min(12).default("local-meai-secret"),
  DB_FILE: z.string().default(".data/meai.json"),
  OPENAI_API_KEY: z.string().optional(),
  OPENAI_REALTIME_MODEL: z.string().default("gpt-realtime-2"),
  OPENAI_PLANNING_MODEL: z.string().default("gpt-5.5"),
  TWILIO_ACCOUNT_SID: z.string().optional(),
  TWILIO_AUTH_TOKEN: z.string().optional(),
  TWILIO_DEFAULT_AREA_CODE: z.string().default("630"),
  TWILIO_VOICE_WEBHOOK_PATH: z.string().default("/api/webhooks/twilio/voice"),
  TWILIO_STATUS_WEBHOOK_PATH: z.string().default("/api/webhooks/twilio/status"),
  SUPABASE_URL: z.string().url().optional(),
  SUPABASE_ANON_KEY: z.string().optional(),
  SUPABASE_SERVICE_ROLE_KEY: z.string().optional(),
  VAPI_API_KEY: z.string().optional(),
  VAPI_ASSISTANT_ID: z.string().optional(),
  ELEVEN_LABS_API_KEY: z.string().optional()
});

export const env = schema.parse(process.env);
export const isProviderConfigured = {
  openai: Boolean(env.OPENAI_API_KEY),
  twilio: Boolean(env.TWILIO_ACCOUNT_SID && env.TWILIO_AUTH_TOKEN),
  supabase: Boolean(env.SUPABASE_URL && env.SUPABASE_SERVICE_ROLE_KEY),
  vapi: Boolean(env.VAPI_API_KEY),
  elevenlabs: Boolean(env.ELEVEN_LABS_API_KEY)
};
