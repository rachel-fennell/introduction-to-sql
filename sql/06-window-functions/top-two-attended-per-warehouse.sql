WITH attended AS (
    SELECT b.volunteer_id, sh.warehouse_id, COUNT(*) n
    FROM bookings b
    JOIN slots sl ON sl.id = b.slot_id
    JOIN shifts sh ON sh.id = sl.shift_id
    WHERE b.status = 'attended'
    GROUP BY b.volunteer_id, sh.warehouse_id
),
ranked AS (
    SELECT attended.*,
           ROW_NUMBER() OVER (
               PARTITION BY warehouse_id
               ORDER BY n DESC, volunteer_id
           ) rn
    FROM attended
)
SELECT w.name warehouse, v.full_name, ranked.n attended_shifts
FROM ranked
JOIN warehouses w ON w.id = ranked.warehouse_id
JOIN volunteers v ON v.id = ranked.volunteer_id
WHERE ranked.rn <= 2
ORDER BY w.name, ranked.rn;