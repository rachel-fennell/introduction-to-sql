
SELECT w.name warehouse,
       sh.starts_at,
       t.name task,
       v.full_name,
       b.status
FROM bookings b
JOIN volunteers v ON v.id = b.volunteer_id
JOIN slots sl ON sl.id = b.slot_id
JOIN tasks t ON t.id = sl.task_id
JOIN shifts sh ON sh.id = sl.shift_id
JOIN warehouses w ON w.id = sh.warehouse_id
WHERE sh.starts_at >= '2026-10-24'
  AND sh.starts_at < '2026-10-25'
ORDER BY w.name, sh.starts_at, t.name;


SELECT w.name warehouse,
       sh.starts_at,
       t.name task,
       v.full_name,
       b.status
FROM slots sl
JOIN shifts sh ON sh.id = sl.shift_id
JOIN warehouses w ON w.id = sh.warehouse_id
JOIN tasks t ON t.id = sl.task_id
LEFT JOIN bookings b ON b.slot_id = sl.id
LEFT JOIN volunteers v ON v.id = b.volunteer_id
WHERE sh.starts_at >= '2026-10-24'
  AND sh.starts_at < '2026-10-25'
ORDER BY w.name, sh.starts_at, t.name;