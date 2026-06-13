# Xcode static compile audit

## Scope

This is a static Xcode-readiness pass. It does not replace a real Xcode build, simulator run, device run, signing test, or TestFlight archive.

## Pass result

The iOS source is now more compile-safe than before this pass. Several likely blockers and risk points were corrected.

## Fixes applied

### Removed stale phone scene delegate reference

`Info.plist` referenced `PhoneSceneDelegate`, but the app uses the SwiftUI `@main` lifecycle and no `PhoneSceneDelegate` class existed.

Fix:

- removed the `UIWindowSceneSessionRoleApplication` delegate reference
- kept the SwiftUI `WindowGroup` as the phone app entry point
- left CarPlay isolated as its own scene configuration

### Made default entitlements compile-safe

The default entitlement file included gated APNs and CarPlay capabilities. Those can block signing before Apple capability approval.

Fix:

- made `Config/MeAI.entitlements` minimal for local simulator/Xcode compile
- added `Config/MeAI.Submission.entitlements.template` for later APNs/CarPlay work
- updated `ios/BUILDING.md` with the entitlement strategy

### Fixed CarPlay inheritance blocker

`CarPlaySceneDelegate` subclasses `MeAICarScene`, but `MeAICarScene` was marked `final`.

Fix:

- removed `final` from `MeAICarScene`

### Made Swift model labels conservative

Some model labels used newer switch-expression style.

Fix:

- converted those to explicit `return` statements inside `switch` blocks

### Made Agent Studio ViewBuilder safer

`AgentIdentityView` had a local `let` declaration inside a SwiftUI `Section`.

Fix:

- moved voice profile resolution into a computed property
- replaced specifier interpolation with `String(format:)`

### Made API endpoint building conservative

The API client used `URL.appending(path:)` with slash-prefixed route strings.

Fix:

- replaced with a conservative `URLComponents` endpoint builder

## Files touched

- `ios/Config/Info.plist`
- `ios/Config/MeAI.entitlements`
- `ios/Config/MeAI.Submission.entitlements.template`
- `ios/BUILDING.md`
- `ios/Sources/APIClient.swift`
- `ios/Sources/AgentStudioView.swift`
- `ios/Sources/CarScene.swift`
- `ios/Sources/Models.swift`

## Remaining real Xcode gates

These cannot be proven here:

1. `xcodegen generate`
2. Swift compiler validation in Xcode
3. iPhone Simulator build
4. iPhone Simulator launch
5. signing with Apple Developer team
6. real device build
7. PushKit/APNs capability validation
8. CarPlay entitlement validation
9. TestFlight archive

## Recommended first local command sequence

```bash
cd ios
xcodegen generate
open MeAI.xcodeproj
```

Then select an iPhone simulator and build the `MeAI` target.

## Current compile posture

Best honest label:

Static Xcode-readiness improved. No known obvious Swift source blockers remain from this pass, but a real Xcode build is still required before calling the app compile-clean.
