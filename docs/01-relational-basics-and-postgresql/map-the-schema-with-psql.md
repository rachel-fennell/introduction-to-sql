# Map the Schema with psql

## Goal
Use \dt and \d on each table to list its columns, primary key, foreign keys, unique constraints and check constraints. Produce a table in your evidence file with one row per table, and answer: which tables can exist without any other table, and which column would you follow to get from a booking to its warehouse? 

## Steps taken
1. What you did, in order, linking to the files you created or changed.

## Commands
docker compose up -d --wait
docker compose exec db psql -U scheduler -d scheduler -v ON_ERROR_STOP=1 -f /sql/seed.sql
docker compose exec db psql -U scheduler -d scheduler
scheduler=# \dt
scheduler=# \d

## Results
                     List of relations
 Schema |            Name            |   Type   |   Owner
--------+----------------------------+----------+-----------
 public | bookings                   | table    | scheduler
 public | bookings_id_seq            | sequence | scheduler
 public | qualification_types        | table    | scheduler
 public | qualification_types_id_seq | sequence | scheduler
 public | qualifications             | table    | scheduler
 public | shifts                     | table    | scheduler
 public | shifts_id_seq              | sequence | scheduler
 public | slots                      | table    | scheduler
 public | slots_id_seq               | sequence | scheduler
 public | tasks                      | table    | scheduler
 public | tasks_id_seq               | sequence | scheduler
 public | volunteers                 | table    | scheduler
 public | volunteers_id_seq          | sequence | scheduler
 public | warehouses                 | table    | scheduler
 public | warehouses_id_seq          | sequence | scheduler
(15 rows)


                  List of tables
 Schema |        Name         | Type  |   Owner
--------+---------------------+-------+-----------
 public | bookings            | table | scheduler
 public | qualification_types | table | scheduler
 public | qualifications      | table | scheduler
 public | shifts              | table | scheduler
 public | slots               | table | scheduler
 public | tasks               | table | scheduler
 public | volunteers          | table | scheduler
 public | warehouses          | table | scheduler
(8 rows)


                                    Table "public.bookings"
    Column    |           Type           | Collation | Nullable |           Default
--------------+--------------------------+-----------+----------+------------------------------
 id           | bigint                   |           | not null | generated always as identity
 slot_id      | bigint                   |           | not null |
 volunteer_id | bigint                   |           | not null |
 status       | text                     |           | not null |
 booked_at    | timestamp with time zone |           | not null |
Indexes:
    "bookings_pkey" PRIMARY KEY, btree (id)
    "bookings_slot_id_volunteer_id_key" UNIQUE CONSTRAINT, btree (slot_id, volunteer_id)
Check constraints:
    "bookings_status_check" CHECK (status = ANY (ARRAY['booked'::text, 'cancelled'::text, 'attended'::text, 'no_show'::text]))
Foreign-key constraints:
    "bookings_slot_id_fkey" FOREIGN KEY (slot_id) REFERENCES slots(id)
    "bookings_volunteer_id_fkey" FOREIGN KEY (volunteer_id) REFERENCES volunteers(id)


                                     Table "public.shifts"
    Column    |           Type           | Collation | Nullable |           Default
--------------+--------------------------+-----------+----------+------------------------------
 id           | bigint                   |           | not null | generated always as identity
 warehouse_id | bigint                   |           | not null |
 starts_at    | timestamp with time zone |           | not null |
 ends_at      | timestamp with time zone |           | not null |
Indexes:
    "shifts_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "shifts_check" CHECK (ends_at > starts_at)
Foreign-key constraints:
    "shifts_warehouse_id_fkey" FOREIGN KEY (warehouse_id) REFERENCES warehouses(id)
Referenced by:
    TABLE "slots" CONSTRAINT "slots_shift_id_fkey" FOREIGN KEY (shift_id) REFERENCES shifts(id)


                  Table "public.qualifications"
        Column         |  Type  | Collation | Nullable | Default
-----------------------+--------+-----------+----------+---------
 volunteer_id          | bigint |           | not null |
 qualification_type_id | bigint |           | not null |
 obtained_on           | date   |           | not null |
 expires_on            | date   |           | not null |
Indexes:
    "qualifications_pkey" PRIMARY KEY, btree (volunteer_id, qualification_type_id)
Foreign-key constraints:
    "qualifications_qualification_type_id_fkey" FOREIGN KEY (qualification_type_id) REFERENCES qualification_types(id)
    "qualifications_volunteer_id_fkey" FOREIGN KEY (volunteer_id) REFERENCES volunteers(id)


scheduler=# \d qualification_types
                      Table "public.qualification_types"
    Column    |  Type   | Collation | Nullable |           Default
--------------+---------+-----------+----------+------------------------------
 id           | bigint  |           | not null | generated always as identity
 name         | text    |           | not null |
 valid_months | integer |           | not null |
Indexes:
    "qualification_types_pkey" PRIMARY KEY, btree (id)
    "qualification_types_name_key" UNIQUE CONSTRAINT, btree (name)
