# Coordinator Queries

## Goal
Write and run queries for: the five longest-serving North volunteers; volunteers without a phone number; volunteers whose preferred warehouse is not North, including those with no preference; Riverside shifts on Saturday 24 October 2026 ordered by start time, filtered with a half-open range (starts_at >= '2026-10-24' and starts_at < '2026-10-25'); and volunteers whose name contains 'an' in any case. 

## Steps taken
1. Created five SQL files each beginning with a comment stating the coordinator’s question
2. Ran each file in psql with \i and reviewed its results
3. Checked the NULL handling in the not-North query, including the three volunteers with no preferred warehouse

## Commands
docker compose exec db psql -U scheduler -d scheduler
\i /sql/02-selecting-and-filtering/five-longest.sql
\i /sql/02-selecting-and-filtering/name-contains-an.sql
\i /sql/02-selecting-and-filtering/preferred-warehouse-not-north.sql
\i /sql/02-selecting-and-filtering/sat-24-oct-riverside-shifts.sql
\i /sql/02-selecting-and-filtering/without-phone.sql

## Results
scheduler=# \i /sql/02-selecting-and-filtering/five-longest.sql
  full_name   | joined_on  | days_volunteering
--------------+------------+-------------------
 Orla Kennedy | 2021-07-15 |              1959
 Erin Walsh   | 2021-11-30 |              1821
 Rosa Garcia  | 2022-01-24 |              1766
 Chloe Murphy | 2022-05-19 |              1651
 Jack Doherty | 2022-10-05 |              1512
(5 rows)

scheduler=# \i /sql/02-selecting-and-filtering/name-contains-an.sql
  full_name
-------------
 Kara Nolan
 Tara McCann
(2 rows)

scheduler=# \i /sql/02-selecting-and-filtering/preferred-warehouse-not-north.sql
  full_name   | preferred_warehouse_id
--------------+------------------------
 Chloe Murphy |                      2
 Dev Patel    |                      3
 Femi Adeyemi |
 Grace Kelly  |                      2
 Hugo Brown   |                      3
 Jack Doherty |                      2
 Kara Nolan   |
 Liam Quinn   |                      3
 Niall Fox    |                      2
 Priya Shah   |                      3
 Quinn Taylor |                      2
 Rosa Garcia  |
 Tara McCann  |                      3
(13 rows)

scheduler=# \i /sql/02-selecting-and-filtering/sat-24-oct-riverside-shifts.sql
 id  |       starts_at        |        ends_at
-----+------------------------+------------------------
 131 | 2026-10-24 09:00:00+01 | 2026-10-24 13:00:00+01
 132 | 2026-10-24 13:00:00+01 | 2026-10-24 17:00:00+01
(2 rows)

scheduler=# \i /sql/02-selecting-and-filtering/without-phone.sql
  full_name   | phone
--------------+-------
 Ben Carter   |
 Femi Adeyemi |
 Jack Doherty |
 Orla Kennedy |
(4 rows)

## Observations
