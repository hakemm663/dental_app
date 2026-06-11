# DocDoc

> A production-style Flutter mobile app for discovering dentists, viewing doctor profiles and locations, and booking appointments end-to-end.

<p align="left">
  <img alt="CI" src="https://github.com/hakemm663/dental_app/actions/workflows/flutter-ci.yml/badge.svg?branch=development" />
  <img alt="License" src="https://img.shields.io/badge/license-portfolio-blue" />
</p>

DocDoc is a cross-platform Flutter app focused on a realistic healthcare booking experience: doctor discovery, search and filtering, doctor details, maps, appointment booking, payment flow, appointment management, notifications, and patient profile screens.

---

## Highlights

- **End-to-end patient journey** from discovery to confirmed booking
- **Feature-first Flutter structure** with `lib/core` and `lib/features`
- **Production-minded integrations** — secure storage, crash reporting, and Firebase App Check
- **Cloud-ready backend** using Firebase (auth, storage, functions, Crashlytics) and Supabase (DB / API)
- **Automated delivery** with GitHub Actions + Fastlane + Firebase App Distribution

---

## Features

### Patient experience

- Browse recommended dentists on a personalised home screen
- Search doctors by name with real-time results
- Filter by specialty and rating
- View doctor details, reviews, location, and consultation fee
- Book appointments with a step-based flow: date & time → payment method → summary → confirmation
- View upcoming, completed, and cancelled appointments
- Reschedule and cancel bookings
- Explore nearby doctors on a map
- Receive appointment and payment push notifications
- Manage profile, medical records, and payment methods

### Engineering capabilities

- Responsive Flutter UI
- Cubit/Bloc state management with sealed state classes (Dart 3+)
- GetIt dependency injection
- Secure local persistence
- Cloud-integrated auth and data workflows
- Crash reporting and abuse protection hooks
- CI/CD pipeline with format check, static analysis, and Firebase distribution

---

## Tech stack

| Layer | Technology |
|---|---|
| **Mobile** | Flutter · Dart · Material UI |
| **State management** | BLoC / Cubit (sealed states, no code generation) |
| **DI** | GetIt |
| **Backend** | Firebase (Auth · Storage · Functions · Crashlytics · App Check) |
| **Database / API** | Supabase |
| **Maps** | Google Maps / device location |
| **Storage** | flutter_secure_storage |
| **CI/CD** | GitHub Actions · Fastlane · Firebase App Distribution |
| **Platform** | Android · iOS |

---

## Architecture overview

```
dental_app/
├─ .github/
│  └─ workflows/
│     └─ flutter-ci.yml       ← analyse + Firebase App Distribution
├─ android/
│  └─ fastlane/               ← Fastlane lanes for Android builds
├─ ios/
├─ assets/
│  ├─ images/
│  ├─ svgs/
│  └─ icons/
├─ docs/
├─ env/                       ← local-only, never committed
├─ functions/                 ← Firebase Cloud Functions
├─ supabase/                  ← Supabase migrations / config
├─ lib/
│  ├─ core/
│  │  ├─ config/
│  │  ├─ di/
│  │  ├─ routing/
│  │  ├─ theme/
│  │  ├─ utils/
│  │  └─ widgets/
│  ├─ features/
│  │  ├─ auth/
│  │  ├─ home/
│  │  ├─ search/
│  │  ├─ doctor/
│  │  ├─ booking/
│  │  ├─ appointments/
│  │  ├─ notifications/
│  │  └─ profile/
│  ├─ doc_app.dart
│  └─ main.dart
├─ test/
└─ pubspec.yaml
```

**Layer responsibilities**

```
UI Layer  →  State Layer (Cubit)  →  Domain Layer (use cases)  →  Data Layer (repositories)
                                                                         ↓
                                                              Firebase · Supabase · Secure Storage · Maps
```

- UI has zero business logic — only rendering and state observation
- Cubits depend only on use cases, never directly on repositories
- Domain layer has zero Flutter imports
- All errors are typed `Failure` classes, never raw exceptions

---

## Setup and run

### Prerequisites

- Flutter SDK (stable channel)
- Android Studio + Android SDK
- Xcode + CocoaPods (iOS builds)
- Ruby + Bundler (Fastlane, optional locally)

### Clone

```bash
git clone https://github.com/hakemm663/dental_app.git
cd dental_app
git checkout development
flutter pub get
```

### Environment and secrets

Firebase and Supabase credentials are configured locally and must **not** be committed.

```bash
# Copy the example and fill in your local values
cp env/.env.example env/.env.dev
```

Required local files (gitignored):

```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
env/.env.dev
```

### Run

