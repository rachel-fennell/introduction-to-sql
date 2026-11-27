# Trends without gaps

## Goal
For one warehouse, produce daily bookings with a running total and a three-row moving average. Then generate every day from 5 to 31 October 2026 with generate_series or a recursive CTE, left join the daily counts with coalesce to zero, and recompute the moving average so it covers three calendar days. Finally, for one volunteer, show days since their previous shift with lag. Compare the two moving averages in your evidence file. 

## Steps taken
1. Grouped North’s bookings by shift date and calculated a running total and three-row moving average
2. Generated every date from 5 to 31 October 2026, left joined the daily counts and replaced missing counts with zero
3. Recalculated the running total and moving average using the complete calendar
4. Used LAG() to find Ana’s previous shift date and the number of days since that shift
5. Recorded the query outputs and compared the two moving averages

## Commands
scheduler=# \i /sql/06-window-functions/north-daily-trends-row-based.sql

scheduler=# \i /sql/06-window-functions/north-daily-trends-calendar-based.sql

scheduler=# \i /sql/06-window-functions/days-between-ana-shifts.sql

## Results
scheduler=# \i /sql/06-window-functions/north-daily-trends-row-based.sql
 booking_date | n | running_total | moving_avg_3_rows
--------------+---+---------------+-------------------
 2026-10-05   | 2 |             2 |              2.00
 2026-10-06   | 2 |             4 |              2.00
 2026-10-07   | 3 |             7 |              2.33
 2026-10-08   | 2 |             9 |              2.33
 2026-10-10   | 6 |            15 |              3.67
 2026-10-12   | 2 |            17 |              3.33
 2026-10-13   | 2 |            19 |              3.33
 2026-10-14   | 3 |            22 |              2.33
 2026-10-15   | 2 |            24 |              2.33
 2026-10-17   | 6 |            30 |              3.67
 2026-10-19   | 2 |            32 |              3.33
 2026-10-20   | 2 |            34 |              3.33
 2026-10-21   | 3 |            37 |              2.33
 2026-10-22   | 2 |            39 |              2.33
 2026-10-24   | 6 |            45 |              3.67
 2026-10-26   | 2 |            47 |              3.33
 2026-10-27   | 2 |            49 |              3.33
 2026-10-28   | 3 |            52 |              2.33
 2026-10-29   | 2 |            54 |              2.33
 2026-10-31   | 6 |            60 |              3.67
(20 rows)


scheduler=# \i /sql/06-window-functions/north-daily-trends-calendar-based.sql
 calendar_day | n | running_total | moving_avg_3_days
--------------+---+---------------+-------------------
 2026-10-05   | 2 |             2 |              2.00
 2026-10-06   | 2 |             4 |              2.00
 2026-10-07   | 3 |             7 |              2.33
 2026-10-08   | 2 |             9 |              2.33
 2026-10-09   | 0 |             9 |              1.67
 2026-10-10   | 6 |            15 |              2.67
 2026-10-11   | 0 |            15 |              2.00
 2026-10-12   | 2 |            17 |              2.67
 2026-10-13   | 2 |            19 |              1.33
 2026-10-14   | 3 |            22 |              2.33
 2026-10-15   | 2 |            24 |              2.33
 2026-10-16   | 0 |            24 |              1.67
 2026-10-17   | 6 |            30 |              2.67
 2026-10-18   | 0 |            30 |              2.00
 2026-10-19   | 2 |            32 |              2.67
 2026-10-20   | 2 |            34 |              1.33
 2026-10-21   | 3 |            37 |              2.33
 2026-10-22   | 2 |            39 |              2.33
 2026-10-23   | 0 |            39 |              1.67
 2026-10-24   | 6 |            45 |              2.67
 2026-10-25   | 0 |            45 |              2.00
 2026-10-26   | 2 |            47 |              2.67
 2026-10-27   | 2 |            49 |              1.33
 2026-10-28   | 3 |            52 |              2.33
 2026-10-29   | 2 |            54 |              2.33
 2026-10-30   | 0 |            54 |              1.67
 2026-10-31   | 6 |            60 |              2.67
(27 rows)


scheduler=# \i /sql/06-window-functions/days-between-ana-shifts.sql

 shift_date | previous_shift_date | days_since_previous_shift
------------+---------------------+---------------------------
 2026-10-06 |                     |
 2026-10-10 | 2026-10-06          |                         4
 2026-10-13 | 2026-10-10          |                         3
 2026-10-17 | 2026-10-13          |                         4
 2026-10-20 | 2026-10-17          |                         3
 2026-10-24 | 2026-10-20          |                         4
 2026-10-27 | 2026-10-24          |                         3
 2026-10-31 | 2026-10-27          |                         4
(8 rows)

## Observations
