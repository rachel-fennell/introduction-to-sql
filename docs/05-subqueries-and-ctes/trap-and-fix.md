# Trap anf fix

## Goal
Inside a transaction, add the Harbour warehouse, show not in returning no rows and not exists returning Harbour, then roll back. Run the wrong fill-rate query and the corrected CTE version for bookings from 19 October 2026, and explain in your evidence file, with the actual numbers, why the first overcounts. 

## Steps taken
1. Began a transaction, inserted Harbour and compared NOT IN with NOT EXISTS
2. Rolled back the transaction after the comparison
3. Ran the query that joins bookings before summing slot capacity
4. Rewrote it with separate CTEs for places and bookings then compared the results

## Commands
scheduler=# \i /sql/05-subqueries-and-ctes/trap-and-fix.sql

## Results
BEGIN
INSERT 0 1

 name
------
(0 rows)

  name
---------
 Harbour
(1 row)

NOT IN query returned no rows. NOT EXISTS returned Harbour

ROLLBACK

incorrect fill-rate query:
   name    | places | booked | fill_pct
-----------+--------+--------+----------
 Central   |    200 |     23 |     11.5
 North     |    224 |     27 |     12.1
 Riverside |    200 |     24 |     12.0
(3 rows)

corrected CTE query:
   name    | places | booked | fill_pct
-----------+--------+--------+----------
 Central   |    200 |     23 |     11.5
 North     |    200 |     27 |     13.5
 Riverside |    200 |     24 |     12.0
(3 rows)


## Observations
