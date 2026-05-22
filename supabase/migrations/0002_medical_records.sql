-- DocDoc — medical records table.
--
-- A patient's uploaded medical documents (x-rays, prescriptions, reports).
-- Owner-scoped: each row belongs to one auth user.
--
-- Apply: paste into Supabase Dashboard → SQL Editor → Run (after 0001).

create table if not exists medical_records (
  id           bigint generated always as identity primary key,
  user_id      uuid not null references auth.users (id) on delete cascade,
  name         text not null,
  type         text,           -- e.g. 'x-ray', 'prescription', 'report'
  record_date  date,
  file_url     text,           -- Supabase Storage URL of the document
  notes        text,
  created_at   timestamptz not null default now()
);
create index if not exists idx_medical_records_user on medical_records (user_id);

alter table medical_records enable row level security;

drop policy if exists medical_records_owner_crud on medical_records;
create policy medical_records_owner_crud on medical_records
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
