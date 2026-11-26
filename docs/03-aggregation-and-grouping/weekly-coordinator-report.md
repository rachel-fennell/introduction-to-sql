# Creating weekly coordinator report

## Goal
Write and save queries in sql/03-aggregation-and-grouping/ for: bookings by status; bookings per week using date_trunc; slots, total places and minimum and maximum capacity per task id; and volunteers with ten or more bookings. Paste each result into your evidence file and explain in one sentence why volunteers 6, 11 and 18 have so many bookings. 

## Steps taken
1. Created four query files in sql/03-aggregation-and-grouping and ran in pqsl
2. Queried to find busy volunteers. Checked their preferred warehouse IDs and found that volunteers 6, 11, and 18 have no preferred warehouse; the seed data allows volunteers without a preference to book at any warehouse

## Commands
scheduler=# \i /sql/03-aggregation-and-grouping/booking-by-status.sql
scheduler=# \i /sql/03-aggregation-and-grouping/booking-per-week.sql
scheduler=# \i /sql/03-aggregation-and-grouping/query-per-task-id.sql
scheduler=# \i /sql/03-aggregation-and-grouping/volunteers-ten-plus-bookings.sql

## Results
scheduler=# \i /sql/03-aggregation-and-grouping/booking-by-status.sql
  status   | bookings
-----------+----------
 booked    |       74
 attended  |       70
 cancelled |       15
 no_show   |        5
(4 rows)

scheduler=# \i /sql/03-aggregation-and-grouping/booking-per-week.sql
    week    | bookings
------------+----------
 2026-09-28 |       16
 2026-10-05 |       41
 2026-10-12 |       41
 2026-10-19 |       41
 2026-10-26 |       25
(5 rows)

scheduler=# \i /sql/03-aggregation-and-grouping/query-per-task-id.sql
 task_id | slot_count | total_capacity | min_capacity | max_capacity
---------+------------+----------------+--------------+--------------
       1 |        144 |            576 |            4 |            4
       2 |        144 |            432 |            3 |            3
       3 |         24 |             24 |            1 |            1
       4 |         72 |            144 |            2 |            2
       5 |         24 |             24 |            1 |            1
(5 rows)

scheduler=# \i /sql/03-aggregation-and-grouping/volunteers-ten-plus-bookings.sql
 volunteer_id | bookings
--------------+----------
           11 |       24
           18 |       24
            6 |       12
(3 rows)


Volunteers with the most bookings have no preferred warehouse id (set as null). This explains why they have the most bookings as they can be placed anywhere.

## Observations
