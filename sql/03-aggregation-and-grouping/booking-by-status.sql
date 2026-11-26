select status, count(*) as bookings
from bookings
group by status
order by bookings desc;