Check constraints:
    "qualification_types_valid_months_check" CHECK (valid_months > 0)
Referenced by:
    TABLE "qualifications" CONSTRAINT "qualifications_qualification_type_id_fkey" FOREIGN KEY (qualification_type_id) REFERENCES qualification_types(id)
    TABLE "tasks" CONSTRAINT "tasks_required_qualification_type_id_fkey" FOREIGN KEY (required_qualification_type_id) REFERENCES qualification_types(id)


                                     Table "public.tasks"
             Column             |  Type  | Collation | Nullable |           Default
--------------------------------+--------+-----------+----------+------------------------------
 id                             | bigint |           | not null | generated always as identity
 name                           | text   |           | not null |
 required_qualification_type_id | bigint |           |          |
Indexes:
    "tasks_pkey" PRIMARY KEY, btree (id)
    "tasks_name_key" UNIQUE CONSTRAINT, btree (name)
Foreign-key constraints:
    "tasks_required_qualification_type_id_fkey" FOREIGN KEY (required_qualification_type_id) REFERENCES qualification_types(id)
Referenced by:
    TABLE "slots" CONSTRAINT "slots_task_id_fkey" FOREIGN KEY (task_id) REFERENCES tasks(id)


                          Table "public.slots"
  Column  |  Type   | Collation | Nullable |           Default
----------+---------+-----------+----------+------------------------------
 id       | bigint  |           | not null | generated always as identity
 shift_id | bigint  |           | not null |
 task_id  | bigint  |           | not null |
 capacity | integer |           | not null |
Indexes:
    "slots_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "slots_capacity_check" CHECK (capacity > 0)
Foreign-key constraints:
    "slots_shift_id_fkey" FOREIGN KEY (shift_id) REFERENCES shifts(id)
    "slots_task_id_fkey" FOREIGN KEY (task_id) REFERENCES tasks(id)
Referenced by:
    TABLE "bookings" CONSTRAINT "bookings_slot_id_fkey" FOREIGN KEY (slot_id) REFERENCES slots(id)


                               Table "public.volunteers"
         Column         |  Type  | Collation | Nullable |           Default
------------------------+--------+-----------+----------+------------------------------
 id                     | bigint |           | not null | generated always as identity
 full_name              | text   |           | not null |
 email                  | text   |           | not null |
 phone                  | text   |           |          |
 joined_on              | date   |           | not null |
 preferred_warehouse_id | bigint |           |          |
Indexes:
    "volunteers_pkey" PRIMARY KEY, btree (id)
    "volunteers_email_key" UNIQUE CONSTRAINT, btree (email)
Foreign-key constraints:
    "volunteers_preferred_warehouse_id_fkey" FOREIGN KEY (preferred_warehouse_id) REFERENCES warehouses(id)
Referenced by:
    TABLE "bookings" CONSTRAINT "bookings_volunteer_id_fkey" FOREIGN KEY (volunteer_id) REFERENCES volunteers(id)
    TABLE "qualifications" CONSTRAINT "qualifications_volunteer_id_fkey" FOREIGN KEY (volunteer_id) REFERENCES volunteers(id)


                       Table "public.warehouses"
 Column |  Type  | Collation | Nullable |           Default
--------+--------+-----------+----------+------------------------------
 id     | bigint |           | not null | generated always as identity
 name   | text   |           | not null |
 city   | text   |           | not null |
Indexes:
    "warehouses_pkey" PRIMARY KEY, btree (id)
    "warehouses_name_key" UNIQUE CONSTRAINT, btree (name)
Referenced by:
    TABLE "shifts" CONSTRAINT "shifts_warehouse_id_fkey" FOREIGN KEY (warehouse_id) REFERENCES warehouses(id)
    TABLE "volunteers" CONSTRAINT "volunteers_preferred_warehouse_id_fkey" FOREIGN KEY (preferred_warehouse_id) REFERENCES warehouses(id)

booking - volunteers - warehouse


Table                   Columns                                                             Unique Constraints          Check Constraints
bookings                id, slot_id, volunteer_id, status, booked_at                        slot_id, volunteer_id       status is one of booked, cancelled, attended, no_show
qualification_types     id, name, valid_months                                              name                        valid_months > 0
qualifications          volunteer_id, qualification_type_id, obtained_on, expires_on        none                        none
shifts                  id, warehouse_id, starts_at, ends_at                                none                        ends_at > starts_at
slots                   id, shift_id, task_id, capacity                                     none                        capacity > 0
tasks                   id, name, required_qualification_type_id                            name                        none
volunteers              id, full_name, email, phone, joined_on, preferred_warehouse_id      email                       none
warehouses              id, name, city                                                      none                        none

warehouses, qualification_types and volunteers are independent tables

to find the warehouse for the booking’s shift:
bookings.slot_id → slots.shift_id → shifts.warehouse_id → warehouses.id

## Observations
