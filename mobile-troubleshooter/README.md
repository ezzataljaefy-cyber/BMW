# Mobile Troubleshooter

A Flutter application designed to help users troubleshoot issues with their mobile devices through articles and an AI-powered chat assistant.

## Features

- **Clean Architecture:** Modularized into `core`, `data`, `domain`, and `presentation` layers.
- **Riverpod State Management:** For a robust and scalable state management solution.
- **Full-Text Search:** Instant offline search for articles using SQLite FTS5.
- **Rich Content:** Articles with HTML/Markdown, images, videos, and attachments.
- **Offline Access:** Save articles for offline reading.
- **AI Chat Assistant:** Get help from an AI assistant, with support for screenshot uploads.
- **Firebase Integration:** Google Sign-In, Analytics, Crashlytics, and Remote Config.
- **IAP & Ads:** Scaffolding for monthly subscriptions and ads (AdMob/Facebook).
- **Internationalization:** Full support for English and Arabic (RTL).

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) for emulators/simulators.
- An editor like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).

### Setup

1.  **Clone the repository:**
    ```bash
    git clone <your-repo-url>
    cd mobile-troubleshooter
    ```

2.  **Get Flutter packages:**
    ```bash
    flutter pub get
    ```

3.  **Set up Firebase:**
    - Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    - Add an Android app and an iOS app to your Firebase project.
    - **Android:** Download the `google-services.json` file and place it in the `android/app/` directory.
    - **iOS:** Download the `GoogleService-Info.plist` file and open `ios/Runner.xcworkspace` in Xcode. Drag the downloaded file into the `Runner` subfolder.

4.  **Set up environment variables:**
    - Create a file `lib/.env` by copying the example:
      ```bash
      cp .env.example .env
      ```
      *Note: In a real project, this file should be located in the root and loaded at runtime, but for simplicity in this structure, we place it in `lib` and gitignore it.*
    - Open `.env` and fill in the placeholder values.

### Required Placeholders & Environment Variables (`.env.example`)

- `<<PACKAGE_NAME>>`: Your Android package name (e.g., `com.company.appname`).
- `<<IOS_BUNDLE_ID>>`: Your iOS bundle ID (e.g., `com.company.appname`).
- `<<ADMOB_ANDROID_APP_ID>>`: Your AdMob App ID for Android.
- `<<ADMOB_IOS_APP_ID>>`: Your AdMob App ID for iOS.
- `<<ADMOB_ANDROID_BANNER_AD_UNIT_ID>>`: Test banner ad unit ID for Android.
- `<<ADMOB_IOS_BANNER_AD_UNIT_ID>>`: Test banner ad unit ID for iOS.
- `<<FACEBOOK_APP_ID>>`: Your Facebook App ID for ads.
- `<<FACEBOOK_CLIENT_TOKEN>>`: Your Facebook client token.
- `<<IAP_MONTHLY_PRODUCT_ID_ANDROID>>`: The product ID for your monthly subscription on Google Play.
- `<<IAP_MONTHLY_PRODUCT_ID_IOS>>`: The product ID for your monthly subscription on the App Store.

### Running the App

Make sure you have an emulator running or a device connected, then run:
```bash
flutter run
```

To run a specific flavor (if configured):
```bash
flutter run --flavor development
```

## Build & Release (Fastlane)

Fastlane is configured to help automate builds and releases.

### Setup Fastlane

1.  Install Fastlane: `sudo gem install fastlane -NV`
2.  Navigate to the `android` or `ios` directory.
3.  Run `fastlane <lane_name>`

### Available Lanes

- **Android:**
  - `fastlane android beta`: Builds a debug APK and a release AAB.
  - `fastlane android deploy`: (Commented out) Deploys the AAB to the Google Play Store.

- **iOS:**
  - `fastlane ios beta`: Builds a debug version for simulators and an IPA for testing.
  - `fastlane ios deploy`: (Commented out) Deploys the IPA to TestFlight.

## CI/CD (GitHub Actions)

The `.github/workflows/` directory contains CI templates for:
- **`main.yml`:** Runs checks (analyze, test) on every push to `main`.
- **`release.yml`:** (Manual trigger) A template for building and publishing the app. You will need to configure GitHub Secrets for this to work.

### Required GitHub Secrets

- `FIREBASE_API_TOKEN`
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
- `APP_STORE_CONNECT_API_KEY_ID`
- `APP_STORE_CONNECT_ISSUER_ID`
- `APP_STORE_CONNECT_PRIVATE_KEY`
- `MATCH_PASSWORD`

## Security & Privacy

- **Secrets:** All sensitive keys are managed via environment variables (`.env`) and GitHub Secrets. No keys are ever hard-coded.
- **Data Handling:** The `PRIVACY_POLICY.md` file details how user data, especially screenshots uploaded to the AI chat, is handled. Explicit user consent is required before any data is sent to third-party services.
