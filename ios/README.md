# Me.AI iOS

Native iOS and CarPlay skeleton for Me.AI.

This folder intentionally starts as source-level scaffolding rather than a generated Xcode project. Create the Xcode target around these files, then wire capabilities and signing after Apple entitlement approval.

## Targets to create

- `MeAIApp`: SwiftUI app target.
- `MeAIIntents`: App Intents and Siri shortcuts.
- `MeAIWidget`: WidgetKit and Live Activity target.

## Required capabilities

- Siri
- Push Notifications
- Background Modes: Voice over IP, remote notifications, audio as needed
- CarPlay communication entitlement after Apple approval
- App Groups if widget and app share state

## Core files

- `App/MeAIApp.swift`
- `App/Views/DashboardView.swift`
- `App/Services/APIClient.swift`
- `App/Services/CallKitManager.swift`
- `App/Services/DeviceToolClient.swift`
- `CarPlay/CarPlaySceneDelegate.swift`
- `Intents/MeAIAppIntents.swift`
- `Config/Info.plist`
- `Config/MeAI.entitlements`
