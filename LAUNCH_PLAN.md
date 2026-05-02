# DocDoc — Launch Plan (App Store + Google Play)

> Source of truth for taking this Flutter app from current state to public release.
> **API:** `https://vcare.integration25.com/api/` (VCare Live, Postman collection: 7 modules)
> **Design:** Figma `BY01Z4ZhVGS0nGeZNi8yTZ` — 35 screens identified
> **Date:** 2026-05-02

---

## 1. Project audit — what exists vs what's missing

### 1.1 What you actually built (your logic, traced)
- `main.dart` → `setupGetIt()` → `DocApp(appRouter: AppRouter())`
- `core/networking/`: `ApiService` (Retrofit), `DioFactory` (Dio + PrettyDioLogger), `ApiResult<T>` (Freezed sealed `success/failure`), `ErrorHandler` mapping `DioException` → `ApiErrorModel`
- `core/di/dependency_injection.dart`: registers `ApiService` + repos + cubits as lazy singletons
- `core/routing/app_router.dart`: name-based router, wraps each route in `BlocProvider(getIt<XCubit>())`
- `core/theming/`: `ColorsManager`, `TextStyles`, `FontWeightHelper`
- `core/helpers/`: spacing, extensions, `SharedPrefHelper` (uses `flutter_secure_storage`), constants
- `core/widgets/`: `AppTextButton`, `AppTextFormField`
- **Login feature** (your code): `LoginRepo` → `ApiResult<LoginResponse>`, `LoginCubit` (Freezed state), `LoginScreen` UI
- **Onboarding** (your code): static screen with logo + image + "Get Started" → login
- **Home / Doctors / Appointment / Profile** (AI-generated, not following your style): plain models, plain repos returning raw `Map`/typed lists, cubits with `part`-file states, screens that don't use `BlocProvider.of` properly

### 1.2 Conflicts between `CLAUDE.md` and the actual codebase

| `CLAUDE.md` rule | Reality |
|---|---|
| **No Freezed. No build_runner.** Use Dart 3+ `sealed class` | `pubspec.yaml` has `freezed`, `freezed_annotation`, `json_serializable`, `retrofit_generator`, `build_runner`. `ApiResult` and `LoginState` use Freezed. All models use `json_serializable` |
| **Cubits depend ONLY on use cases** | Every Cubit depends directly on a Repo. No `domain/` folder exists |
| **Domain layer must have ZERO Flutter imports** | Domain layer doesn't exist |
| **Feature folder: data / domain / presentation** | Login uses `data / logic / ui`; Home uses `data / logic / ui`. Neither has `domain` or `presentation` |
| **Use cases return `ApiResult<T>`** | Only `LoginRepo` returns `ApiResult`. All home/doctor/appointment repos `rethrow` raw exceptions, breaking the failure contract |
| **`/code-review` skill before "done", `/create-pr` after** | No evidence run on the AI-generated home/doctors code |

**Decision needed (block of plan §3):** keep Freezed/codegen and **rewrite `CLAUDE.md`** to match, OR rip out Freezed/codegen and refactor all state classes to `sealed class`. **Recommendation: keep Freezed** — it's already wired, models work, and replacing it adds 1–2 days of churn with no user-visible benefit. We update CLAUDE.md to match reality.

