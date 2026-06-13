# Android and Android Auto blueprint

## North star

Me.AI is a voice-first communication agent. Following the iOS release, the Android application will offer equivalent capability, integrating with Google Assistant/Gemini App Actions for hands-free activation, showing system call status through the Android Telecom framework, and rendering a driving-optimized interface on vehicles using the Android Auto App Library.

## Android Auto application setup

Android Auto apps are built using the **Android Car App Library** (`androidx.car.app`). Rather than controlling arbitrary canvas pixels, Android Auto apps construct screens using declarative templates:

- **Manifest Declaration**:
  The application must declare Android Auto support in its `AndroidManifest.xml` with the car app service role:
  ```xml
  <service
      android:name=".services.MeAICarAppService"
      android:exported="true">
      <intent-filter>
          <action android:name="androidx.car.app.CarAppService" />
      </intent-filter>
  </service>
  <meta-data
      android:name="com.google.android.gms.car.application"
      android:resource="@xml/automotive_app_desc"/>
  ```

- **Scene Lifecycle**:
  A class extending `CarAppService` instantiates a `Session` object. The `Session` manages a stack of `Screen` objects. Each screen returns a standard layout template, such as:
  - `ListTemplate`: Displays contact rules or call logs.
  - `MessageTemplate`: Displays confirmation status or warning alerts.
  - `PaneTemplate`: Displays active call details and take-over action panels.

## Capabilities and permissions

For call handling and background tool execution, the Android application requires the following:

- **Telecom Account Enrollment**:
  Requires `MANAGE_OWN_CALLS` permission. The app registers a `PhoneAccount` with the Android `TelecomManager` to route calls through the system dialer UI and Bluetooth devices.
- **Push Notification Access**:
  Requires Google Play Services Firebase Cloud Messaging (FCM). Uses high-priority data-only messages to wake up the background worker for incoming screening.
- **Sensitive Native Tools**:
  - `WRITE_CALENDAR` and `READ_CALENDAR` for event updates.
  - `WRITE_REMINDERS` or Tasks APIs.
  - Access to device locations via `ACCESS_FINE_LOCATION` when handoffs to Google Maps are triggered.
- **Keystore Protection**:
  Authentication credentials and Twilio lines are secured using the Android `KeyStore` provider via Jetpack Security (`EncryptedSharedPreferences`).

## Inbound call flow

1. **Twilio Route**: Inbound call dials a registered Twilio number.
2. **Account Match**: The backend webhook resolves the E164 number to the correct account/agent and fires an FCM high-priority data payload.
3. **Background Wakeup**: Android receives the message in `FirebaseMessagingService`.
4. **Telecom Handshake**: The app registers an incoming connection with `TelecomManager.addNewIncomingCall()`.
5. **Connection Service**: System calls the app's `ConnectionService.onCreateIncomingConnection()`.
   - The app returns a custom `Connection` subclass.
   - The system displays the standard incoming call HUD or fullscreen incoming dialer.
6. **Takeover and Control**: The user can answer (connecting to OpenAI session stream) or tap "Delegate to Me.AI" (letting the backend handle the real-time screening agent loop).

## Outbound Assistant/Gemini flow

1. **Voice Query**: User says, "Hey Google, tell Me.AI to call the clinic."
2. **App Shortcut**: The system resolves the request to an App Shortcut declared in `shortcuts.xml` using Google Assistant Built-in Intents (BII) or custom voice triggers.
3. **Background Dispatch**: The app dispatches `/api/calls/outbound` request to the backend.
4. **Dialing Handshake**: The backend queues the call, starts Twilio bridging, and registers the outbound attempt.
5. **Connection Update**: The app registers the call with `TelecomManager.addNewOutgoingCall()`, establishing the CallKit-equivalent state.

## Cross-app action model

When the OpenAI agent returns a tool call, it executes natively via the device:

- **Navigation**: Uses geo intents (`geo:0,0?q=Destination`) to open Google Maps, Waze, or other native navigation apps.
- **Calendar & Reminders**: Modifies databases via Android Content Providers or registers alarms via the `AlarmManager`.
- **Text Drafts**: Launches message intents (`Intent.ACTION_SENDTO` with `sms:` uri) to allow safe user-confirmed dispatch of texts.

## Review checklist

- Test Android Auto screens in the Desktop Head Unit (DHU) emulator.
- Verify that VoIP incoming calls handle system volume, audio focus, and Bluetooth takeover correctly.
- Ensure all background task execution uses `WorkManager` or Foreground Services (when audio streaming is active) to prevent premature OS termination.
- Confirm RLS database security policies cover Android registration requests.
