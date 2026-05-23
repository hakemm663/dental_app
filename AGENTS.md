# AGENTS.md

<!--
This file loads into context on EVERY message in this project.
Apply the Golden Test before adding any rule:
"Would removing this cause Codex to make mistakes?" If not — cut it.
Do not restate language defaults Codex already knows. Only write rules
that override defaults or encode decisions specific to this project.
-->

---

# Section A — General Engineering Rules

## 1) Architecture & Separation of Concerns (YOU MUST FOLLOW)
- Follow the project's architecture layer boundaries strictly: presentation → domain → data
- Never bypass layers or mix responsibilities
- UI/presentation layer has ZERO business logic — only rendering, interaction, and state observation
- Business logic lives in the domain layer
- Data access (APIs, databases, storage) lives in the data layer
- Do not introduce new abstractions or patterns without justification

## 2) Shared Code (IMPORTANT)
- Any reusable logic, utility, constant, extension, or helper used in 2+ places goes in `core/`
- Check `core/` before creating new shared code — never duplicate across features

## 3) Error Handling
- Errors flow cleanly across layers — never skip layers
- Handle null, empty, loading, and error states explicitly — no silent failures
- Catch errors at the boundary (data layer), not deep inside business logic

## 4) Change Discipline
- Make the smallest change that solves the problem
- Fix root causes, not symptoms
- Don't refactor unrelated code unless explicitly requested
- Never break existing functionality, APIs, flows, or UX unless explicitly instructed
- Read relevant code before modifying it — state assumptions when unclear

## 5) Dependencies
- Don't add new packages without justification
- Any new package must be: latest stable, well-maintained, production-grade

## 6) Security
- Never hardcode secrets, tokens, or credentials
- Never log sensitive information
- Validate all external and API input
- Proactively flag security risks when spotted

## 7) Testing
- Write tests for domain and data layer logic
- Bug fixes must include a reproducing test
- Tests must be deterministic — no flaky or timing-dependent tests
- One behavior per test case

## 8) Workflow (Mandatory)
- Before marking any task done → run the `/code-review` skill
- After task approved → run the `/create-pr` skill for branch, commit, and PR output
- PR descriptions must always be in markdown (`.md`) format

---

# Section C — Security Roadmap Workflow (240-Day Program)

<!--
This section governs the "Lead Mobile Security Architect" roadmap.
Source: docs/roadmap/ROADMAP.md
Progress: docs/roadmap/ROADMAP_PROGRESS.md
-->

## 1) Session Start Protocol (MANDATORY — EVERY SESSION)
1. Read `docs/roadmap/ROADMAP_PROGRESS.md` to find `Current Day` and `Last Branch`
2. Read the matching day's section in `docs/roadmap/ROADMAP.md`
3. Check current git branch — if not on the correct branch, checkout or create it
4. Report to user: "Resuming Day X — [topic]. Branch: `security/dayXXX-slug`"

## 2) Branch Naming Convention
- Pattern: `security/dayXXX-short-slug`
- Examples: `security/day005-threat-modeling`, `security/day012-jwt-vs-sessions`
- Day number is ALWAYS 3 digits with leading zeros
- Slug: lowercase, hyphen-separated, max 4 words describing the day's topic
- Branch from `development` (the main working branch)

## 3) One Day = One Branch = One PR
- Each roadmap day gets exactly ONE branch and ONE PR
- Never combine multiple days into a single branch
- If a day has sub-topics, they all go in the same branch as separate commits

## 4) Commit Convention
- Format: `security(dayXXX): brief description`
- Examples:
  - `security(day005): add STRIDE threat model document`
  - `security(day008): implement SSL pinning with Dio`
  - `security(day012): add JWT secure storage with refresh rotation`
- Keep commits atomic — one logical change per commit

## 5) What Each Day Produces
Every day MUST produce at minimum:
- **Code**: implementation files under `lib/features/security/` or `lib/core/security/`
- **Docs**: a day summary in `docs/roadmap/days/dayXXX.md` with theory notes, key decisions, and references
- **Tests**: unit/integration tests for any domain or data layer code written

## 6) Feature Folder Structure for Security Work
```
lib/
  core/
    security/          ← shared security utilities (crypto, RASP, etc.)
  features/
    security/
      data/            ← security data sources, API clients
      domain/          ← security use cases, entities, failures
      presentation/    ← security-related UI (biometric prompts, etc.)
```

## 7) Progress Update (MANDATORY — END OF EVERY DAY)
After completing a day's work and before creating the PR:
1. Update `docs/roadmap/ROADMAP_PROGRESS.md`:
   - Set `Current Day` to the NEXT day number
   - Update `Last Branch` and `Last PR`
   - Update `Last Session Date`
   - Add a row to the Day Log table
   - Update Phase Summary if a phase boundary was crossed
2. Add any notes for the next session in the Session Notes section
3. Run `/code-review`
4. Run `/create-pr`

## 8) Session End Protocol
If ending a session mid-day (incomplete):
- Commit WIP with message: `security(dayXXX): WIP — [what's done so far]`
- Add a Session Note: "Day XXX incomplete — [what remains]"
- Update `Last Session Date` but do NOT advance `Current Day`

## 9) Quality Gate
- Every day's code must pass `flutter analyze` with zero issues
- Every day's tests must pass `flutter test`
- Security implementations must follow OWASP MASVS where applicable
- All crypto operations use hardware-backed storage (Keystore/Keychain) when available

---

# Section B — Flutter / Dart Specific Rules

<!--
Follow official Dart style guide, Effective Dart, and `flutter_lints` defaults.
Rules below only cover things that OVERRIDE defaults or encode project decisions.
-->

## 1) State Management
- Use **Cubit/Bloc** for feature and application state — not Riverpod, Provider, or GetX
- Cubits depend ONLY on use cases — never directly on repositories or data sources
- `setState` is allowed ONLY for local UI state (e.g., toggles, form focus) — never for business logic
- Keep `setState` scoped to the smallest widget possible to avoid redundant rebuilds up the tree

## 2) No Code Generation
- **No Freezed. No build_runner.** Use Dart 3+ native features instead:
  - `sealed class` for state unions with exhaustive pattern matching
  - `switch` expressions and records for lightweight data

## 3) Domain Layer Purity
- Domain layer must have ZERO Flutter imports
- No `package:flutter/...` in any file under `domain/`

## 4) Feature Folder Structure
- `features/{feature_name}/data/`
- `features/{feature_name}/domain/`
- `features/{feature_name}/presentation/`

## 5) Error Handling Contract
- Data layer: catch exceptions and map to typed `Failure` classes
- Domain layer: return `ApiResult<T>` from use cases and repositories
- Presentation layer: map failures to user-friendly messages and UI states

## 6) Dependency Injection
- Use **`get_it`** as the service locator — not `Provider` or constructor-only injection
- Register dependencies in a single `core/di/` setup file
- Cubits, use cases, and repositories are resolved via `get_it`, not instantiated manually

## 7) Build Method Discipline (IMPORTANT)
- Prefer `const` constructors wherever possible
- NEVER create `TextEditingController`, `AnimationController`, `FocusNode`, or other expensive objects inside `build()`
- Avoid heavy work inside `build()` methods
- Dispose controllers and focus nodes in `StatefulWidget.dispose()`
- Prefer small, composed widgets to minimize rebuild scope
- Use `BlocBuilder`/`BlocSelector` on the smallest widget that needs the state — never at the top of the tree
