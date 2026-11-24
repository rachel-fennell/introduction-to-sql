# Running the db

## Goal
Create compose.yaml and sql/seed.sql exactly as listed in this module, start the stack with docker compose up -d --wait, load the seed with psql and ON_ERROR_STOP, and run select count(*) against all eight tables. Then stop the stack with docker compose down, start it again and confirm the counts are unchanged. 

## Steps taken
1. Created compose.yaml and sql/seed.sql in the introduction-to-sql repo
2. Attempted to start the stack. The first attempt failed because port 5432 was already in use therefore I changed to port 5433
3. Loaded the seed data and performed SQL queries on the data
4. Restarted the stack and confirmed the counts remained unchanged


## Commands
docker compose up -d --wait
docker compose up -d --wait
docker compose exec db psql -U scheduler -d scheduler -v ON_ERROR_STOP=1 -f /sql/seed.sql
docker compose exec db psql -U scheduler -d scheduler
docker compose down

All of the below SQL commands 

## Results
scheduler=# select count(*) from bookings;
 count
-------
   164
(1 row)

scheduler=# select count(*) from slots;
 count
-------
   408
(1 row)

scheduler=# select count(*) from shifts;
 count
-------
   144
(1 row)

scheduler=# select count(*) from tasks;
 count
-------
     5
(1 row)

scheduler=# select count(*) from qualifications;
 count
-------
    10
(1 row)

scheduler=# select count(*) from volunteers;
 count
-------
    20
(1 row)

scheduler=# select count(*) from qualification_types;
 count
-------
     2
(1 row)

scheduler=# select count(*) from warehouses;
 count
-------
     3
(1 row)

All counts remained the same after the restart

## Observations
Easy to follow steps