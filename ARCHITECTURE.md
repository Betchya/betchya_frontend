# Architecture — Betchya Frontend

This document defines the architectural rules for the Betchya mobile application.
All contributors — human or AI — must follow these rules.

---

## Architectural Overview

The app uses a **layered, feature-based architecture** with explicit data flow.

**Data flows in one direction only:**

UI → Bloc → Repository → Data

There are no exceptions to this rule.

---

## Layer Responsibilities

### UI Layer
- Flutter widgets only
- Renders state
- Dispatches Bloc events
- Contains no business logic
- No data access

**UI must never:**
- Call repositories directly
- Contain conditional business rules
- Perform side effects

---

### Bloc Layer
- Owns all business logic
- Defines events and states
- Coordinates use cases
- Handles validation and decision-making

**Bloc must:**
- Be deterministic and testable
- Depend only on repositories
- Remain UI-agnostic

**Bloc must never:**
- Know about widgets
- Call data sources directly
- Contain platform-specific code

---

### Repository Layer
- Abstracts data access
- Prepares and normalizes data for consumption
- Combines multiple data sources when needed

Repositories:
- May map data into domain-friendly structures
- Must not encode business rules or decisions
- Do not determine UI behavior or feature logic

Repositories decide *how data is retrieved*, not *how it is interpreted*.

---

### Data Layer
- Concrete implementations of data access
- May include:
  - Remote APIs
  - Third-party SDKs
  - Local storage
  - Mock or fake data sources

The Data layer is **replaceable** and **isolated**.

---

## Feature-Based Structure

UI and state management are organized by feature.
Data access is organized into reusable packages.

Example:
features/
    auth/
        bloc/
        view/
packages/
    auth_repository/
        lib/
            src/


- Features own UI and Blocs
- Packages own Repositories and Data implementations
- Blocs depend on repositories via public package APIs

This separation improves modularity and testability.

Shared or cross-cutting code lives in `shared/` or `core/`.

---

## Packages & Code Generation

Reusable infrastructure and data access are organized as Dart packages.

- New packages are generated using `very_good_cli`
- Packages must follow standard Very Good Ventures conventions
- Public APIs are exposed via barrel files (`lib/<package_name>.dart`)
- Internal implementation details live under `lib/src/`

Blocs and UI depend only on a package’s public barrel file.
They must not import files from `src/` directly.

---

## State Management

- Bloc is the **only** state management solution.
- Do not introduce alternative patterns.
- Each screen is driven by one or more Blocs.
- State transitions must be explicit.

---

## Dependency Rules

- Dependencies point **inward**, never outward.
- UI depends on Bloc
- Bloc depends on Repository
- Repository depends on Data

No layer may skip another layer.

---

## Error Handling

- Errors are handled at the Bloc layer.
- UI renders error states, it does not interpret them.
- Data layer errors are mapped to domain-relevant failures before reaching UI.

---

## Testing Expectations

- Blocs must be unit-testable.
- Repositories should be mockable.
- UI tests should assume Bloc correctness.

---

## Guidance for AI Contributions

When generating or modifying code:
- Preserve existing patterns
- Extend existing Blocs before creating new ones
- Do not introduce new architectural layers
- Ask before restructuring folders or flows

This document is authoritative.
If something conflicts with this file, this file wins.

---
