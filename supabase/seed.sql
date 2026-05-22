-- DocDoc — synthetic seed data (English).
--
-- 100% FICTIONAL: no real doctor, clinic, phone or review. Realistic Egyptian
-- dental-market shape. Doctor/reviewer avatars use DiceBear "notionists"
-- (CC0 1.0 / public domain) — App Store + Google Play safe, no attribution.
--
-- Doctors and reviews are generated procedurally with generate_series so the
-- file stays small; setseed() makes the output deterministic across runs.
--
-- Apply AFTER 0001_init_schema.sql: paste into Supabase SQL Editor → Run.

begin;

-- Re-runnable: clear any existing seed rows first. CASCADE also clears
-- appointments / favorites / addresses (empty at first seed; re-running
-- after real users exist would discard their bookings — re-seed with care).
truncate governorates, cities, specializations, categories, services,
         clinics, clinic_hours, doctors, doctor_reviews
  restart identity cascade;

select setseed(0.42);

-- ── Governorates ────────────────────────────────────────────────────────────
insert into governorates (name) values
  ('Cairo'), ('Giza'), ('Alexandria'), ('Dakahlia'), ('Gharbia');

-- ── Cities (real centre coordinates — public geographic facts) ──────────────
insert into cities (governorate_id, name, latitude, longitude)
select g.id, c.name, c.lat, c.lng
from (values
  ('Cairo',      'Nasr City',           30.0566, 31.3300),
  ('Cairo',      'Maadi',               29.9602, 31.2569),
  ('Cairo',      'Heliopolis',          30.0911, 31.3425),
  ('Cairo',      'New Cairo',           30.0300, 31.4700),
  ('Cairo',      'Zamalek',             30.0614, 31.2197),
  ('Cairo',      'Downtown Cairo',      30.0444, 31.2357),
  ('Giza',       'Mohandessin',         30.0588, 31.2002),
  ('Giza',       'Dokki',               30.0383, 31.2119),
  ('Giza',       '6th of October',      29.9285, 30.9188),
  ('Giza',       'Sheikh Zayed',        30.0444, 30.9760),
  ('Giza',       'Haram',               29.9870, 31.1500),
  ('Alexandria', 'Smouha',              31.2150, 29.9480),
  ('Alexandria', 'Sidi Gaber',          31.2200, 29.9430),
  ('Alexandria', 'Roushdy',             31.2330, 29.9560),
  ('Alexandria', 'Miami',               31.2700, 30.0100),
  ('Dakahlia',   'Mansoura',            31.0409, 31.3785),
  ('Dakahlia',   'Talkha',              31.0540, 31.3760),
  ('Gharbia',    'Tanta',               30.7865, 31.0004),
  ('Gharbia',    'El Mahalla El Kubra', 30.9706, 31.1669)
) as c(gov, name, lat, lng)
join governorates g on g.name = c.gov;

-- ── Specializations ─────────────────────────────────────────────────────────
insert into specializations (name, slug, description) values
  ('General Dentistry', 'general-dentistry',
   'Routine checkups, fillings, cleaning and preventive dental care.'),
  ('Orthodontics', 'orthodontics',
   'Braces, clear aligners and correction of teeth alignment.'),
  ('Endodontics', 'endodontics',
   'Root canal treatment and management of dental pulp.'),
  ('Pediatric Dentistry', 'pediatric-dentistry',
   'Dental care tailored for infants, children and teenagers.'),
  ('Oral & Maxillofacial Surgery', 'oral-maxillofacial-surgery',
   'Surgical extraction, implants and jaw procedures.'),
  ('Periodontics', 'periodontics',
   'Treatment of gum disease and supporting structures.'),
  ('Prosthodontics', 'prosthodontics',
   'Crowns, bridges, dentures and full-mouth rehabilitation.'),
  ('Cosmetic Dentistry', 'cosmetic-dentistry',
   'Veneers, whitening and smile-design treatments.');

-- ── Service categories ──────────────────────────────────────────────────────
insert into categories (name, slug) values
  ('Preventive Care', 'preventive-care'),
  ('Restorative',     'restorative'),
  ('Surgical',        'surgical'),
  ('Cosmetic',        'cosmetic'),
  ('Orthodontic',     'orthodontic'),
  ('Pediatric',       'pediatric');

