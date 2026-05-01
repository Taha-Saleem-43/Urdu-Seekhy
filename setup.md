# Proper Setup for Teammates

Use these steps to clone, verify, and run the app cleanly on a new machine.

## Prerequisites

- Install the Flutter SDK.
- Install Android Studio or VS Code with Flutter and Dart support.
- Install Android SDK platform tools and at least one Android emulator or a physical device.
- Make sure the machine has enough free disk space. Android debug/release builds can fail if the drive is nearly full.
- On a teammate's phone, enable Developer options and USB debugging before the first run.
- Keep microphone permission allowed when the app asks for it, because the app uses speech features.

## Clone the Repo

1. Clone the repository from GitHub.
2. Open the cloned folder in VS Code or Android Studio.
3. Check the Flutter environment:
   - `flutter doctor`
4. Get dependencies:
   - `flutter pub get`
5. If you changed Android files or want a fresh build, clean generated outputs first:
   - `flutter clean`

## Run the App

- For a debug launch on a connected device or emulator:
  - `flutter run`
- For a release APK build:
  - `flutter build apk`
- Before the first phone run, unlock the device, accept the USB debugging prompt, and keep the cable connected until the app starts.
- If the phone asks for microphone permission, allow it so speech practice works.

## Check Before Adding Features

Before adding new screens or logic, make sure the baseline app works first:

1. Run `flutter analyze`.
2. Run `flutter test`.
3. Run `flutter run` on a real device or emulator.
4. Fix any build or runtime issue before adding new code.

This avoids mixing new feature work with existing build errors.

## What This Repo Needs

- The Android release build uses Play Core support for Flutter split/deferred component classes.
- The Android Gradle heap settings were reduced so the build can run on lower-RAM machines.
- Local Android files such as `android/local.properties` and `android/key.properties` should stay uncommitted.

## If Build Fails

- If `flutter build apk` fails with missing classes, run the build again after checking Android dependencies.
- If Gradle crashes or the build says there is not enough memory, close other apps and make sure the drive has free space.
- If `flutter run` disconnects from the device, reconnect the USB cable or restart ADB/emulator and try again.

## Recommended Verification

- `flutter analyze`
- `flutter test`
- `flutter run`
- `flutter build apk`

## Notes for Teammates

- Do not commit generated folders like `build/` or `.dart_tool/`.
- Do not commit local Android signing or machine-specific config files.
- If the app is launched on a real device, keep the device unlocked and connected during the first run.
- If the app still disconnects on a phone, reconnect the cable, reopen the device, and run `flutter run` again after confirming `adb devices` shows the phone as authorized.