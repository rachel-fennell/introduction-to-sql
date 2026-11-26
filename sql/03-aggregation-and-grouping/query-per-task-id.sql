select task_id,
       count(*) as slot_count,
       sum(capacity) as total_capacity,
       min(capacity) as min_capacity,
       max(capacity) as max_capacity
from slots
group by task_id
order by task_id;