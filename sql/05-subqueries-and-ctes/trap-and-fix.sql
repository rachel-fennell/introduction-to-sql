BEGIN;

INSERT INTO warehouses (name, city)
VALUES ('Harbour', 'Larne');

SELECT name
FROM warehouses
WHERE id NOT IN (
    SELECT preferred_warehouse_id
    FROM volunteers
);

SELECT w.name
FROM warehouses w
WHERE NOT EXISTS (
    SELECT 1
    FROM volunteers v
    WHERE v.preferred_warehouse_id = w.id
);

ROLLBACK;


SELECT w.name,
       SUM(sl.capacity) places,
       COUNT(b.id) booked,
       ROUND(100.0 * COUNT(b.id) / SUM(sl.capacity), 1) fill_pct
FROM warehouses w
JOIN shifts sh ON sh.warehouse_id = w.id
JOIN slots sl ON sl.shift_id = sh.id
LEFT JOIN bookings b
  ON b.slot_id = sl.id
 AND b.status = 'booked'
WHERE sh.starts_at >= '2026-10-19'
GROUP BY w.name
ORDER BY w.name;



WITH places AS (
    SELECT sh.warehouse_id, SUM(sl.capacity) places
    FROM shifts sh
    JOIN slots sl ON sl.shift_id = sh.id
    WHERE sh.starts_at >= '2026-10-19'
    GROUP BY sh.warehouse_id
),
booked AS (
    SELECT sh.warehouse_id, COUNT(*) booked
    FROM bookings b
    JOIN slots sl ON sl.id = b.slot_id
    JOIN shifts sh ON sh.id = sl.shift_id
    WHERE b.status = 'booked'
      AND sh.starts_at >= '2026-10-19'
    GROUP BY sh.warehouse_id
)
SELECT w.name,
       p.places,
       COALESCE(b.booked, 0) booked,
       ROUND(100.0 * COALESCE(b.booked, 0) / p.places, 1) fill_pct
FROM warehouses w
JOIN places p ON p.warehouse_id = w.id
LEFT JOIN booked b ON b.warehouse_id = w.id
ORDER BY w.name;