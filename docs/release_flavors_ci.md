# Flavors, CI, Fastlane

State of the DocDoc build pipeline as of this branch. Cross-references the
launch plan at `~/.claude/plans/i-will-give-you-greedy-rossum.md`.

## Flavors

| Flavor | Android applicationId | iOS bundle ID | Display name |
| --- | --- | --- | --- |
| dev | `com.docdoc.app.dev` | `com.docdoc.app.dev` | DocDoc Dev |
| staging | `com.docdoc.app.staging` | `com.docdoc.app.staging` | DocDoc Staging |
| production | `com.docdoc.app` | `com.docdoc.app` | DocDoc |

All three install side-by-side. `--flavor` is required at every command.

## Environment

`Env` in `lib/core/config/env.dart` is the single Dart entry point. All
keys come from `--dart-define-from-file=env/<flavor>.json`.

`env/dev.json`, `env/staging.json`, `env/production.json` are **committed**.
They hold only client-facing identifiers that compile into the binary and
ship to every device — Supabase URL + publishable anon key, Firebase
project ID, Agora app ID, Maps keys (when issued), Paymob public key
(when issued). None of that is a secret; treating it as one would just
break `flutter run` on a fresh checkout.

Today every flavor points at the same Supabase + Firebase + Agora project
because we only have one of each provisioned:

- Supabase: `xtlynstfzipnfbczsohz.supabase.co` + publishable anon key
- Firebase: `docdoc-59d1a`
- Agora App ID: `60000a4b6c3e47c59d1e55ca2e7fd079` (token mint runs on Firebase Functions)

Empty strings (`""`) are honest "not provisioned yet" markers:

- `GOOGLE_MAPS_API_KEY_*` — empty until Phase 4 swaps `flutter_map` (OSM) for `google_maps_flutter` / `apple_maps_flutter`
- `PAYMOB_PUBLIC_KEY` — empty until Phase 5
- `PROD_API_BASE_URL` — empty; VCare is being retired, no separate prod URL needed

Real secrets — Supabase service role, Paymob HMAC/secret, Agora app
certificate, Firebase admin JSON, Play/Apple service credentials — live
on Firebase Functions and never touch the Flutter app. The Flutter side
is incapable of holding a secret because anything compiled into the APK
can be extracted by any user.

## Entrypoints

Each flavor has its own `main_*.dart` so the IDE Run button and Fastlane
both land on the right code path. All three delegate to `bootstrap()` in
`lib/core/app/bootstrap.dart` — Firebase + Crashlytics + App Check +
Supabase init lives in one place. There is no `lib/main.dart`.

| Flavor | Entrypoint |
| --- | --- |
| dev | `lib/main_dev.dart` |
| staging | `lib/main_staging.dart` |
| production | `lib/main_production.dart` |

On iOS the entrypoint is picked automatically via `FLUTTER_TARGET` set in
each per-flavor `Flutter/<Flavor>.xcconfig`. On Android there is no
equivalent build-system hook, so every `flutter` command needs an explicit
`-t lib/main_<flavor>.dart`.

IDE run configurations are committed:

- VS Code: `.vscode/launch.json` — 9 configs (3 flavors × debug/profile/release).
- JetBrains/Android Studio: `.idea/runConfigurations/{dev,staging,production}.xml`.

## Local commands

```bash
flutter run   --flavor dev        -t lib/main_dev.dart        --dart-define-from-file=env/dev.json
flutter run   --flavor staging    -t lib/main_staging.dart    --dart-define-from-file=env/staging.json
flutter run   --flavor production -t lib/main_production.dart --dart-define-from-file=env/production.json

flutter build apk       --flavor dev        -t lib/main_dev.dart        --dart-define-from-file=env/dev.json
flutter build apk       --flavor staging    -t lib/main_staging.dart    --dart-define-from-file=env/staging.json
flutter build appbundle --flavor production -t lib/main_production.dart --dart-define-from-file=env/production.json

flutter build ios --flavor staging -t lib/main_staging.dart --no-codesign \
  --dart-define-from-file=env/staging.json
```

## Android

- Flavors live in `android/app/build.gradle.kts` (single `env` dimension).
- App name comes from a per-flavor `resValue` so `AndroidManifest.xml` uses `@string/app_name`.
- Production release is hard-blocked when `android/key.properties` is missing — the build script throws rather than fall back to debug signing. Dev/staging release fall back to debug signing.
- Maps key flows through a per-flavor `manifestPlaceholder` (`${MAPS_API_KEY}`) populated from Gradle properties (`MAPS_API_KEY_DEV` / `_STAGING` / `_PROD`). Local: set in `~/.gradle/gradle.properties`. CI: add as secrets when Phase 4 lands.
- `android/app/google-services.json` registers all three clients (`com.docdoc.app`, `.dev`, `.staging`) in the same Firebase project — the Google Services plugin matches by `applicationId` at build time. Split into per-source-set folders only if you ever move to separate Firebase projects per env.

