# Reliability metrics and filtering

## Goal
Write one query that lists every volunteer id with attended, no-show and cancelled counts using filter, keeping only volunteers with at least one no-show or cancellation. Then calculate the overall no-show rate for past bookings to one decimal place, avoiding integer division. In your evidence file, state the exact definition of the rate and show how the answer changes if future bookings are wrongly included in the denominator. 

## Steps taken
1. Grouped bookings by volunteer_id and used aggregate FILTER clauses to count attended, no-show and cancelled bookings for each volunteer
2. Used HAVING to keep only volunteers with at least one no-show or cancellation
3. Calculated the past-booking no-show rate as no-show bookings divided by attended plus no-show bookings, multiplied by 100.0 and rounded to one decimal place
4. Recalculated the rate with booked rows included in the denominator and compared it with the past-booking rate

## Commands

select volunteer_id,
    count(*) filter (where status = 'no_show') as no_shows,
    count(*) filter (where status = 'attended') as attended,
    count(*) filter (where status = 'cancelled') as cancelled
from bookings
group by volunteer_id
having count(*) filter (where status in ('no_show', 'cancelled')) >=1
order by volunteer_id;


select round(100.0 * count(*) filter (where status = 'no_show')
             / count(*) filter (where status in ('attended', 'no_show')), 1) as no_show_rate_pct
from bookings;

## Results

 volunteer_id | no_shows | attended | cancelled
--------------+----------+----------+-----------
            1 |        1 |        3 |         0
            3 |        0 |        4 |         1
            4 |        0 |        3 |         1
            5 |        1 |        3 |         1
            6 |        0 |        5 |         1
            8 |        0 |        4 |         1
           10 |        0 |        4 |         1
           11 |        1 |       10 |         2
           14 |        0 |        3 |         2
           15 |        0 |        3 |         2
           18 |        1 |        9 |         2
           20 |        1 |        3 |         1
(12 rows)


 no_show_rate_pct
------------------
              6.7
(1 row)

past-booking no-show rate:
no-show bookings ÷ (attended bookings + no-show bookings) × 100

excludes booked bookings because they have no outcome yet and excludes cancelled bookings.
if you included future bookings in this query, the rate would become lower as the denominator would be larger therefore presenting an inaccurate answer

## Observations
