# docdoc

Brief Flutter dental app — platform-ready helper notes.

Project overview
----------------
- Minimal Flutter app organized by `core/` and `features/`.
- Uses `get_it` for DI, `dio` + `retrofit` for networking, `freezed` for models, and `flutter_bloc`/`cubit` for state.

Architecture
------------
- `lib/core/` — dependency injection, networking helpers, theming, routing, widgets.
- `lib/features/` — feature modules (e.g., `login`, `onboarding`) with `data/`, `logic/`, `ui/` subfolders.

Mac (iOS) setup
---------------
1. Install Xcode from the App Store and open it once.
	```bash
	sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
	sudo xcodebuild -runFirstLaunch
	sudo xcodebuild -license accept
	```
2. Install Homebrew if missing: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Install CocoaPods via Homebrew (recommended):
	```bash
	brew install cocoapods
	pod --version
	```
4. Ensure Flutter iOS artifacts are cached and CocoaPods can access engine bits:
	```bash
	flutter precache --ios
	flutter pub get
	cd ios
	pod install
	```
5. If `pod install` fails with a missing Flutter.xcframework, run from project root:
	```bash
	flutter clean
	flutter pub get
	flutter build ios --no-codesign
	cd ios && pod install
	```

Run on iOS simulator
-------------------
1. Start the simulator:
	```bash
	open -a Simulator
	flutter devices
	flutter run -d <device-id>
	```

Android setup (quick)
---------------------
1. Install Android Studio and SDK command-line tools.
2. Accept licenses:
	```bash
	flutter doctor --android-licenses
	```
3. Build APK:
	```bash
	flutter build apk --release
	```

Build for TestFlight (iOS)
-------------------------
1. Open `ios/Runner.xcworkspace` in Xcode.
2. Set a signing team and increment build/version.
3. Product → Archive → Upload to App Store Connect.

Troubleshooting notes
---------------------
- If `pod install` errors referencing `/flutter/bin/cache/.../Flutter.xcframework`, ensure `flutter precache --ios` completes and run `flutter build ios --no-codesign` to populate engine artifacts.
- If Xcode tools are missing errors appear, run the `xcode-select` commands above and open Xcode once.
- Keep `cocoapods` up to date via Homebrew if plugin-related podspecs fail.

Contacts & references
---------------------
- Flutter docs: https://flutter.dev
- CocoaPods: https://cocoapods.org

--
Updated for macOS/iOS development (April 2026)


