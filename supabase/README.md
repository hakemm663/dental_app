# DocDoc — Supabase backend

The production data backend for DocDoc: doctors, clinics, catalog, appointments,
reviews and user data. Postgres + PostgREST (auto REST API) + Supabase Auth +
Storage.

Project ref: `xtlynstfzipnfbczsohz`

## Files

| File | Purpose |
|---|---|
| `migrations/0001_init_schema.sql` | Tables, enums, RLS policies, indexes, triggers, the `nearby_doctors` RPC. Safe to re-run. |
| `seed.sql` | Synthetic English seed data — 5 governorates, 19 cities, 8 specializations, 16 services, 19 clinics, 50 doctors, ~475 reviews. Procedurally generated (`generate_series` + `setseed`), deterministic, re-runnable (truncates first). |

## Apply (Supabase SQL Editor)

1. Supabase Dashboard → your project → **SQL Editor** → **+ New query**
2. Paste **all of** `migrations/0001_init_schema.sql` → **Run**
3. New query → paste **all of** `seed.sql` → **Run**
4. The last statement of `seed.sql` prints a row count — expect:
   `governorates 5 · cities 19 · specializations 8 · services 16 · clinics 19 · doctors 50 · reviews ~475`

Re-running is safe: the schema uses `if not exists` / `drop … if exists`; the seed
`truncate … restart identity cascade`s before inserting.

## Data is synthetic

Every doctor, clinic, phone number and review is **fictional**. No real person or
business is used — this keeps the dataset clear of privacy law (Egypt PDPL
151/2020, GDPR) and of App Store / Google Play third-party-data rules.

Avatars use [DiceBear](https://www.dicebear.com) `notionists` style, released
under **CC0 1.0** (public domain) — commercial-store-safe, no attribution.

## Connecting the app

The Flutter app reads this backend with the `supabase_flutter` SDK
(Phase 2b — `feat/backend/supabase-data-layer`):

```dart
await Supabase.initialize(
  url: 'https://xtlynstfzipnfbczsohz.supabase.co',
  anonKey: '<publishable key>', // from .dev-secrets/supabase-credentials.md
);
```

Row-Level Security is on for every table: catalog data (doctors, clinics,
specializations…) is world-readable; `profiles`, `favorites`, `addresses` and
`appointments` are readable/writable only by their owner.
