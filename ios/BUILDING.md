# Building the iOS app

## Requirement

Install Xcode and XcodeGen locally.

```bash
brew install xcodegen
cd ios
xcodegen generate
open MeAI.xcodeproj
```

## Signing

Before a real device or TestFlight build:

1. Create the final Bundle ID in Apple Developer.
2. Enable Siri and Push Notifications.
3. Add Background Modes in Xcode.
4. Request and configure CarPlay communication entitlement after approval.
5. Use automatic signing with the correct Apple team.

## Current target

- Product: MeAI
- Bundle ID: `com.meai.app`
- Minimum iOS: 18.0

## Important

The CarPlay entitlement template exists in `Config/MeAI.entitlements`, but the entitlement must be approved by Apple and included in the signed provisioning profile before the app can appear in CarPlay.