-- ── Services (prices in EGP) ────────────────────────────────────────────────
insert into services (specialization_id, category_id, name, description, base_price)
select sp.id, cat.id, s.name, s.descr, s.price
from (values
  ('general-dentistry',          'preventive-care', 'Routine Checkup',        'Comprehensive dental examination and consultation.',   200),
  ('general-dentistry',          'preventive-care', 'Scaling & Polishing',    'Professional cleaning to remove plaque and tartar.',   350),
  ('orthodontics',               'orthodontic',     'Metal Braces',           'Fixed metal braces for teeth alignment.',            12000),
  ('orthodontics',               'orthodontic',     'Clear Aligners',         'Removable transparent aligners.',                    28000),
  ('endodontics',                'restorative',     'Root Canal Treatment',   'Treatment of infected tooth pulp.',                   1800),
  ('endodontics',                'restorative',     'Pulp Capping',           'Protective dressing over exposed pulp.',               600),
  ('pediatric-dentistry',        'pediatric',       'Child Dental Checkup',   'Gentle examination for children.',                     250),
  ('pediatric-dentistry',        'pediatric',       'Fluoride Treatment',     'Fluoride application to strengthen enamel.',            300),
  ('oral-maxillofacial-surgery', 'surgical',        'Tooth Extraction',       'Surgical removal of a damaged tooth.',                 500),
  ('oral-maxillofacial-surgery', 'surgical',        'Dental Implant',         'Titanium implant to replace a missing tooth.',        9000),
  ('periodontics',               'restorative',     'Gum Treatment',          'Treatment of gum inflammation and disease.',          1200),
  ('periodontics',               'preventive-care', 'Deep Cleaning',          'Scaling and root planing below the gum line.',         900),
  ('prosthodontics',             'restorative',     'Dental Crown',           'Custom cap to restore a damaged tooth.',              3500),
  ('prosthodontics',             'restorative',     'Dentures',               'Removable replacement for missing teeth.',            6000),
  ('cosmetic-dentistry',         'cosmetic',        'Teeth Whitening',        'Professional whitening for a brighter smile.',        2500),
  ('cosmetic-dentistry',         'cosmetic',        'Veneers',                'Thin custom shells bonded to the tooth surface.',     4000)
) as s(spec_slug, cat_slug, name, descr, price)
join specializations sp on sp.slug = s.spec_slug
join categories cat on cat.slug = s.cat_slug;

-- ── Clinics (one per city) ──────────────────────────────────────────────────
insert into clinics (name, governorate_id, city_id, address, phone, latitude, longitude)
select ct.name || ' Dental Center',
       ct.governorate_id,
       ct.id,
       'Medical Tower, ' || ct.name,
       '+20 2 ' || (20000000 + floor(random() * 79999999)::int)::text,
       ct.latitude,
       ct.longitude
from cities ct;

-- ── Clinic hours (Saturday–Thursday, closed Friday) ─────────────────────────
insert into clinic_hours (clinic_id, day_of_week, open_time, close_time)
select c.id, d, time '12:00', time '22:00'
from clinics c
cross join unnest(array[0, 1, 2, 3, 4, 6]) as d;

-- ── Doctors (50, procedurally generated) ────────────────────────────────────
with base as (
  select g.i,
    (random() < 0.5) as is_male,
    (array['Ahmed','Mohamed','Mahmoud','Khaled','Omar','Youssef','Karim',
           'Tarek','Hossam','Amr','Sherif','Hisham','Wael','Ayman','Mostafa',
           'Ramy','Bassem','Hany','Tamer','Sameh'])[1 + floor(random()*20)::int]
      as fn_m,
    (array['Mona','Yasmin','Heba','Dina','Rana','Salma','Aya','Nada','Rania',
           'Mariam','Sara','Engy','Doaa','Hala','Amira','Ghada','Marwa','Reem',
           'Mai','Nour'])[1 + floor(random()*20)::int]
      as fn_f,
    (array['Hassan','Ibrahim','Mahmoud','Abdelrahman','Saleh','Fahmy',
           'Mansour','ElSayed','Naguib','Farouk','Zaki','Sabry','Kamal',
           'Shawky','ElGamal','Halim','Ezzat','Rashad','ElMasry','AbdelAziz'])
      [1 + floor(random()*20)::int]
      as ln,
    (array['BDS — Cairo University',
           'BDS, MSc — Ain Shams University',
           'BDS, MSc, PhD — Alexandria University',
           'Member, Egyptian Dental Association',
           'Lecturer, Faculty of Dentistry',
           'Consultant Dental Surgeon'])[1 + floor(random()*6)::int]
      as title,
    1 + floor(random() * 8)::int  as spec_id,
    1 + floor(random() * 19)::int as city_id,
    4 + floor(random() * 22)::int as yrs,
    150 + floor(random() * 10)::int * 50 as fee,
    11 + floor(random() * 3)::int as start_h,
    20 + floor(random() * 4)::int as end_h
  from generate_series(1, 50) as g(i)
),
named as (
  select b.*,
    (case when b.is_male then b.fn_m else b.fn_f end)
            || ' ' || b.ln as full_name,
    (case when b.is_male then 'male' else 'female' end) as gender
  from base b
)
insert into doctors
  (name, slug, photo_url, gender, title, specialization_id, clinic_id, city_id,
   bio, years_experience, consultation_fee, is_approved,
   start_time, end_time, latitude, longitude)
