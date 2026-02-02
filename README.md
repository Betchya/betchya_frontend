# Betchya Frontend

Betchya is a Flutter mobile application that enables tribal casinos to offer a branded, on-premises sportsbook experience alongside hospitality, events, promotions, and rewards — all within a single app.

This repository contains the **frontend mobile application** only.

---

## Tech Stack

- **Flutter**
- **Dart**
- **State Management:** Bloc
- **Architecture:** Layered (UI → Bloc → Repository → API)
- **Platforms:** iOS / Android

---

## Core Principles

- This is **not** a consumer sportsbook like DraftKings or FanDuel.
- The casino’s brand and business come first; Betchya operates behind the scenes.
- Real-money betting is **geo-fenced** to casino premises.
- The app must support both **token-based play** and **on-premises wagering**, depending on tribal and state legality.

---

## Project Structure (High Level)

lib/
├─ features/ # Feature-based modules (auth, sportsbook, etc.)
├─ shared/ # Reusable UI, utilities, theming
├─ core/ # App-wide concerns (routing, config, errors)
└─ main.dart

### Where logic lives
- **Business logic:** Bloc classes
- **Side effects / data access:** Repositories
- **UI:** Widgets only (no business logic)

### Where logic does NOT live
- Widgets
- UI helpers
- Screens or pages

---

## State Management Rules

- Bloc is the **only** state management pattern used.
- Do not introduce Riverpod, Provider, MobX, or custom state systems.
- UI communicates with the app exclusively through events and states.

---

## Running the App

```bash
flutter pub get
flutter run
