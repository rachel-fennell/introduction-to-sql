# Find the Gaps

## Goal
Write queries in sql/04-joins/ for: every task with its required qualification, including tasks that need none; volunteers who have never attended, as an anti-join, plus the broken version with the status condition in where and its result; and a warehouse-by-task coverage matrix with a cross join and left joins. Every combination has slots in the seed, so run begin, insert a task named Driving, rerun the matrix to see its zero rows, then rollback. 

## Steps taken
1. Ran a left join from tasks to qualification types
2. Ran the anti-join for volunteers without an attended booking, then ran the broken version with the status condition in WHERE
3. Built a warehouse task coverage matrix using a cross join and left joins
4. Started a transaction, inserted a temporary driving task, reran the matrix and rolled back the transaction

## Commands
scheduler=# \i /sql/04-joins/tasks-and-qualifications.sql
scheduler=# \i /sql/04-joins/volunteers-never-attended.sql
scheduler=# \i /sql/04-joins/warehouse-task-coverage.sql

## Results
scheduler=# \i /sql/04-joins/tasks-and-qualifications.sql
    task     |       requires
-------------+----------------------
 Sorting     |
 Packing     |
 Reception   |
 Cold store  | Food hygiene level 2
 Loading bay | Forklift
(5 rows)

scheduler=# \i /sql/04-joins/volunteers-never-attended.sql

correct version:
 full_name
------------
 Isla Byrne
(1 row)

broken version:
 full_name
-----------
(0 rows)

scheduler=# \i /sql/04-joins/warehouse-task-coverage.sql
 warehouse |    task     | slots
-----------+-------------+-------
 Central   | Cold store  |    24
 Central   | Loading bay |     8
 Central   | Packing     |    48
 Central   | Reception   |     8
 Central   | Sorting     |    48
 North     | Cold store  |    24
 North     | Loading bay |     8
 North     | Packing     |    48
 North     | Reception   |     8
 North     | Sorting     |    48
 Riverside | Cold store  |    24
 Riverside | Loading bay |     8
 Riverside | Packing     |    48
 Riverside | Reception   |     8
 Riverside | Sorting     |    48
(15 rows)

BEGIN
INSERT 0 1
 warehouse |    task     | slots
-----------+-------------+-------
 Central   | Cold store  |    24
 Central   | Driving     |     0
 Central   | Loading bay |     8
 Central   | Packing     |    48
 Central   | Reception   |     8
 Central   | Sorting     |    48
 North     | Cold store  |    24
 North     | Driving     |     0
 North     | Loading bay |     8
 North     | Packing     |    48
 North     | Reception   |     8
 North     | Sorting     |    48
 Riverside | Cold store  |    24
 Riverside | Driving     |     0
 Riverside | Loading bay |     8
 Riverside | Packing     |    48
 Riverside | Reception   |     8
 Riverside | Sorting     |    48
(18 rows)

ROLLBACK

## Observations