### 1.3 Concrete bugs I found while reading
1. **Login screen never calls the cubit** — `login_screen.dart:88-91` validates the form and goes straight to `Routes.homeScreen`. No `BlocConsumer`, no `emitLoginStates`, no token saved.
2. **Login error message always blank** — `api_error_handler.dart:153` defines `ApiErrorModel? get failure => null;`. `login_cubit.dart:20` reads `error.failure?.message ?? ''`, so users always see "".
3. **Auth token never set on Dio** — `DioFactory.addDioHeaders()` is `async` but called synchronously inside `getDio()`; the `await SharedPrefHelper.getSecuredString(...)` resolves *after* `getDio()` returns. First N requests go without `Authorization`. `setTokenIntoHeaderAfterLogin` overwrites all headers (drops `Accept: application/json`).
4. **Home screen pulls cubits from `getIt` directly inside `initState`**, bypassing the `BlocProvider` it was wrapped in (`home_screen.dart:18-20`). Works only because they're lazy singletons — fragile.
5. **`HomeState` accessor `state.specializations` etc.** is referenced in UI on initial state where the field doesn't exist. Will throw at runtime on the first `build`.
6. **`DoctorsState.errorMessage` reference** on a sealed/union state — same risk.
7. **Android `applicationId = com.example.docdoc`** and namespace identical → Play Store will **reject** the upload.
8. **iOS `PRODUCT_BUNDLE_IDENTIFIER`** still uses Xcode default `com.example.docdoc`. App Store will reject.
9. **No release signing** — Android `release` buildType uses debug keystore (`build.gradle.kts` line 34 TODO).
10. **`pod install` warning** — Release/Profile xcconfigs don't include the Pods xcconfig. Release builds will miss flags.
11. **No app icon** — still default Flutter icon on both platforms.
12. **`flutter_native_splash.yaml` minimal** — splash isn't fully configured.
13. **`easy_localization` in pubspec but never initialized** in `main.dart` / no `assets/translations` folder.
14. **`postman_collection.json` checked into repo** (22 KB) — fine to keep but should be in `docs/`.
15. **Hard-coded base URL** — `vcare.integration25.com` is the test API; no env separation (dev/staging/prod).
16. **Routes use `String` constants, args use `as int` / `as DoctorModel`** — runtime cast crash if anything's wrong. No type-safe router.
17. **`linux/` directory was added** (untracked in git) — unintended, can be removed if you're not shipping desktop.
18. **No tests** beyond default `widget_test.dart`. CLAUDE.md mandates tests for domain & data.
19. **No analytics, no crash reporting** — needed for store readiness.
20. **`api_ruslt.dart` filename typo** ("ruslt" → "result") — cosmetic.

### 1.4 Figma vs implemented screens

| In Figma (35 screens) | Implemented |
|---|---|
| Splash, Onboarding, **Sign In**, **Sign Up**, **Forgot Password** | Splash, Onboarding, Sign In (UI only) |
| Notification, **Find Nearby**, **Doctor Speciality**, **Recommendation Doctor**, Detail Doctor (Address + Review), **Book Appointment / Payment**, Review | Doctor Details (stub), Book Appointment (stub) |
| **Inbox** (+ Create Message, Conversation, Gallery, Attach Files), **Camera**, **Video Call** | none |
| **Search** (+ Result, Sort By) | text field only |
| **My Appointments** (Upcoming / Completed / Cancelled tabs) | Appointments (single screen stub) |
| **Profile**, **Setting**, **Payment**, **Medical Record**, **Personal Information**, **Notification Settings**, **Security**, **Language**, **FAQ** | Profile (stub) |

→ ~30 of 35 screens are not built. We will build the **MVP slice (12 screens)** to ship v1.0, defer the rest to v1.1/v1.2.

### 1.5 Postman collection coverage

7 modules; the API service already declares all the endpoints. **Two adjustments needed:**
- Auth uses `formdata`, not JSON. Current `LoginRequestBody.toJson()` + Retrofit `@Body()` will send JSON. Must use `@Field()` with `@FormUrlEncoded()` or `MultipartFile`. **Login is broken end-to-end today.**
- Logout endpoint (`POST /auth/logout`) not in `ApiService`.
- Register endpoint (`POST /auth/register`) not in `ApiService`.

---

## 2. MVP scope for v1.0 (what ships to stores)

**Goal:** smallest credible app that demonstrates the core flow: discover doctor → book appointment → manage appointments → manage profile.

### 2.1 In-scope screens (12)
1. Splash (native)
2. Onboarding (1 page) ✅ exists
3. Sign In ✅ exists (UI), needs wiring
4. Sign Up (new)
5. Forgot Password — *placeholder screen with "coming soon" if API not ready; otherwise wire it*
6. Home / Find Nearby (specializations + recommended doctors + search bar)
7. Doctor Speciality list
8. Doctor Details (Address tab only for v1; Review tab v1.1)
9. Book Appointment (date/time + notes; no payment v1)
10. My Appointments (Upcoming / Completed / Cancelled tabs)
11. Profile
12. Personal Information / Edit profile

### 2.2 Out-of-scope for v1 (deferred to v1.1+)
- Inbox / Chat / Camera / Video Call
- Payment integration
- Reviews & ratings (read-only OK in v1, write deferred)
- Medical Record, FAQ, Language switcher, Security
- Notifications (push) — set up infra in v1, ship feature in v1.1

