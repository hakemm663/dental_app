name: DocDoc App-from-Figma-Postman
description: "Generates a production-ready Flutter feature/app scaffolding by following a Figma design and wiring APIs from a Postman collection, matching the app’s existing architecture (Riverpod/Bloc), DI, and error-handling patterns."
## What this skill does

When you ask for it, this skill will produce an end-to-end implementation plan and generated code structure for the DocDoc app (or a scoped part of it), using:

- Your **Figma design** as the source of truth for screens, UI states, flows, and copy/labels.
- Your **Postman workspace/collection** as the source of truth for API endpoints, request/response shapes, and authentication.

It is designed to help you move from design + API specs to a **“full app ready to build/run”** scaffold (as much as possible within the provided scope), including:
- UI screens + widgets
- Navigation/routes
- State management (Riverpod or Bloc matching the existing project standard)
- API client + models + repositories
- Dependency injection wiring
- Error handling + loading states

## Trigger / Invocation

Use the skill when you need to:
- “build the DocDoc app from the Figma design and Postman APIs”
- or “generate a running scaffold following Figma + Postman”

Recommended prompt template:
- “Use DocDoc App-from-Figma-Postman. Figma URL: … Postman URL: … Build a complete scaffold.”

## Required inputs

Provide:
- `figma_url`: (string) Link to the Figma design
- `postman_url`: (string) Link to the Postman collection/workspace (shared link is fine)

Optional:
- `scope`:
  - `full_app` (default)
  - `feature:<name>` (e.g., “feature:auth”)
  - `screens:<comma-separated-screen-names>` (if you only want specific screens)
- `state_management`:
  - `auto` (default) → match the existing repo standard
  - `riverpod` or `bloc`
- `run_target`:
  - `app_compiles` (default) → generate code that compiles and integrates with existing project structure
  - `full_integration` → attempt deeper integration if endpoints/models already exist
- `auth_notes`:
  - any special requirements (token header name, refresh flow, etc.). If unknown, the skill will infer from Postman.

## Internal “logic reference” behavior

This skill must:
1. Inspect the current Flutter project structure you’re working with (routes, DI, state management, API layer patterns).
2. Match existing conventions:
   - feature-first folder structure
   - dependency direction (UI → Domain → Data)
   - Riverpod/Bloc state shape patterns
   - models/repositories/API client style
3. Reuse existing primitives (e.g., shared widgets, error types, network helpers, DI container registrations) instead of duplicating them.

## Step-by-step instructions (what the assistant should do)

### Phase 1 — Analyze Figma
1. Open `figma_url` and identify:
   - all screens in scope
   - primary user flows and navigation graph
   - UI states per screen (loading/empty/error where applicable)
   - text labels, formatting rules, and key components
2. Create a “screen map”:
   - screen name → route name → UI widgets hierarchy
   - per-screen inputs/outputs (what data is displayed/edited)

### Phase 2 — Analyze Postman
1. Open `postman_url` and enumerate endpoints needed by the scoped screens.
2. Identify:
   - base URL
   - auth method (header/cookie/token)
   - request parameters and bodies
   - response JSON shapes
   - status codes and error formats
3. Produce:
   - models/entities with `fromJson/toJson` (or existing project mapping style)
   - API client methods (Dio/http) with timeouts and typed errors
   - repositories wrapping API client methods

### Phase 3 — Architecture wiring (match your repo)
1. Implement state management for each screen/feature:
   - loading → success → error
   - pagination or polling only if present in Postman/Figma
2. Wire navigation:
   - add routes
   - connect route parameters to feature state
3. Wire DI:
   - register API client, repositories, and use-cases (if used in your architecture)

### Phase 4 — Build readiness checklist
Ensure the output is “ready to build/run” within scope:
- no missing imports / unresolved symbols
- compile-time correctness (TypeScript equivalent not relevant; use Dart/Flutter checks)
- basic API integration paths exist (methods call correct endpoints)
- user-triggered actions are connected to state changes
- errors produce user-friendly messages

## Output format

The assistant should return:
1. A short “Plan”:
   - screens/routes list
   - endpoints list
   - files/modules to create or modify
2. Implementation steps in order (UI first or API first depending on dependencies in your repo)
3. Generated code changes grouped by folder:
   - `features/.../presentation`
   - `features/.../domain`
   - `features/.../data`
4. A “Verification checklist”:
   - compile/run instructions
   - where to test key flows
   - what env vars/config might be needed

## Guardrails
- Do not invent endpoints not present in Postman.
- Do not invent UI components not implied by Figma for the chosen scope.
- If auth/token format is ambiguous, request clarification or add a clearly marked TODO in configuration.
- Match existing project conventions rather than forcing a new architecture.
