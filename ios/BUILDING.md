# Building the iOS app

## Requirement

Install Xcode and XcodeGen locally.

```bash
brew install xcodegen
cd ios
xcodegen generate
open MeAI.xcodeproj
```

## Default compile target

The default project is iPhone-first and compile-safe. `Config/MeAI.entitlements` is intentionally minimal so local simulator builds are not blocked by gated Apple capabilities before approval.

## Signing before device/TestFlight

Before a real device or TestFlight build:

1. Create the final Bundle ID in Apple Developer.
2. Use automatic signing with the correct Apple team.
3. Enable any required capabilities in the Apple Developer portal.
4. Add Push Notifications only when APNs/PushKit is being tested.
5. Request and configure CarPlay communication entitlement only after Apple approval.

## Gated entitlement template

`Config/MeAI.Submission.entitlements.template` contains the later APNs/CarPlay entitlement template. Do not switch the Xcode target to that file until the Apple account and provisioning profile include those capabilities.

## Current target

- Product: MeAI
- Bundle ID: `com.meai.app`
- Minimum iOS: 18.0

## First Xcode pass

1. Generate the Xcode project.
2. Select an iPhone simulator.
3. Build the `MeAI` target.
4. Fix Swift compile issues before enabling PushKit, APNs, or CarPlay entitlements.
5. Only after simulator build succeeds, move to signing and device testing.
