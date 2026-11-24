-- Food bank volunteer scheduler: schema and seed data (PostgreSQL 18)
-- Safe to rerun: drops and recreates every table. Never run it against a shared database.
drop table if exists bookings, slots, shifts, tasks, qualifications, volunteers,
    qualification_types, warehouses cascade;
set timezone = 'Europe/London';

create table warehouses (
    id   bigint generated always as identity primary key,
    name text not null unique,
    city text not null
);

create table qualification_types (
    id           bigint generated always as identity primary key,
    name         text not null unique,
    valid_months int  not null check (valid_months > 0)
);

create table volunteers (
    id                     bigint generated always as identity primary key,
    full_name              text not null,
    email                  text not null unique,
    phone                  text,
    joined_on              date not null,
    preferred_warehouse_id bigint references warehouses (id)
);

create table qualifications (
    volunteer_id          bigint not null references volunteers (id),
    qualification_type_id bigint not null references qualification_types (id),
    obtained_on           date   not null,
    expires_on            date   not null,
    primary key (volunteer_id, qualification_type_id)
);

create table tasks (
    id                             bigint generated always as identity primary key,
    name                           text not null unique,
    required_qualification_type_id bigint references qualification_types (id)
);

create table shifts (
    id           bigint generated always as identity primary key,
    warehouse_id bigint      not null references warehouses (id),
    starts_at    timestamptz not null,
    ends_at      timestamptz not null,
    check (ends_at > starts_at)
);

create table slots (
    id       bigint generated always as identity primary key,
    shift_id bigint not null references shifts (id),
    task_id  bigint not null references tasks (id),
    capacity int    not null check (capacity > 0)
);

create table bookings (
    id           bigint generated always as identity primary key,
    slot_id      bigint      not null references slots (id),
    volunteer_id bigint      not null references volunteers (id),
    status       text        not null check (status in ('booked', 'cancelled', 'attended', 'no_show')),
    booked_at    timestamptz not null,
    unique (slot_id, volunteer_id)
);

insert into warehouses (name, city) values
    ('North', 'Belfast'), ('Central', 'Lisburn'), ('Riverside', 'Newry');

insert into qualification_types (name, valid_months) values
    ('Food hygiene level 2', 36), ('Forklift', 24);

insert into tasks (name, required_qualification_type_id) values
    ('Sorting', null), ('Packing', null), ('Reception', null),
    ('Cold store', 1), ('Loading bay', 2);

insert into volunteers (full_name, email, phone, joined_on, preferred_warehouse_id) values
    ('Ana Silva',      'ana@example.org',     '07700900001', '2023-02-11', 1),
    ('Ben Carter',     'ben@example.org',     null,          '2024-09-02', 1),
    ('Chloe Murphy',   'chloe@example.org',   '07700900003', '2022-05-19', 2),
    ('Dev Patel',      'dev@example.org',     '07700900004', '2025-01-08', 3),
    ('Erin Walsh',     'erin@example.org',    '07700900005', '2021-11-30', 1),
    ('Femi Adeyemi',   'femi@example.org',    null,          '2025-06-14', null),
    ('Grace Kelly',    'grace@example.org',   '07700900007', '2024-03-03', 2),
    ('Hugo Brown',     'hugo@example.org',    '07700900008', '2023-08-21', 3),
    ('Isla Byrne',     'isla@example.org',    '07700900009', '2026-01-17', 1),
    ('Jack Doherty',   'jack@example.org',    null,          '2022-10-05', 2),
    ('Kara Nolan',     'kara@example.org',    '07700900011', '2025-09-09', null),
    ('Liam Quinn',     'liam@example.org',    '07700900012', '2024-12-12', 3),
    ('Maya Chen',      'maya@example.org',    '07700900013', '2023-04-27', 1),
    ('Niall Fox',      'niall@example.org',   '07700900014', '2026-03-01', 2),
    ('Orla Kennedy',   'orla@example.org',    null,          '2021-07-15', 1),
    ('Priya Shah',     'priya@example.org',   '07700900016', '2025-11-20', 3),
    ('Quinn Taylor',   'quinn@example.org',   '07700900017', '2024-06-06', 2),
    ('Rosa Garcia',    'rosa@example.org',    '07700900018', '2022-01-24', null),
    ('Sam Okafor',     'sam@example.org',     '07700900019', '2026-05-10', 1),
    ('Tara McCann',    'tara@example.org',    '07700900020', '2023-12-02', 3);

insert into qualifications (volunteer_id, qualification_type_id, obtained_on, expires_on) values
    (1, 1, '2024-03-01', '2027-03-01'),
    (3, 1, '2022-06-10', '2025-06-10'),
    (5, 1, '2025-01-15', '2028-01-15'),
    (5, 2, '2025-02-01', '2027-02-01'),
    (8, 1, '2026-02-20', '2029-02-20'),
    (10, 2, '2023-05-05', '2025-05-05'),
    (13, 1, '2025-09-01', '2028-09-01'),
    (15, 1, '2023-11-11', '2026-11-11'),
    (15, 2, '2024-11-11', '2026-11-11'),
    (18, 1, '2026-04-04', '2029-04-04');

-- Two shifts a day (09:00-13:00 and 13:00-17:00) at every warehouse, Monday to Saturday,
-- for the four weeks starting Monday 5 October 2026.
insert into shifts (warehouse_id, starts_at, ends_at)
select w.id,
       (g.d + t.start_time) at time zone 'Europe/London',
       (g.d + t.start_time + interval '4 hours') at time zone 'Europe/London'
from warehouses w
cross join generate_series(date '2026-10-05', date '2026-10-31', interval '1 day') as g (d)
cross join (values (interval '9 hours'), (interval '13 hours')) as t (start_time)
where extract(isodow from g.d) between 1 and 6;

-- Every shift has Sorting (4 places) and Packing (3); mornings also have Cold store (2);
-- Saturdays add Loading bay (1) and Reception (1).
insert into slots (shift_id, task_id, capacity)
select s.id, t.id,
       case t.name when 'Sorting' then 4 when 'Packing' then 3 when 'Cold store' then 2 else 1 end
from shifts s
join tasks t on t.name in ('Sorting', 'Packing')
    or (t.name = 'Cold store' and extract(hour from s.starts_at) = 9)
    or (t.name in ('Loading bay', 'Reception') and extract(isodow from s.starts_at) = 6);

-- Deterministic bookings: each volunteer books a subset of slots at their preferred warehouse
-- (or any warehouse if they have none), with statuses spread across the lifecycle.
insert into bookings (slot_id, volunteer_id, status, booked_at)
select sl.id, v.id,
       case
           when sh.starts_at >= timestamptz '2026-10-19 00:00 Europe/London' then
               case when (v.id + sl.id) % 9 = 0 then 'cancelled' else 'booked' end
           when (v.id + sl.id) % 11 = 0 then 'no_show'
           when (v.id + sl.id) % 13 = 0 then 'cancelled'
           else 'attended'
       end,
       sh.starts_at - ((v.id % 5) + 1) * interval '1 day'
from volunteers v
join slots sl on (v.id * 7 + sl.id * 3) % 17 = 0
join shifts sh on sh.id = sl.shift_id
join tasks t on t.id = sl.task_id
where (v.preferred_warehouse_id is null or sh.warehouse_id = v.preferred_warehouse_id)
  and v.joined_on <= sh.starts_at::date
  and (t.required_qualification_type_id is null
       or exists (select 1 from qualifications q
                  where q.volunteer_id = v.id
                    and q.qualification_type_id = t.required_qualification_type_id
                    and q.expires_on >= sh.starts_at::date));