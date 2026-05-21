-- DocDoc — initial schema for the Supabase backend.
-- Dental marketplace for Egypt: doctors, clinics, catalog, appointments, reviews.
--
-- Apply: paste this whole file into Supabase Dashboard → SQL Editor → Run.
-- Idempotent-ish: safe to re-run on a fresh project; drops are not included.

-- ── Extensions ──────────────────────────────────────────────────────────────
create extension if not exists pg_trgm;       -- fuzzy doctor-name search
create extension if not exists moddatetime;   -- auto updated_at

-- ── Enums ───────────────────────────────────────────────────────────────────
do $$ begin
  create type appointment_status as enum
    ('pending', 'confirmed', 'completed', 'cancelled');
exception when duplicate_object then null; end $$;

-- ── Geography ───────────────────────────────────────────────────────────────
create table if not exists governorates (
  id          bigint generated always as identity primary key,
  name        text not null unique,
  created_at  timestamptz not null default now()
);

create table if not exists cities (
  id              bigint generated always as identity primary key,
  governorate_id  bigint not null references governorates (id) on delete cascade,
  name            text not null,
  latitude        double precision,
  longitude       double precision,
  created_at      timestamptz not null default now()
);
create index if not exists idx_cities_governorate on cities (governorate_id);

-- ── Catalog ─────────────────────────────────────────────────────────────────
create table if not exists specializations (
  id           bigint generated always as identity primary key,
  name         text not null unique,
  slug         text not null unique,
  description  text,
  created_at   timestamptz not null default now()
);

create table if not exists categories (
  id          bigint generated always as identity primary key,
  name        text not null unique,
  slug        text not null unique,
  created_at  timestamptz not null default now()
);

create table if not exists services (
  id                 bigint generated always as identity primary key,
  specialization_id  bigint references specializations (id) on delete set null,
  category_id        bigint references categories (id) on delete set null,
  name               text not null,
  description        text,
  base_price         numeric(10, 2) not null default 0,
  created_at         timestamptz not null default now()
);
create index if not exists idx_services_specialization on services (specialization_id);

-- ── Clinics ─────────────────────────────────────────────────────────────────
create table if not exists clinics (
  id              bigint generated always as identity primary key,
  name            text not null,
  governorate_id  bigint references governorates (id) on delete set null,
  city_id         bigint references cities (id) on delete set null,
  address         text,
  phone           text,
  latitude        double precision,
  longitude       double precision,
  created_at      timestamptz not null default now()
);
create index if not exists idx_clinics_city on clinics (city_id);

create table if not exists clinic_hours (
  id           bigint generated always as identity primary key,
  clinic_id    bigint not null references clinics (id) on delete cascade,
  day_of_week  smallint not null check (day_of_week between 0 and 6),
  open_time    time not null,
  close_time   time not null
);
create index if not exists idx_clinic_hours_clinic on clinic_hours (clinic_id);

-- ── Doctors ─────────────────────────────────────────────────────────────────
create table if not exists doctors (
  id                 bigint generated always as identity primary key,
  name               text not null,
  slug               text not null unique,
  photo_url          text,
  gender             text check (gender in ('male', 'female')),
  title              text,                      -- degree / professional title
  specialization_id  bigint references specializations (id) on delete set null,
  clinic_id          bigint references clinics (id) on delete set null,
  city_id            bigint references cities (id) on delete set null,
  bio                text,
  years_experience   int not null default 0,
  consultation_fee   numeric(10, 2) not null default 0,
  rating             numeric(2, 1) not null default 0,
  reviews_count      int not null default 0,
  is_approved        boolean not null default true,
  start_time         text,
  end_time           text,
  latitude           double precision,
  longitude          double precision,
  created_at         timestamptz not null default now()
);
create index if not exists idx_doctors_specialization on doctors (specialization_id);
create index if not exists idx_doctors_city on doctors (city_id);
create index if not exists idx_doctors_clinic on doctors (clinic_id);
create index if not exists idx_doctors_rating on doctors (rating desc);
create index if not exists idx_doctors_name_trgm on doctors using gin (name gin_trgm_ops);

