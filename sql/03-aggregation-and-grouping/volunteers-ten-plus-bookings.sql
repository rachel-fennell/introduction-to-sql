select volunteer_id, count(*) as bookings
from bookings
group by volunteer_id
having count(*) >= 10
order by bookings desc;