```bash
# Development
flutter run --flavor dev -t lib/main.dart

# Staging
flutter run --flavor staging -t lib/main.dart

# Production
flutter run --flavor production -t lib/main.dart
```

### Build

```bash
# Android APK (staging)
flutter build apk --flavor staging -t lib/main.dart

# Android App Bundle (production)
flutter build appbundle --flavor production -t lib/main.dart

# iOS IPA (production)
flutter build ipa --flavor production -t lib/main.dart
```

---

## CI/CD

The single workflow `.github/workflows/flutter-ci.yml` runs on every push and PR to `development`:

| Job | Trigger | What it does |
|---|---|---|
| **Analyze** | All pushes + PRs | `dart format` check · `flutter analyze` |
| **Distribute** | Push to `development` or manual dispatch | Fastlane `firebase_distribution` lane → Firebase App Distribution |

### Required GitHub secrets

| Secret | Purpose |
|---|---|
| `FIREBASE_CLI_TOKEN` | Firebase App Distribution uploads |
| `ANDROID_KEYSTORE_BASE64` | Release signing |
| `ANDROID_KEYSTORE_PASSWORD` | Release signing |
| `ANDROID_KEY_ALIAS` | Release signing |
| `ANDROID_KEY_PASSWORD` | Release signing |

### Fastlane

```bash
# Distribute to Firebase App Distribution (Android)
bundle exec fastlane android firebase_distribution
```

---

## Testing

```bash
flutter test
```

Test coverage targets:

- Unit tests — booking flow logic, use cases, failure mapping
- Widget tests — search/filter modal, booking stepper, doctor list
- Integration — happy-path appointment flow smoke test

---

## Screenshots

<table>
  <tr>
    <td align="center"><img src="assets/screenshot/Screenshot%202026-06-11%20at%2011.16.03%20PM.png" width="180"/><br/><sub>Home</sub></td>
    <td align="center"><img src="assets/screenshot/Screenshot%202026-06-11%20at%209.35.46%20PM.png" width="180"/><br/><sub>Doctor Details</sub></td>
    <td align="center"><img src="assets/screenshot/Screenshot%202026-06-11%20at%209.36.28%20PM.png" width="180"/><br/><sub>Booking — Date & Time</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/screenshot/Screenshot%202026-06-11%20at%209.36.41%20PM.png" width="180"/><br/><sub>Booking — Payment</sub></td>
    <td align="center"><img src="assets/screenshot/Screenshot%202026-06-11%20at%209.37.07%20PM.png" width="180"/><br/><sub>Booking — Summary</sub></td>
    <td align="center"><img src="assets/screenshot/Screenshot%202026-06-11%20at%209.37.19%20PM.png" width="180"/><br/><sub>Booking Confirmed</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/screenshot/Screenshot%202026-06-11%20at%209.31.42%20PM.png" width="180"/><br/><sub>My Appointments</sub></td>
    <td align="center"><img src="assets/screenshot/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-05-27%20at%2002.45.40.png" width="180"/><br/><sub>Messages</sub></td>
    <td align="center"><img src="assets/screenshot/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-05-27%20at%2002.45.47.png" width="180"/><br/><sub>In-app Chat (Agora)</sub></td>
  </tr>
</table>

---

## Demo, APK, and TestFlight

| Resource | Link |
|---|---|
| Demo video | _coming soon_ |
| Android APK (Firebase App Distribution) | [Install via Firebase](https://appdistribution.firebase.google.com/i/09343374ca772584) |
| TestFlight invite | _coming soon_ |

Recommended demo flow (45–90 s): Home → Doctor details → Booking flow → Payment → Confirmation → Appointments → Messages → In-app chat

---

## How to present this in interviews

- Built a realistic end-to-end healthcare booking flow, not isolated screens — can speak to product flow and implementation decisions together
- Clean architecture with a strict presentation → domain → data boundary; Cubits depend only on use cases
- Worked with cloud services (Firebase, Supabase), local persistence, maps, permissions, and release-minded delivery rather than only UI widgets
- Treated the project like a shippable product: CI/CD pipeline, Firebase App Distribution, Fastlane lanes, crash reporting, and App Check hooks

---

## Contributing

Contributions, feedback, and code review comments are welcome.

1. Fork the repository
2. Create a branch — `feature/<name>` / `fix/<name>` / `docs/<name>` / `chore/<name>`
3. Make your changes with `flutter analyze` passing clean
4. Run `flutter test`
5. Open a pull request with screenshots if UI changes are involved

---

## License

This repository is shared for portfolio and technical-review purposes. For reuse, add a `LICENSE` file (e.g. MIT) and update the badge above.

---

## Contact

**Mohamed Hakem**
- GitHub: [hakemm663](https://github.com/hakemm663)
- Email: hakemm663@gmail.com