-- ── Profiles (1:1 with auth.users) ──────────────────────────────────────────
create table if not exists profiles (
  id             uuid primary key references auth.users (id) on delete cascade,
  full_name      text,
  phone          text,
  gender         text check (gender in ('male', 'female')),
  avatar_url     text,
  date_of_birth  date,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

-- Auto-create a profile row whenever a new auth user signs up.
create or replace function handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, phone)
  values (
    new.id,
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'phone'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();

-- ── Reviews ─────────────────────────────────────────────────────────────────
create table if not exists doctor_reviews (
  id              bigint generated always as identity primary key,
  doctor_id       bigint not null references doctors (id) on delete cascade,
  reviewer_id     uuid references auth.users (id) on delete set null,
  reviewer_name   text not null,
  reviewer_image  text,
  rating          smallint not null check (rating between 1 and 5),
  body            text not null,
  created_at      timestamptz not null default now()
);
create index if not exists idx_reviews_doctor on doctor_reviews (doctor_id);

-- Keep doctors.rating / reviews_count in sync with doctor_reviews.
create or replace function refresh_doctor_rating()
returns trigger
language plpgsql
as $$
declare
  target_doctor bigint := coalesce(new.doctor_id, old.doctor_id);
begin
  update doctors d
  set reviews_count = sub.cnt,
      rating        = sub.avg
  from (
    select count(*)::int as cnt,
           coalesce(round(avg(rating)::numeric, 1), 0) as avg
    from doctor_reviews
    where doctor_id = target_doctor
  ) sub
  where d.id = target_doctor;
  return null;
end;
$$;

drop trigger if exists trg_refresh_doctor_rating on doctor_reviews;
create trigger trg_refresh_doctor_rating
  after insert or update or delete on doctor_reviews
  for each row execute function refresh_doctor_rating();

-- ── Favorites ───────────────────────────────────────────────────────────────
create table if not exists favorites (
  id          bigint generated always as identity primary key,
  user_id     uuid not null references auth.users (id) on delete cascade,
  doctor_id   bigint not null references doctors (id) on delete cascade,
  created_at  timestamptz not null default now(),
  unique (user_id, doctor_id)
);
create index if not exists idx_favorites_user on favorites (user_id);

-- ── Addresses ───────────────────────────────────────────────────────────────
create table if not exists addresses (
  id              bigint generated always as identity primary key,
  user_id         uuid not null references auth.users (id) on delete cascade,
  label           text,
  governorate_id  bigint references governorates (id) on delete set null,
  city_id         bigint references cities (id) on delete set null,
  street          text,
  latitude        double precision,
  longitude       double precision,
  created_at      timestamptz not null default now()
);
create index if not exists idx_addresses_user on addresses (user_id);

-- ── Appointments ────────────────────────────────────────────────────────────
create table if not exists appointments (
  id                bigint generated always as identity primary key,
  user_id           uuid not null references auth.users (id) on delete cascade,
  doctor_id         bigint not null references doctors (id) on delete cascade,
  clinic_id         bigint references clinics (id) on delete set null,
  start_time        timestamptz not null,
  status            appointment_status not null default 'pending',
  appointment_type  text not null default 'in_person'
                      check (appointment_type in ('in_person', 'video')),
  notes             text,
  price             numeric(10, 2),
  payment_method    text,
  payment_status    text not null default 'unpaid'
                      check (payment_status in ('unpaid', 'paid', 'refunded')),
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);
create index if not exists idx_appointments_user on appointments (user_id);
create index if not exists idx_appointments_doctor on appointments (doctor_id);
create index if not exists idx_appointments_status on appointments (status);

-- updated_at maintenance
create trigger trg_profiles_updated
  before update on profiles
  for each row execute function moddatetime (updated_at);
create trigger trg_appointments_updated
  before update on appointments
  for each row execute function moddatetime (updated_at);

-- ── Nearby-doctors RPC (haversine, no PostGIS dependency) ────────────────────
create or replace function nearby_doctors(
  origin_lat double precision,
  origin_lng double precision,
  radius_km  double precision default 10
)
returns table (
  id               bigint,
  name             text,
  photo_url        text,
  specialization   text,
  rating           numeric,
  consultation_fee numeric,
  latitude         double precision,
  longitude        double precision,
  distance_km      double precision
)
language sql
stable
as $$
  select d.id,
         d.name,
         d.photo_url,
         s.name as specialization,
         d.rating,
         d.consultation_fee,
         d.latitude,
         d.longitude,
         6371 * 2 * asin(sqrt(
           power(sin(radians(d.latitude - origin_lat) / 2), 2) +
           cos(radians(origin_lat)) * cos(radians(d.latitude)) *
           power(sin(radians(d.longitude - origin_lng) / 2), 2)
         )) as distance_km
  from doctors d
  left join specializations s on s.id = d.specialization_id
  where d.latitude is not null
    and d.longitude is not null
    and 6371 * 2 * asin(sqrt(
          power(sin(radians(d.latitude - origin_lat) / 2), 2) +
          cos(radians(origin_lat)) * cos(radians(d.latitude)) *
          power(sin(radians(d.longitude - origin_lng) / 2), 2)
        )) <= radius_km
  order by distance_km asc;
$$;

-- ── Row-Level Security ──────────────────────────────────────────────────────
alter table governorates    enable row level security;
alter table cities          enable row level security;
alter table specializations enable row level security;
alter table categories      enable row level security;
alter table services        enable row level security;
alter table clinics         enable row level security;
alter table clinic_hours    enable row level security;
alter table doctors         enable row level security;
alter table doctor_reviews  enable row level security;
alter table profiles        enable row level security;
alter table favorites       enable row level security;
alter table addresses       enable row level security;
alter table appointments    enable row level security;

-- Public, read-only catalog data — readable by anon and authenticated.
-- drop-then-create keeps the whole file safe to re-run.
do $$
declare t text;
begin
  foreach t in array array[
    'governorates','cities','specializations','categories','services',
    'clinics','clinic_hours','doctors'
  ] loop
    execute format('drop policy if exists %I on %I', t || '_public_read', t);
    execute format(
      'create policy %I on %I for select to anon, authenticated using (true)',
      t || '_public_read', t);
  end loop;
end $$;

-- Reviews: anyone can read; an authenticated user may write/delete their own.
drop policy if exists reviews_public_read on doctor_reviews;
create policy reviews_public_read on doctor_reviews
  for select to anon, authenticated using (true);
drop policy if exists reviews_insert_own on doctor_reviews;
create policy reviews_insert_own on doctor_reviews
  for insert to authenticated with check (auth.uid() = reviewer_id);
drop policy if exists reviews_delete_own on doctor_reviews;
create policy reviews_delete_own on doctor_reviews
  for delete to authenticated using (auth.uid() = reviewer_id);

-- Profiles: a user sees and edits only their own.
drop policy if exists profiles_select_own on profiles;
create policy profiles_select_own on profiles
  for select to authenticated using (auth.uid() = id);
drop policy if exists profiles_update_own on profiles;
create policy profiles_update_own on profiles
  for update to authenticated using (auth.uid() = id);
drop policy if exists profiles_insert_own on profiles;
create policy profiles_insert_own on profiles
  for insert to authenticated with check (auth.uid() = id);

-- Favorites / addresses / appointments: full CRUD scoped to the owner.
do $$
declare t text;
begin
  foreach t in array array['favorites','addresses','appointments'] loop
    execute format('drop policy if exists %I on %I', t || '_owner_crud', t);
    execute format(
      'create policy %I on %I for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id)',
      t || '_owner_crud', t);
  end loop;
end $$;
