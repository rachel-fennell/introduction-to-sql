WITH attended AS (
    SELECT b.volunteer_id, sh.warehouse_id, COUNT(*) n
    FROM bookings b
    JOIN slots sl ON sl.id = b.slot_id
    JOIN shifts sh ON sh.id = sl.shift_id
    WHERE b.status = 'attended'
    GROUP BY b.volunteer_id, sh.warehouse_id
)
SELECT w.name warehouse,
       v.full_name,
       a.n attended_shifts,
       RANK() OVER (
           PARTITION BY a.warehouse_id ORDER BY a.n DESC
       ) rnk,
       DENSE_RANK() OVER (
           PARTITION BY a.warehouse_id ORDER BY a.n DESC
       ) dense_rnk
FROM attended a
JOIN volunteers v ON v.id = a.volunteer_id
JOIN warehouses w ON w.id = a.warehouse_id
ORDER BY w.name, rnk, v.full_name;