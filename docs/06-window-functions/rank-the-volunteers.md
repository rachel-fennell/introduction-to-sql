# ranking the volunteers

## Goal
Save queries in sql/06-window-functions/ that show each booking status with its percentage of all bookings; rank volunteers by attended shifts within each warehouse with both rank() and dense_rank(); and list the top two volunteers per warehouse using row_number() with a deterministic tiebreaker. In your evidence file, explain the rank difference at Central and what would change without the tiebreaker. 

## Steps taken
1. Grouped bookings by status and used a window aggregate to calculate each status’s percentage of the total
2. Counted attended bookings for each volunteer in each warehouse, then calculated RANK() and DENSE_RANK() within each warehouse
3. Used ROW_NUMBER() with volunteer_id as a tie-breaker to select the top two volunteers per warehouse
4. Ran the three queries

## Commands
scheduler=# \i /sql/06-window-functions/booking-status-percentages.sql

scheduler=# \i /sql/06-window-functions/attended-rank-by-warehouse.sql

scheduler=# \i /sql/06-window-functions/top-two-attended-per-warehouse.sql

## Results
scheduler=# \i /sql/06-window-functions/booking-status-percentages.sql
  status   | n  | pct
-----------+----+------
 booked    | 74 | 45.1
 attended  | 70 | 42.7
 cancelled | 15 |  9.1
 no_show   |  5 |  3.0
(4 rows)

scheduler=# \i /sql/06-window-functions/attended-rank-by-warehouse.sql
 warehouse |  full_name   | attended_shifts | rnk | dense_rnk
-----------+--------------+-----------------+-----+-----------
 Central   | Chloe Murphy |               4 |   1 |         1
 Central   | Jack Doherty |               4 |   1 |         1
 Central   | Rosa Garcia  |               4 |   1 |         1
 Central   | Kara Nolan   |               3 |   4 |         2
 Central   | Niall Fox    |               3 |   4 |         2
 Central   | Femi Adeyemi |               2 |   6 |         3
 Central   | Grace Kelly  |               2 |   6 |         3
 Central   | Quinn Taylor |               2 |   6 |         3
 North     | Kara Nolan   |               4 |   1 |         1
 North     | Maya Chen    |               4 |   1 |         1
 North     | Ana Silva    |               3 |   3 |         2
 North     | Erin Walsh   |               3 |   3 |         2
 North     | Orla Kennedy |               3 |   3 |         2
 North     | Ben Carter   |               2 |   6 |         3
 North     | Rosa Garcia  |               2 |   6 |         3
 North     | Sam Okafor   |               2 |   6 |         3
 North     | Femi Adeyemi |               1 |   9 |         4
 Riverside | Hugo Brown   |               4 |   1 |         1
 Riverside | Dev Patel    |               3 |   2 |         2
 Riverside | Kara Nolan   |               3 |   2 |         2
 Riverside | Rosa Garcia  |               3 |   2 |         2
 Riverside | Tara McCann  |               3 |   2 |         2
 Riverside | Femi Adeyemi |               2 |   6 |         3
 Riverside | Liam Quinn   |               2 |   6 |         3
 Riverside | Priya Shah   |               2 |   6 |         3
(25 rows)

scheduler=# \i /sql/06-window-functions/top-two-attended-per-warehouse.sql
 warehouse |  full_name   | attended_shifts
-----------+--------------+-----------------
 Central   | Chloe Murphy |               4
 Central   | Jack Doherty |               4
 North     | Kara Nolan   |               4
 North     | Maya Chen    |               4
 Riverside | Hugo Brown   |               4
 Riverside | Dev Patel    |               3
(6 rows)

## Observations
