# Saturday Rota

## Goal
Write sql/04-joins/saturday-rota.sql to list, for Saturday 24 October 2026, the warehouse, shift start time, task, volunteer name and booking status for every booking, ordered by warehouse, start time and task. Then extend it with a left join so slots with no bookings also appear, showing NULL for the volunteer, and explain the difference in row counts in your evidence file.

## Steps taken
1. Wrote two rota queries in the SQL file: an inner-join query showing bookings and a left-join query that also keeps slots without bookings
2. Used the foreign keys to connect bookings, volunteers, slots, tasks, shifts and warehouses and filtered shifts to 24 October 2026 with a half-open date range
3. Ran both queries in psql with \i /sql/04-joins/saturday-rota.sql and compared the results

## Commands
scheduler=# \i /sql/04-joins/saturday-rota.sql


## Results
 warehouse |       starts_at        |   task    |  full_name   |  status
-----------+------------------------+-----------+--------------+-----------
 Central   | 2026-10-24 09:00:00+01 | Packing   | Chloe Murphy | cancelled
 Central   | 2026-10-24 09:00:00+01 | Sorting   | Rosa Garcia  | booked
 Central   | 2026-10-24 13:00:00+01 | Sorting   | Kara Nolan   | booked
 North     | 2026-10-24 09:00:00+01 | Reception | Erin Walsh   | booked
 North     | 2026-10-24 09:00:00+01 | Sorting   | Ana Silva    | booked
 North     | 2026-10-24 09:00:00+01 | Sorting   | Rosa Garcia  | booked
 North     | 2026-10-24 13:00:00+01 | Packing   | Maya Chen    | booked
 North     | 2026-10-24 13:00:00+01 | Reception | Orla Kennedy | booked
 North     | 2026-10-24 13:00:00+01 | Sorting   | Kara Nolan   | booked
 Riverside | 2026-10-24 09:00:00+01 | Packing   | Tara McCann  | cancelled
 Riverside | 2026-10-24 09:00:00+01 | Sorting   | Rosa Garcia  | booked
 Riverside | 2026-10-24 13:00:00+01 | Sorting   | Kara Nolan   | booked
(12 rows)

 warehouse |       starts_at        |    task     |  full_name   |  status
-----------+------------------------+-------------+--------------+-----------
 Central   | 2026-10-24 09:00:00+01 | Cold store  |              |
 Central   | 2026-10-24 09:00:00+01 | Loading bay |              |
 Central   | 2026-10-24 09:00:00+01 | Packing     | Chloe Murphy | cancelled
 Central   | 2026-10-24 09:00:00+01 | Reception   |              |
 Central   | 2026-10-24 09:00:00+01 | Sorting     | Rosa Garcia  | booked
 Central   | 2026-10-24 13:00:00+01 | Loading bay |              |
 Central   | 2026-10-24 13:00:00+01 | Packing     |              |
 Central   | 2026-10-24 13:00:00+01 | Reception   |              |
 Central   | 2026-10-24 13:00:00+01 | Sorting     | Kara Nolan   | booked
 North     | 2026-10-24 09:00:00+01 | Cold store  |              |
 North     | 2026-10-24 09:00:00+01 | Loading bay |              |
 North     | 2026-10-24 09:00:00+01 | Packing     |              |
 North     | 2026-10-24 09:00:00+01 | Reception   | Erin Walsh   | booked
 North     | 2026-10-24 09:00:00+01 | Sorting     | Ana Silva    | booked
 North     | 2026-10-24 09:00:00+01 | Sorting     | Rosa Garcia  | booked
 North     | 2026-10-24 13:00:00+01 | Loading bay |              |
 North     | 2026-10-24 13:00:00+01 | Packing     | Maya Chen    | booked
 North     | 2026-10-24 13:00:00+01 | Reception   | Orla Kennedy | booked
 North     | 2026-10-24 13:00:00+01 | Sorting     | Kara Nolan   | booked
 Riverside | 2026-10-24 09:00:00+01 | Cold store  |              |
 Riverside | 2026-10-24 09:00:00+01 | Loading bay |              |
 Riverside | 2026-10-24 09:00:00+01 | Packing     | Tara McCann  | cancelled
 Riverside | 2026-10-24 09:00:00+01 | Reception   |              |
 Riverside | 2026-10-24 09:00:00+01 | Sorting     | Rosa Garcia  | booked
 Riverside | 2026-10-24 13:00:00+01 | Loading bay |              |
 Riverside | 2026-10-24 13:00:00+01 | Packing     |              |
 Riverside | 2026-10-24 13:00:00+01 | Reception   |              |
 Riverside | 2026-10-24 13:00:00+01 | Sorting     | Kara Nolan   | booked
(28 rows)

inner join returned 12 booking rows. left join returned 28 rows because it kept all 27 slots, including 16 unbooked slots and one slot had two bookings. rows for unbooked slots have NULL volunteer and status value


## Observations
