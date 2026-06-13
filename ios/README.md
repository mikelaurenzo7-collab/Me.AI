# Me.AI iOS

Native iOS and CarPlay skeleton for Me.AI.

This folder now includes source-level scaffolding plus an XcodeGen project spec. Generate the Xcode project locally with `xcodegen generate` from the `ios/` directory.

## Targets planned

- `MeAI`: SwiftUI app target.
- `MeAIIntents`: App Intents and Siri shortcuts, currently in source scaffold.
- `MeAIWidget`: WidgetKit operator status widget target for Home Screen, Lock Screen, and StandBy glanceability.

## Required capabilities

- Siri
- Push Notifications
- Background Modes: Voice over IP, remote notifications, audio as needed
- CarPlay communication entitlement after Apple approval
- App Groups (`group.com.meai.shared`) so the widget and app can share operator readiness state

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
- `Widget/MeAIWidgetBundle.swift`
- `Config/MeAIWidget.Info.plist`
- `Config/MeAIWidget.entitlements`

## Build notes

See `BUILDING.md`.
