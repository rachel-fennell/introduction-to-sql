select full_name, phone
from volunteers
where phone is null
order by full_name;