## iOS

The xcconfig files and shared schemes are committed. The Xcode project
edits are driven by a Ruby script — re-runnable, idempotent, and safer
than hand-editing `project.pbxproj`.

**Committed:**
- `ios/Flutter/{Dev,Staging,Production}.xcconfig` — per-flavor overrides (`APP_DISPLAY_NAME`, `PRODUCT_BUNDLE_IDENTIFIER`, `FLUTTER_TARGET`)
- `ios/Flutter/{Debug,Profile,Release}-{dev,staging,production}.xcconfig` — 9 build-config files; each `#include`s the base mode + the per-flavor Pods xcconfig + the flavor shared
- `ios/Runner/Info.plist` — `CFBundleDisplayName` reads `$(APP_DISPLAY_NAME)`
- `ios/Podfile` — `project 'Runner'` map covers all 9 flavored configurations
- `ios/scripts/copy_google_service_info.sh` — body of the GoogleService-Info Run Script build phase
- `ios/scripts/wire_flavor_xcconfigs.rb` — wires each `<Mode>-<flavor>` build configuration to its xcconfig and strips inline overrides (`PRODUCT_BUNDLE_IDENTIFIER`, `INFOPLIST_KEY_CFBundleDisplayName`, `FLUTTER_TARGET`) that Xcode silently copies when duplicating configurations
- `ios/Runner.xcodeproj/xcshareddata/xcschemes/{dev,staging,production}.xcscheme` — one shared scheme per flavor, every action (Run/Test/Profile/Analyze/Archive) mapped to the matching `<Action>-<flavor>` configuration

**One-time setup on a fresh checkout:**

```bash
bundle install                              # fastlane + xcodeproj gems
cd ios && pod install --repo-update && cd ..
ruby ios/scripts/wire_flavor_xcconfigs.rb   # idempotent — safe to re-run
```

The one Xcode click that the Ruby script cannot do: the
**Copy Firebase config** Run Script build phase. Add it once per fresh
checkout (instructions in the next section). After that everything
builds from CLI.

Verify: `flutter build ios --flavor staging --no-codesign --dart-define-from-file=env/staging.json`.

Maps key on iOS: once Phase 4 lands, set `GOOGLE_MAPS_API_KEY` in each flavor xcconfig and read it in `AppDelegate.swift` via `GMSServices.provideAPIKey`. Not wired today.

### Per-flavor `GoogleService-Info.plist`

The plists live in `ios/config/<flavor>/GoogleService-Info.plist`. A Run
Script build phase copies the matching one into the app bundle at build
time.

Layout in the repo:

```
ios/
  config/
    dev/GoogleService-Info.plist        (com.docdoc.app.dev)
    staging/GoogleService-Info.plist    (com.docdoc.app.staging)
    production/GoogleService-Info.plist (com.docdoc.app)  ← TODO
  scripts/
    copy_google_service_info.sh
```

**Manual Xcode step (one-off):**

1. Open `ios/Runner.xcworkspace` → Runner target → **Build Phases**.
2. Click **+** → **New Run Script Phase**, name it `Copy Firebase config`.
3. Drag the new phase ABOVE `[CP] Embed Pods Frameworks` so the file is in
   place when Pods are linked.
4. Set the script to:
   ```bash
   "${SRCROOT}/scripts/copy_google_service_info.sh"
   ```
5. Add `${SRCROOT}/scripts/copy_google_service_info.sh` to **Input Files**.
6. Add `${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist`
   to **Output Files**.

**Missing right now:** download the production
`GoogleService-Info.plist` from Firebase Console (project `docdoc-59d1a` →
iOS app `com.docdoc.app`) and save it as
`ios/config/production/GoogleService-Info.plist`. Until that file exists,
the Run Script fails on production builds.

App icons: shared across flavors today. Split into
`AppIconDev.appiconset` / `AppIconStaging.appiconset` and set
`ASSETCATALOG_COMPILER_APPICON_NAME` per xcconfig when QA needs to tell
builds apart at a glance.

## CI

`.github/workflows/flutter-ci.yml` runs on PRs and pushes to `main` / `development`:

- `analyze` (ubuntu): `flutter pub get`, `dart format --set-exit-if-changed lib`, `flutter analyze`. Tests are intentionally omitted — the only test file is the default counter scaffold which doesn't apply to this app. Add real tests in a follow-up.
- `android-staging` (ubuntu): builds the staging APK from the committed `env/staging.json` and uploads it as a 7-day artifact. No secret materialisation step — env JSON is committed.

iOS CI job is omitted until the Apple Developer account is active and signing certs / App Store Connect API key are loaded as secrets. Adding it now would only produce red builds.

GitHub Secrets to provision when ready (none are required today):
- `ANDROID_KEYSTORE_B64`, `ANDROID_KEY_PROPERTIES` — for signed production AABs
- `APPLE_APP_STORE_CONNECT_API_KEY` — for TestFlight upload (once Apple Dev account is active)
- `PLAY_STORE_SERVICE_ACCOUNT_JSON` — for Play upload

