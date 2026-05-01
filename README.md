# Urdu Learning App

AI-powered Urdu learning mobile app built for early learners (KG/Nursery) and beginner-level Urdu practice.

## Purpose

This app is designed to help children and beginners learn Urdu in an engaging, interactive way.  
It combines visual learning, listening practice, speaking practice, and lightweight adaptive feedback so users can improve pronunciation and vocabulary over time.

## What This App Is About

The application focuses on foundational Urdu skills:

- recognizing letters (`حروف`)
- learning words (`الفاظ`) and basic sentences (`جملے`)
- understanding categories like colors, fruits, animals, and body parts
- practicing pronunciation with microphone-based scoring
- reinforcing learning through quizzes and matching activities

## Core Features

- **Onboarding flow**
  - first-time user setup with name capture and guided welcome

- **Lesson modules**
  - alphabet learning
  - word-building (`جوڑ توڑ`)
  - words and sentence lessons
  - colors, counting, singular/plural, and category-based lessons

- **Speech and pronunciation practice**
  - text-to-speech for listening
  - microphone recording for speaking attempts
  - pronunciation score feedback with retry flow

- **Quiz system**
  - words, sentences, colors, category quizzes
  - matching quiz mode
  - adaptive behavior based on weak areas and streaks

- **Progress tracking**
  - local persistence for user profile and history
  - weakness score tracking for practice personalization

- **RTL Urdu-first UI**
  - Urdu-first interface with dedicated Urdu typography support

## Tech Stack

- Flutter (Material UI)
- Provider (state management)
- `flutter_tts` for speech output
- `record` + backend scoring integration for pronunciation feedback
- `shared_preferences` for local storage

## Project Structure (High-level)

- `lib/main.dart` - app entry, routes, bootstrap
- `lib/screens/` - all lesson, quiz, onboarding, and hub screens
- `lib/widgets/` - reusable UI widgets (cards, avatar, mic recorder, nav)
- `lib/services/` - TTS, speech, API, storage services
- `lib/data/` - static lesson/quiz datasets
- `lib/providers/` - app-level state and progress logic
- `test/` - widget tests (startup test included)

## Run Locally

1. Install Flutter SDK and verify:
   - `flutter doctor`
2. Install dependencies:
   - `flutter pub get`
3. Run app:
   - `flutter run`

## Quality Checks

- Static analysis:
  - `flutter analyze`
- Tests:
  - `flutter test`

## Notes

- Some pronunciation/scoring behavior may use backend APIs depending on platform and configuration.
- Web and mobile speech behavior can differ due to platform-level speech APIs.

## Proper Team Setup

To collaborate cleanly, do not share generated folders like `build/`, `.dart_tool/`, or platform build outputs. These are recreated automatically on each machine and should stay out of the shared project copy.

Before a teammate runs the app, they should:

1. Install the Flutter SDK and an editor such as Android Studio or VS Code.
2. Run `flutter doctor` and fix any reported Android SDK, device, or toolchain issues.
3. Open the project folder and run `flutter pub get`.
4. Connect an Android device or start an emulator.
5. Run `flutter run` to launch the app.

Recommended checks before sharing changes with the team:

1. Run `flutter analyze` to catch code issues.
2. Run `flutter test` to confirm the existing tests still pass.
3. Avoid manually sending compiled output or temporary folders; only share the source project files.
