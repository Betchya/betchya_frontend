# AI Contributing Guidelines

This repository is frequently modified using AI-assisted tools.
These rules exist to ensure safety, consistency, and correctness.

All AI-generated changes must follow these guidelines.

---

## Primary Rule

**Make the smallest correct change possible.**

Avoid refactors, abstractions, or optimizations unless explicitly requested.

---

## Allowed AI Tasks

AI tools may:
- Add or extend features within existing architecture
- Modify UI to reflect existing state
- Add events, states, or handlers to existing Blocs
- Fix bugs with clear reproduction steps
- Add tests for existing behavior
- Use `very_good_cli` conventions when creating or modifying packages.

---

## Prohibited AI Behavior

AI tools must NOT:
- Introduce new architectural patterns
- Add new state management solutions
- Bypass Blocs or Repositories
- Invent product features or flows
- Make assumptions about legality or availability
- Add dependencies without approval
- Manually scaffold new packages.
- Bypass package barrel files or import from `lib/src/`.

---

## Architectural Compliance

All changes must comply with:
- `ARCHITECTURE.md`
- `PRODUCT_CONTEXT.md`

If there is a conflict, these documents take precedence over AI output.

---

## How to Ask AI for Changes

When using AI tools:
- Reference the feature being modified
- Describe expected behavior, not implementation
- Request minimal diffs
- Ask for explanation only when necessary

Example:
> “Add a loading state to the existing AuthBloc without changing the public API.”

---

## When to Ask for Clarification

AI tools must ask for clarification when:
- Product intent is ambiguous
- Multiple valid implementations exist
- A change could impact legality or user money
- A new dependency or architectural change is implied

---

## Output Expectations

AI-generated code should:
- Match existing style and naming
- Reuse existing abstractions
- Avoid speculative improvements
- Be testable

If unsure, prefer doing less.

---

## Authority

This file defines how AI interacts with this codebase.
If unsure, stop and ask before generating code.

---
