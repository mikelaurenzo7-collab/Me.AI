# Me.AI iOS

Native iOS and CarPlay skeleton for Me.AI.

This folder now includes source-level scaffolding plus an XcodeGen project spec. Generate the Xcode project locally with `xcodegen generate` from the `ios/` directory.

## Targets planned

- `MeAI`: SwiftUI app target.
- `MeAIIntents`: App Intents and Siri shortcuts, currently in source scaffold.
- `MeAIWidget`: WidgetKit and Live Activity target, planned next.

## Required capabilities

- Siri
- Push Notifications
- Background Modes: Voice over IP, remote notifications, audio as needed
- CarPlay communication entitlement after Apple approval
- App Groups if widget and app share state

## Core files

- `Sources/MeAIEntry.swift`
- `Sources/AppShell.swift`
- `Sources/DashboardView.swift`
- `Sources/SetupFlowView.swift`
- `Sources/ActiveCallView.swift`
- `Sources/APIClient.swift`
- `Sources/CallKitManager.swift`
- `Sources/CarScene.swift`
- `Sources/CarPlaySceneAlias.swift`
- `Sources/MeAIAppIntents.swift`
- `Sources/NativeToolExecutor.swift`
- `Sources/DesignTokens.swift`
- `Config/Info.plist`
- `Config/MeAI.entitlements`
- `Config/PrivacyInfo.xcprivacy`
- `project.yml`

## Build notes

See `BUILDING.md`.
