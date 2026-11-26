# Finding and fixing bugs

## Goal
Write a query that gives a misleading answer because of NULL (for example counting volunteers without a phone using phone = null, or excluding a warehouse with <>), show its result, explain the three-valued logic behind it in your evidence file, then fix it two ways: once with is null or is distinct from, and once with coalesce. 

## Steps taken
1. Ran a query using phone = NULL and recorded that it returned no rows
2. Changed the filter to phone IS NULL and found the four volunteers whose phone number is missing
3. Used COALESCE to display no phone for those missing values

## Commands
counting volunteers without a phone using phone = null

select full_name, phone
from volunteers
where phone = null
order by full_name asc;

select full_name, phone
from volunteers
where phone is null
order by full_name asc;

select full_name, coalesce(phone, 'no phone') as phone
from volunteers
where phone is null
order by full_name asc;

## Results
scheduler=# select full_name, phone
from volunteers
where phone = null
order by full_name asc;
 full_name | phone
-----------+-------
(0 rows)

scheduler=# select full_name, phone
from volunteers
where phone is null
order by full_name asc;
  full_name   | phone
--------------+-------
 Ben Carter   |
 Femi Adeyemi |
 Jack Doherty |
 Orla Kennedy |
(4 rows)

scheduler=# select full_name, coalesce(phone, 'no phone') as phone
from volunteers
where phone is null
order by full_name asc;
  full_name   |  phone
--------------+----------
 Ben Carter   | no phone
 Femi Adeyemi | no phone
 Jack Doherty | no phone
 Orla Kennedy | no phone
(4 rows)

## Observations
