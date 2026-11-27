# Slot availability

## Goal
For Saturday 31 October 2026 at a warehouse of your choice, list every slot with task, capacity and places left using a correlated subquery. Rewrite it with a CTE that counts current bookings per slot and a left join, and prove the two return identical rows (for example by comparing them with except in both directions). Then list volunteers with a valid food hygiene qualification on that date using in, and volunteers with any expired qualification using exists. 

## Steps taken
1. Wrote a correlated subquery that counts booked records for each slot and subtracts that count from the slot’s capacity
2. Rewrote the availability query using a CTE to count bookings by slot then left joined those counts to the slots
3. Compared the two result sets with EXCEPT in both directions
4. Used IN to find volunteers with a valid food hygiene level 2 qualification on 31 October 2026
5. Used EXISTS to find volunteers with any qualification expired by that date

## Commands
scheduler=# \i /sql/05-subqueries-and-ctes/slot-availability-two-ways.sql

## Results

 slot_id |       starts_at        |    task     | capacity | places_left
---------+------------------------+-------------+----------+-------------
     131 | 2026-10-31 09:00:00+00 | Cold store  |        2 |           2
     132 | 2026-10-31 09:00:00+00 | Loading bay |        1 |           1
     129 | 2026-10-31 09:00:00+00 | Packing     |        3 |           3
     130 | 2026-10-31 09:00:00+00 | Reception   |        1 |           1
     128 | 2026-10-31 09:00:00+00 | Sorting     |        4 |           2
     136 | 2026-10-31 13:00:00+00 | Loading bay |        1 |           1
     134 | 2026-10-31 13:00:00+00 | Packing     |        3 |           2
     135 | 2026-10-31 13:00:00+00 | Reception   |        1 |           0
     133 | 2026-10-31 13:00:00+00 | Sorting     |        4 |           4
(9 rows)

 slot_id |       starts_at        |    task     | capacity | places_left
---------+------------------------+-------------+----------+-------------
     131 | 2026-10-31 09:00:00+00 | Cold store  |        2 |           2
     132 | 2026-10-31 09:00:00+00 | Loading bay |        1 |           1
     129 | 2026-10-31 09:00:00+00 | Packing     |        3 |           3
     130 | 2026-10-31 09:00:00+00 | Reception   |        1 |           1
     128 | 2026-10-31 09:00:00+00 | Sorting     |        4 |           2
     136 | 2026-10-31 13:00:00+00 | Loading bay |        1 |           1
     134 | 2026-10-31 13:00:00+00 | Packing     |        3 |           2
     135 | 2026-10-31 13:00:00+00 | Reception   |        1 |           0
     133 | 2026-10-31 13:00:00+00 | Sorting     |        4 |           4
(9 rows)

 comparison | slot_id | starts_at | task | capacity | places_left
------------+---------+-----------+------+----------+-------------
(0 rows)

The comparison query returned zero rows, so neither version had any rows missing from the other

valid food hygiene level 2:

  full_name
--------------
 Ana Silva
 Erin Walsh
 Hugo Brown
 Maya Chen
 Orla Kennedy
 Rosa Garcia
(6 rows)

at least one exp qualification:

  full_name
--------------
 Chloe Murphy
 Jack Doherty
(2 rows)

## Observations