### 2.3 Cross-cutting requirements
- Authentication flow (login persists token; auto-login if token; logout clears)
- Error states + empty states + loading states on every list
- Pull-to-refresh on Home, Doctors, Appointments
- Locale: English only v1; Arabic in v1.1 (RTL test required)
- Theming: light only v1
- Min OS: Android 7 (API 24), iOS 13

---

## 3. Architecture decisions (ratify before code)

### 3.1 Remove Freezed and all codegen — strict CLAUDE.md compliance
**Decision (locked, see §9):** rip out `freezed`, `json_serializable`, `retrofit`, `build_runner`. Replace with hand-written `sealed class` for unions, hand-written `fromJson`/`toJson` for models, hand-written `ApiService` over `Dio`. See §9.1 for the full migration list.

### 3.2 Introduce a thin domain layer — but with use-case classes, not interfaces
Per `CLAUDE.md` §B.1 ("Cubits depend ONLY on use cases"). For each repo method that a cubit calls, add a one-method use case class. Repos stay in `data/`. Domain folder is `lib/features/{feature}/domain/use_cases/`. Use-case classes are pure Dart, no Flutter imports.

Example:
```
features/login/
  data/
    repos/login_repo.dart
    models/...
  domain/
    use_cases/login_use_case.dart   // calls _loginRepo.login(body)
  presentation/                       // rename `ui/` → `presentation/`
    cubit/login_cubit.dart            // depends on LoginUseCase
    screens/login_screen.dart
    widgets/...
```

### 3.3 Make every repo return `ApiResult<T>`
Today only `LoginRepo` does. Refactor `HomeRepo`, `DoctorRepo`, `AppointmentRepo` so cubits handle `success`/`failure` instead of `try/catch e.toString()`. Fix the `ApiErrorHandler.handle` to return a real `ApiErrorModel` (currently the `failure` getter returns `null`).

### 3.4 Type-safe routing via `go_router` (or stick with `onGenerateRoute`?)
Decision: **stay with `onGenerateRoute`** for v1 — adding `go_router` mid-project is scope creep. We just tighten args by passing typed `RouteSettings.arguments` and adding helper methods on `Routes`.

### 3.5 Environment config
Add `lib/core/config/env.dart` with `Env.dev`, `Env.staging`, `Env.prod` (different baseUrl). Selected via `--dart-define=ENV=prod` at build time. No new package needed.

### 3.6 Token handling
- Save token in `flutter_secure_storage` after login (`SharedPrefKeys.userToken`).
- Add a `Dio` interceptor that reads the token *per request* (async, awaited). Replaces `addDioHeaders()`.
- 401 interceptor → clear token, kick to Sign In.

### 3.7 Folder-rename plan
- `lib/features/*/ui/` → `lib/features/*/presentation/`
- `lib/features/*/logic/cubit/` → `lib/features/*/presentation/cubit/`
- `core/networking/api_ruslt.dart` → `core/networking/api_result.dart`

### 3.8 Use of project skills
Per `CLAUDE.md` §A.8:
- **`/flutter-cubit`** before creating any new cubit/state file
- **`/flutter-code-review`** at end of each phase before saying "done"
- **`/flutter-pr`** to generate branch/commit/PR after review passes
- **`/security-review`** before submitting to stores

---

## 4. Run-blocking platform fixes (do first, before coding features)

### Phase 0 — Make iOS + Android run cleanly

