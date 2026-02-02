# Product Context — Betchya

This document defines the product intent and constraints for the Betchya mobile application.  
It exists to ensure consistency for both human and AI contributors.

---

## What Betchya Is

Betchya is a **mobile sportsbook and hospitality application designed for tribal casinos**.

It enables a single casino-branded app to support:
- Sports betting (where legally permitted)
- Token-based play (where real-money betting is restricted)
- Hotel, event, and restaurant information
- Promotions and marketing experiences

Betchya operates **behind the scenes**.  
The casino’s brand, customer relationship, and business take priority.

---

## What Betchya Is NOT

Betchya is **not**:
- A statewide or national sportsbook
- A consumer-facing betting brand (e.g. DraftKings, FanDuel)
- A replacement for a casino’s backend systems
- A platform for speculative or unregulated gambling features

The app must **not assume**:
- Betting is legal everywhere
- Real-money wagering is always enabled
- One set of rules applies across all casinos or states

---

## Core Constraints

### Legal & Regulatory
- Sports betting legality varies by state and by tribe.
- Some casinos may allow only token-based play.
- Real-money betting must be restricted to **on-premises usage**.
- Geo-fencing is required for any real-money wagering.

### Product
- Each casino may define its own token exchange rates.
- The app must support multiple casino configurations.
- Features must degrade gracefully when betting is unavailable.

---

## Version 1 Scope (Must-Have)

Version 1 focuses on establishing a reliable foundation.

- Mobile sportsbook experience
- Token-based betting support
- Geo-fencing for on-premises wagering
- Integration with third-party sportsbook data APIs
- Casino-controlled content:
  - Events
  - Restaurants
  - Promotions

---

## Future Scope (Out of Scope for V1)

These features are intentionally excluded from Version 1:

- Casino rewards system integrations
- Mobile hotel check-in or purchasing
- Push notifications
- Advanced off-premises free-play systems
- Deep personalization or dynamic content engines

Do not implement future-scope features without explicit direction.

---

## Product Philosophy

- The app must prioritize **clarity, safety, and correctness** over novelty.
- Simple, explicit behavior is preferred over clever abstractions.
- When legality or behavior is ambiguous, default to **restrictive** behavior.

---

## Guidance for AI-Assisted Contributions

When generating or modifying code:
- Do not invent product features.
- Do not assume legality or availability.
- Ask for clarification if product intent is unclear.
- Respect version scope boundaries.

This file is the source of truth for product intent.

---