select
  n.full_name,
  'dr-' || n.i,
  'https://api.dicebear.com/9.x/notionists/png?seed=doctor-' || n.i
    || '&backgroundColor=b6e3f4,c0aede,d1d4f9,ffd5dc,ffdfbf&radius=50',
  n.gender,
  n.title,
  n.spec_id,
  (select cl.id from clinics cl where cl.city_id = n.city_id limit 1),
  n.city_id,
  n.full_name || ' is a ' || sp.name || ' specialist based in ' || ct.name
    || ' with ' || n.yrs
    || ' years of clinical experience, focused on quality patient care.',
  n.yrs,
  n.fee,
  true,
  n.start_h::text || ':00',
  n.end_h::text || ':00',
  ct.latitude  + (random() - 0.5) * 0.04,
  ct.longitude + (random() - 0.5) * 0.04
from named n
join specializations sp on sp.id = n.spec_id
join cities ct on ct.id = n.city_id;

-- ── Reviews (5–14 per doctor; rating/count auto-maintained by trigger) ──────
insert into doctor_reviews
  (doctor_id, reviewer_name, reviewer_image, rating, body, created_at)
select
  d.id,
  (array['Ahmed','Mohamed','Mona','Yasmin','Khaled','Heba','Omar','Dina',
         'Youssef','Salma','Karim','Aya','Tarek','Nada','Amr','Mariam',
         'Sherif','Sara','Hany','Reem'])[1 + floor(random()*20)::int]
    || ' '
    || (array['Hassan','Ibrahim','Mahmoud','Saleh','Fahmy','Mansour',
              'ElSayed','Farouk','Zaki','Sabry','Kamal','Shawky','ElGamal',
              'Halim','Ezzat','Rashad','ElMasry','AbdelAziz','Naguib',
              'Abdelrahman'])[1 + floor(random()*20)::int]
    as reviewer_name,
  'https://api.dicebear.com/9.x/notionists/png?seed=reviewer-'
    || d.id || '-' || r.j || '&radius=50' as reviewer_image,
  (array[3, 4, 4, 4, 5, 5, 5, 5])[1 + floor(random()*8)::int] as rating,
  (array[
    'Very professional and gentle. Explained every step clearly.',
    'Great experience — the clinic was clean and the staff were friendly.',
    'Booking was easy and the doctor was right on time.',
    'Highly recommend. My treatment was painless and well done.',
    'Caring and patient, especially with nervous patients.',
    'Good value for the price. Will definitely come back.',
    'The doctor took time to answer all my questions.',
    'Modern equipment and a very comfortable visit.',
    'Friendly team and a smooth appointment from start to finish.',
    'Excellent follow-up after the procedure.'
  ])[1 + floor(random()*10)::int] as body,
  now() - (floor(random() * 540)::int || ' days')::interval as created_at
from doctors d
cross join lateral generate_series(1, 5 + floor(random() * 10)::int) as r(j);

commit;

-- ── Verify ──────────────────────────────────────────────────────────────────
select
  (select count(*) from governorates)   as governorates,
  (select count(*) from cities)         as cities,
  (select count(*) from specializations) as specializations,
  (select count(*) from services)       as services,
  (select count(*) from clinics)        as clinics,
  (select count(*) from doctors)        as doctors,
  (select count(*) from doctor_reviews) as reviews;
