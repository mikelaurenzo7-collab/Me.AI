# Michael owner action checklist

This file tracks what Michael needs to do personally so the iOS/App Store process does not get lost.

## Immediate actions

### 1. Confirm access to a Mac

You need a Mac with Xcode to visually run the iOS app in the iPhone Simulator and eventually archive the app for TestFlight/App Store.

Status: not confirmed

### 2. Install Xcode

Install Xcode from the Mac App Store. Xcode is Apple's IDE for building, testing, archiving, and submitting iOS apps.

Status: not done

### 3. Enroll in the Apple Developer Program

Apple Developer Program membership is required for TestFlight, App Store distribution, production capabilities, provisioning profiles, and managed entitlement requests.

Status: not done

### 4. Decide Apple developer account type

Choose whether to enroll as:

- Individual: fastest path, tied to Michael personally.
- Organization: better for a company/app business, requires business verification details.

Recommended for Me.AI: Organization if the company/legal entity is ready; Individual if speed matters more right now.

Status: not decided

### 5. Decide final bundle ID

Current planned bundle ID: `com.meai.app`

This needs to be created in Apple Developer once the account is ready.

Status: planned, not created

### 6. Confirm final app name

Current app name: Me.AI

Status: confirmed in repo, should be rechecked before App Store Connect submission

## Before visual iPhone Simulator preview

Michael needs:

- Mac
- Xcode
- local clone of `mikelaurenzo7-collab/Me.AI`
- XcodeGen installed, or the Xcode project generated another way

Then run:

```bash
cd ios
xcodegen generate
open MeAI.xcodeproj
```

Then press Run in Xcode with an iPhone Simulator selected.

## Before visual real-iPhone preview

Michael needs:

- Apple Developer account or free Apple developer signing
- iPhone connected to Mac
- signing team selected in Xcode
- app builds locally

A real device is needed for PushKit/CallKit behavior beyond simple simulator UI.

## Before TestFlight

Michael needs:

- paid Apple Developer Program membership
- App Store Connect access
- Bundle ID created
- signing/provisioning configured
- app archive uploaded from Xcode
- demo account/review notes prepared

## Before CarPlay preview

Michael needs:

- Xcode CarPlay Simulator for basic template testing
- CarPlay entitlement approval for real CarPlay distribution behavior
- correctly signed provisioning profile including the entitlement

CarPlay may not appear like a normal app until Apple approves the entitlement.

## Before App Store submission

Michael needs:

- support URL live
- privacy policy URL live
- App Store screenshots
- final app description/subtitle/keywords
- privacy nutrition labels completed in App Store Connect
- review notes completed
- TestFlight smoke testing completed

## Credentials and services Michael will eventually need

- Apple Developer account
- App Store Connect access
- OpenAI API key stored only in backend secrets
- Twilio account and phone number credentials stored only in backend secrets
- Supabase project credentials stored only in backend secrets
- domain/support/privacy URLs for App Store listing

## When Michael can visually see the product

1. Now: Figma blueprint.
2. Next local build: iPhone Simulator from Xcode.
3. After signing: real iPhone install from Xcode.
4. After upload: TestFlight install.
5. After entitlement: CarPlay Simulator and CarPlay review build.
6. After Apple approval: App Store listing.