## Fastlane

`Gemfile` pinned to fastlane `~> 2.220`. Run with `bundle install` then:

```bash
# Android — works today, no extra setup required.
bundle exec fastlane android build_dev
bundle exec fastlane android build_staging
bundle exec fastlane android build_production   # needs android/key.properties

# iOS — compile-only verification, no Apple Dev account needed.
bundle exec fastlane ios build_dev
bundle exec fastlane ios build_staging
bundle exec fastlane ios build_production
```

### Fastlane (iOS) — TestFlight readiness

Two TestFlight-ready lanes are wired but gated until the Apple Developer
account activates:

| Lane | What it does |
| --- | --- |
| `ios build_production_ipa` | Build a signed production `.ipa` (`build/ios/ipa/docdoc.ipa`). Needs a valid signing cert + provisioning profile. |
| `ios beta` | Build the IPA and upload it to TestFlight via App Store Connect API. Errors out with a clear message until credentials are present. |

To activate (once the Apple Dev account is live):

1. Fill `apple_id`, `itc_team_id`, `team_id` in `ios/fastlane/Appfile`.
2. App Store Connect → **Users and Access → Keys** → create an API key with the **Developer** role. Download the `AuthKey_<KEY_ID>.p8`. Save it as `ios/fastlane/AuthKey_<KEY_ID>.p8` (gitignored — already covered by the `*.p8` rule).
3. Export three env vars (use `direnv`, a `.envrc.local`, or your CI secret store):
   ```bash
   export APP_STORE_CONNECT_API_KEY_PATH="ios/fastlane/AuthKey_<KEY_ID>.p8"
   export APP_STORE_CONNECT_API_KEY_ID="<KEY_ID>"
   export APP_STORE_CONNECT_API_ISSUER_ID="<ISSUER_UUID>"
   ```
4. Open Xcode once and pick the signing team for each `Runner-<flavor>` configuration (Signing & Capabilities tab). Stick to **Automatic** signing for TestFlight — `match` can come later when more than one developer needs to sign locally.
5. Run `bundle exec fastlane ios beta`. The IPA uploads to TestFlight; internal testers can install it once Apple processes the build (5-15 min).

### Sharing builds with your team — today

**Android (works now):**

```bash
bundle exec fastlane android build_staging
# → build/app/outputs/flutter-apk/app-staging-release.apk
```

Hand the APK file to a teammate (Slack, AirDrop, Google Drive — anything).
On the device, Settings → Security → **Install unknown apps**, tap the
file. The app installs as **DocDoc Staging** alongside any production
DocDoc the user already has (different bundle ID).

The APK is also produced by CI on every push: GitHub → Actions → latest
`Flutter CI` run → Artifacts → `docdoc-staging-apk` (7-day retention).

**iOS (until Apple Dev account is active):**

No way to install an iOS app on a physical device without an Apple Dev
team. Options once the account is live:

- TestFlight (preferred for team-wide testing) — `bundle exec fastlane ios beta` once activated.
- Ad-hoc IPA — one-off signing with device UDIDs registered; useful only for a handful of testers.
- Xcode "Run on device" — direct install via cable, useful only for the developer's own phone.

Until then iOS verification stays at the simulator level
(`flutter run --flavor staging` on a simulator) and CI compile checks.

## Firebase registration status

All three Android clients are registered in Firebase project `docdoc-59d1a`
and present in `android/app/google-services.json` (`com.docdoc.app`,
`com.docdoc.app.dev`, `com.docdoc.app.staging`).

iOS: dev and staging `GoogleService-Info.plist` files live under
`ios/config/{dev,staging}/`. The production plist is **not yet present** —
download it from Firebase Console (iOS app `com.docdoc.app`) and save as
`ios/config/production/GoogleService-Info.plist` before the first
production iOS build. The Run Script picks the right plist at build time.

## Blocked TODOs

| Item | Unblocked by |
| --- | --- |
| Production iOS `GoogleService-Info.plist` | download from Firebase Console (project `docdoc-59d1a`, iOS app `com.docdoc.app`) → `ios/config/production/` |
| Production signing keystore | generate `docdoc-release.jks` + create `android/key.properties` (template documented in build script) |
| Apple Developer account active | external — paid signup |
| Google Maps API keys (Android + iOS) | Phase 4 — Maps migration from `flutter_map` to platform-conditional `google_maps_flutter` / `apple_maps_flutter` |
| Paymob public key | Phase 5 |
| Per-flavor Firebase projects | optional — Phase 11 enterprise pass if separate Crashlytics dashboards become valuable |
| Upload/deploy Fastlane lanes | Apple App Store Connect API key + Play Console service account JSON |
| iOS CI job | Apple Developer account + signing certs in CI secrets |
| Real unit/widget tests in CI | Phase 11 enterprise pass |
