select date_trunc('week', booked_at)::date as week, count(*) as bookings
from bookings
group by 1
order by 1;