export type SubmissionGate = {
  id: string;
  title: string;
  required: string[];
};

export const submissionGates: SubmissionGate[] = [
  {
    id: "architecture",
    title: "Architecture locked",
    required: ["Me.AI naming", "personal/business separation", "CarPlay-safe scope", "provider roles documented"]
  },
  {
    id: "local-build",
    title: "Local build",
    required: ["Xcode project builds", "backend typecheck passes", "App Intents compile", "privacy manifest included"]
  },
  {
    id: "provider-integration",
    title: "Provider integration",
    required: ["OpenAI realtime", "phone provider provisioning", "incoming call routing", "native tool round trip"]
  },
  {
    id: "apple-entitlement",
    title: "Apple entitlement path",
    required: ["bundle ID", "capabilities", "CarPlay communication request", "provisioning profile"]
  },
  {
    id: "testflight",
    title: "TestFlight",
    required: ["signed archive", "demo account", "smoke test", "review notes"]
  },
  {
    id: "app-store",
    title: "App Store submission",
    required: ["metadata", "screenshots", "privacy labels", "support URLs", "production monitoring"]
  }
];