**Android:**
- [ ] Change `applicationId` from `com.example.docdoc` → real ID, e.g. `com.docdoc.app` (or your own). Update `namespace` to match.
- [ ] Generate upload keystore (`keytool -genkey ...`), create `android/key.properties` (gitignored), wire it into `build.gradle.kts` for the `release` buildType. Remove TODO.
- [ ] Add `INTERNET` permission to `AndroidManifest.xml` (it's missing — required for Dio).
- [ ] Bump `minSdk` to 24 (or whatever your Firebase floor is) — currently inheriting Flutter default.
- [ ] Add ProGuard / R8 rules for Retrofit/Dio if release build is shrinking.
- [ ] Set proper `android:label` (currently "docdoc" lowercase) → "DocDoc".

**iOS:**
- [ ] In Xcode, set `PRODUCT_BUNDLE_IDENTIFIER` to e.g. `com.docdoc.app` for all 3 configs (Debug/Profile/Release).
- [ ] Set `CFBundleDisplayName` already "Docdoc" — OK; verify casing matches store listing.
- [ ] Add `NSAppTransportSecurity` exceptions only if API uses HTTP (it's HTTPS, so likely none needed).
- [ ] Fix the `pod install` warning by including `Pods-Runner.{profile,release}.xcconfig` in `Flutter/{Profile,Release}.xcconfig`.
- [ ] Set deployment target ≥ iOS 13 (already set in Podfile).
- [ ] Add app icon and launch image (currently default).
- [ ] Configure signing & capabilities, Apple Developer team selected.

**Both:**
- [ ] `flutter clean && flutter pub get && (cd ios && pod install)` clean baseline.
- [ ] Add app icons via `flutter_launcher_icons` (new dep, justified). Source from Figma logo.
- [ ] Configure splash via existing `flutter_native_splash` package (run `dart run flutter_native_splash:create`).

**Acceptance:** `flutter run` succeeds on a real iPhone and a real Android device, app boots to onboarding with the correct icon.

---

## 5. Phased delivery

Each phase ends with `/flutter-code-review` → `/flutter-pr`. Estimates assume one engineer working focused.

### Phase 0 — Run-blocking platform fixes (1 day)
See §4. Output: app builds & runs on both platforms. PR title: `chore(platform): fix iOS/Android build, set bundle IDs, add icons & splash`.

### Phase 1 — Architecture realignment + codegen removal (3 days)
- [ ] Remove `freezed`, `freezed_annotation`, `json_annotation`, `json_serializable`, `retrofit`, `retrofit_generator`, `build_runner` from `pubspec.yaml`.
- [ ] Convert `ApiResult<T>` from Freezed → hand-written `sealed class ApiResult<T>` with `Success<T>` / `Failure<T>`; rename file to `api_result.dart`.
- [ ] Convert `LoginState` from Freezed → hand-written `sealed class`.
- [ ] Convert `ApiService` from Retrofit → hand-written `Dio`-backed class with explicit endpoint methods.
- [ ] Convert every model with `*.g.dart` to hand-written `fromJson`/`toJson` (DoctorModel, CityModel, GovernorateModel, SpecializationModel, UserModel, AppointmentModel, ApiErrorModel, plus new ones for sign up).
- [ ] Delete all generated `*.freezed.dart` and `*.g.dart` files.
- [ ] Update every `switch` over old Freezed states to use Dart 3 pattern matching on the new sealed types.
- [ ] Rename folders: `ui/` → `presentation/`, `logic/cubit/` → `presentation/cubit/`.
- [ ] Fix `ApiErrorHandler.failure` getter (return real `apiErrorModel`).
- [ ] Refactor `HomeRepo`, `DoctorRepo`, `AppointmentRepo` to return `ApiResult<T>`.
- [ ] Add `Env` config + `--dart-define=ENV=...` build profile.
- [ ] Add Dio interceptor for token (async-correct) + 401 handler.
- [ ] Introduce `domain/use_cases/` for each feature; cubits depend on use cases, not repos.
- [ ] Update `dependency_injection.dart` to register use cases.

PR: `refactor(arch): remove freezed/retrofit/build_runner, add domain layer, ApiResult everywhere`.

### Phase 2 — Auth (Sign In, Sign Up, Forgot Password) (2 days)
- [ ] Switch login API call to `@FormUrlEncoded` + `@Field()` (Postman uses formdata).
- [ ] Wire `LoginScreen` to `LoginCubit` via `BlocConsumer`. Show loading, errors, success → save token → navigate to home.
- [ ] Build `SignUpScreen` per Figma `1:4811`. Add `RegisterRequestBody`, `RegisterUseCase`, cubit.
- [ ] Add `ForgotPasswordScreen` (placeholder if API absent).
- [ ] Persist token, build auto-login on splash.
- [ ] Logout endpoint + cubit + flow from Profile.

PR: `feat(auth): sign in, sign up, forgot password, persisted session`.

### Phase 3 — Home + Doctor Discovery (3 days)
- [ ] Home screen per Figma (search bar, specializations chips, recommended doctors).
- [ ] Doctor Speciality list screen.
- [ ] Search screen + Search Result + Sort By.
- [ ] Filter by city + specialization.
- [ ] Doctor Details screen (Address tab).

PR: `feat(home): doctor discovery, search, filter, doctor details`.

### Phase 4 — Appointments (2 days)
- [ ] Book Appointment screen (date/time picker, notes, doctor preview).
- [ ] My Appointments screen with Upcoming/Completed/Cancelled tabs.
- [ ] Cancel appointment flow.

PR: `feat(appointments): book, list, cancel`.

### Phase 5 — Profile (1 day)
- [ ] Profile main screen.
- [ ] Personal Information edit screen.
- [ ] Logout.

PR: `feat(profile): view + edit personal info, logout`.

### Phase 6 — Quality, observability, store-readiness (2 days)
- [ ] Add `firebase_core` + `firebase_crashlytics` (or Sentry — choose one).
- [ ] Add basic analytics (`firebase_analytics`) — events: signup, login, book_appointment, search.
- [ ] Empty states, error states, no-internet banner.
- [ ] Pull-to-refresh on lists.
- [ ] Tests: unit tests for use cases + repos (CLAUDE.md §A.7).
- [ ] Run `/security-review`.
- [ ] Bump `version: 1.0.0+1` per release; document in CHANGELOG.

PR: `chore(release): crash reporting, analytics, tests, polish for v1.0.0`.

### Phase 7 — Store submission (1–2 days, mostly waiting)
See §6.

**Total engineering: ~13 days.** Plus ~3–7 days of store review wait time.

---

## 6. Store submission checklist

### 6.1 Google Play
- [ ] Google Play Console developer account ($25 one-time).
- [ ] Privacy Policy URL hosted publicly.
- [ ] Data Safety form (what we collect: email, name, phone, location? appointment data — declare each).
- [ ] Content rating questionnaire.
- [ ] Target audience & content (medical → likely Mature 17+? confirm via questionnaire).
- [ ] App access — provide test credentials for review.
- [ ] Build AAB: `flutter build appbundle --release --dart-define=ENV=prod`.
- [ ] Upload to Internal testing track first → Closed → Production.
- [ ] Store listing: short description (80 char), full description (4000 char), 2+ screenshots per form factor (phone, 7" tablet, 10" tablet), feature graphic 1024×500, app icon 512×512.
- [ ] Health/medical disclosure: state that the app does **not** provide medical advice and is a booking tool only.

### 6.2 App Store (iOS)
- [ ] Apple Developer Program ($99/year).
- [ ] App Store Connect: create app record with bundle ID `com.docdoc.app`.
- [ ] Privacy Nutrition Labels (similar to Play Data Safety).
- [ ] Build IPA: `flutter build ipa --release --dart-define=ENV=prod`. Upload via Transporter or `xcodebuild -exportArchive`.
- [ ] TestFlight internal → external → submit for review.
- [ ] Screenshots: 6.7", 6.5", 5.5" iPhone; 12.9" iPad if claiming iPad support.
- [ ] App Review Information: demo account, contact phone, notes.
- [ ] Health/medical disclosure same as Play.
- [ ] Sign-in with Apple — **required** by App Store guideline 4.8 if you offer 3rd-party login. v1 has only email/password, so we're fine. Add Apple sign-in only if we add Google/Facebook login.

### 6.3 Legal & content
- [ ] Privacy Policy (covers PII: email, name, phone, location, appointment history). Hosted at `/privacy`.
- [ ] Terms of Service. Hosted at `/terms`. Linked from app.
- [ ] Update existing `TermsAndConditionsText` widget to link to live URLs.

### 6.4 Marketing assets (from Figma)
- [ ] App icon set (1024×1024 master).
- [ ] Feature graphic.
- [ ] 4–8 screenshots showing onboarding → sign in → home → doctor details → book → my appointments → profile.
- [ ] Optional 30-second promo video.

---

## 7. Risks and unknowns

1. **API readiness** — Postman shows endpoints documented but not all responses are populated (e.g. Logout/UserProfile have empty `response: []`). Need to live-test each before relying on it.
2. **Forgot Password endpoint not in Postman.** Need backend confirmation; otherwise screen ships as "Contact support".
3. **Payment** intentionally deferred. Confirm v1 launch is acceptable as a free booking app (no in-app purchases).
4. **Medical app review scrutiny** — both stores have stricter review for health categories. Bake explicit "informational only / not medical advice" copy into onboarding & T&C.
5. **Localization** — Figma is English-only as far as I checked. Arabic deferred to v1.1 keeps scope sane.
6. **Authority to use VCare backend in production** — `vcare.integration25.com` looks like a shared sandbox. Confirm there's a prod URL or that this URL is acceptable for prod.

---

## 8. Definition of Done for v1.0

- [ ] All 12 MVP screens implemented and matched against Figma at >=90% visual fidelity (use ScreenUtil + tokens).
- [ ] All API integrations validated against Postman with real network calls.
- [ ] No `setState` for business logic (CLAUDE.md §B.1). All cubit states sealed via Freezed.
- [ ] No Flutter imports under `domain/`. (CLAUDE.md §B.3)
- [ ] `flutter analyze` clean (info-level lints OK; zero warnings/errors).
- [ ] Unit tests cover every use case + repo happy-path + error-path.
- [ ] App runs on Android 7+ and iOS 13+ devices.
- [ ] Crashlytics integrated, test crash logged.
- [ ] Privacy policy + Terms hosted, linked in app.
- [ ] Internal Play track + TestFlight build available.
- [ ] All `/code-review` findings resolved before each PR merge.

---

## 9. Locked decisions (2026-05-02)

| # | Decision | Value |
|---|---|---|
| 1 | **Bundle ID** | `com.docdoc.app` (Android `applicationId` + `namespace`, iOS `PRODUCT_BUNDLE_IDENTIFIER`) |
| 2 | **API base** | `https://vcare.integration25.com/api/` for v1 (per Postman) |
| 3 | **Crash reporting** | Firebase Crashlytics (+ Firebase Analytics) |
| 4 | **v1 scope** | 12 MVP screens (§2.1). Inbox / Chat / Camera / Video Call / Payment / Reviews-write deferred to v1.1+ |
| 5 | **Localization** | English only in v1; Arabic + RTL in v1.1 |
| 6 | **Codegen** | **REMOVED** — strict adherence to `CLAUDE.md`. No Freezed. No `json_serializable`. No `retrofit`. No `build_runner` |

### 9.1 Implications of decision #6 (no codegen)

This is the largest single piece of work in Phase 1. Concretely:

**Remove from `pubspec.yaml`:**
- `freezed`, `freezed_annotation`
- `json_annotation`, `json_serializable`
- `retrofit`, `retrofit_generator`
- `build_runner` (dev)

**Replace:**
- `ApiResult<T>` (Freezed sealed) → `sealed class ApiResult<T>` + `final class Success<T>` / `final class Failure<T>`. Pattern-match with `switch`.
- `LoginState` (Freezed) → `sealed class LoginState` with `LoginInitial` / `LoginLoading` / `LoginSuccess(LoginResponse)` / `LoginError(String)`.
- Every state class for new cubits → same pattern.
- `ApiService` (Retrofit) → plain `ApiService` class wrapping `Dio` with explicit methods (`Future<Response<dynamic>> login(...)`). Per-feature repos do the JSON parsing.
- All `*.g.dart` model files → handwritten `factory X.fromJson(Map<String, dynamic> json)` and `Map<String, dynamic> toJson()`.

**Delete generated files:** `api_ruslt.freezed.dart`, `login_state.freezed.dart`, all `*.g.dart`.

**Justification:** `CLAUDE.md` is the locked spec going forward. Codegen adds friction for an indie team (every model edit needs a `build_runner` run; merge conflicts on generated files). Handwritten serialization is a one-time cost for ~10 models.

### 9.2 Architecture decision #2 still stands
Domain layer with use-case classes, repos return `ApiResult<T>`, cubits depend on use cases. (§3.2, §3.3, §3.6)

### 9.3 Updated Phase 1 estimate
With codegen removal added, Phase 1 grows from 2 days → **3 days**. Total project ≈ **14 engineering days**.

---

## 10. Next action

**You:** switch the model with `/model sonnet` (Opus stays good for planning; Sonnet for high-volume implementation).

**Me, on Sonnet:**
1. Create branch `features/launch-prep` off `development`.
2. Execute **Phase 0** (platform fixes per §4) — bundle IDs, signing, icons, splash, `INTERNET` permission, Pods xcconfig, `flutter_launcher_icons`. Run `flutter run` on simulators to confirm green.
3. End Phase 0 with `/flutter-code-review` → fix anything flagged → `/flutter-pr` to open PR against `development`.
4. After you merge, start **Phase 1** (architecture refactor + codegen removal).
5. Repeat for Phases 2–7.

I'll surface any decision that wasn't covered in this plan before acting on it.
