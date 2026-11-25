select id, starts_at, ends_at
from shifts
where warehouse_id = 3
  and starts_at >= '2026-10-24'
  and starts_at < '2026-10-25'
order by starts_at asc;

