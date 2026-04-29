# Flutter iOS & Android Fix Plan

## Phase 1: Critical Android Fixes
- [ ] Fix AndroidManifest.xml - Add INTERNET permission
- [ ] Fix settings.gradle.kts - Change Kotlin version from 2.2.20 to 2.0.20

## Phase 2: Flutter Configuration Fixes
- [ ] Fix main.dart - Initialize easy_localization
- [ ] Create translation files for easy_localization
- [ ] Fix flutter_native_splash.yaml - Complete android_12 configuration

## Phase 3: iOS Production Readiness
- [ ] Fix ios/Podfile - Add conditional code signing

## Phase 4: Android Production Configuration
- [ ] Fix android/app/build.gradle.kts - Update namespace to com.docdoc.app

## Phase 5: Build & Test Commands
- [ ] flutter clean
- [ ] flutter pub get
- [ ] dart run build_runner build --delete-conflicting-outputs
- [ ] flutter pub run flutter_native_splash:create
- [ ] cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
- [ ] flutter run -d android
- [ ] flutter run -d ios
