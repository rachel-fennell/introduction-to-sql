SELECT sl.id slot_id,
       sh.starts_at,
       t.name task,
       sl.capacity,
       sl.capacity - (
           SELECT COUNT(*)
           FROM bookings b
           WHERE b.slot_id = sl.id
             AND b.status = 'booked'
       ) places_left
FROM slots sl
JOIN shifts sh ON sh.id = sl.shift_id
JOIN tasks t ON t.id = sl.task_id
WHERE sh.warehouse_id = 1
  AND sh.starts_at >= '2026-10-31'
  AND sh.starts_at < '2026-11-01'
ORDER BY sh.starts_at, t.name;


WITH booked AS (
    SELECT slot_id, COUNT(*) n
    FROM bookings
    WHERE status = 'booked'
    GROUP BY slot_id
)
SELECT sl.id slot_id,
       sh.starts_at,
       t.name task,
       sl.capacity,
       sl.capacity - COALESCE(booked.n, 0) places_left
FROM slots sl
JOIN shifts sh ON sh.id = sl.shift_id
JOIN tasks t ON t.id = sl.task_id
LEFT JOIN booked ON booked.slot_id = sl.id
WHERE sh.warehouse_id = 1
  AND sh.starts_at >= '2026-10-31'
  AND sh.starts_at < '2026-11-01'
ORDER BY sh.starts_at, t.name;


WITH correlated AS (
    SELECT sl.id slot_id,
           sh.starts_at,
           t.name task,
           sl.capacity,
           sl.capacity - (
               SELECT COUNT(*)
               FROM bookings b
               WHERE b.slot_id = sl.id
                 AND b.status = 'booked'
           ) places_left
    FROM slots sl
    JOIN shifts sh ON sh.id = sl.shift_id
    JOIN tasks t ON t.id = sl.task_id
    WHERE sh.warehouse_id = 1
      AND sh.starts_at >= '2026-10-31'
      AND sh.starts_at < '2026-11-01'
),
booked AS (
    SELECT slot_id, COUNT(*) n
    FROM bookings
    WHERE status = 'booked'
    GROUP BY slot_id
),
cte_version AS (
    SELECT sl.id slot_id,
           sh.starts_at,
           t.name task,
           sl.capacity,
           sl.capacity - COALESCE(booked.n, 0) places_left
    FROM slots sl
    JOIN shifts sh ON sh.id = sl.shift_id
    JOIN tasks t ON t.id = sl.task_id
    LEFT JOIN booked ON booked.slot_id = sl.id
    WHERE sh.warehouse_id = 1
      AND sh.starts_at >= '2026-10-31'
      AND sh.starts_at < '2026-11-01'
),
correlated_only AS (
    SELECT * FROM correlated
    EXCEPT
    SELECT * FROM cte_version
),
cte_only AS (
    SELECT * FROM cte_version
    EXCEPT
    SELECT * FROM correlated
)
SELECT 'correlated_only' comparison, * FROM correlated_only
UNION ALL
SELECT 'cte_only' comparison, * FROM cte_only;



SELECT v.full_name
FROM volunteers v
WHERE v.id IN (
    SELECT q.volunteer_id
    FROM qualifications q
    JOIN qualification_types qt
      ON qt.id = q.qualification_type_id
    WHERE qt.name = 'Food hygiene level 2'
      AND q.obtained_on <= DATE '2026-10-31'
      AND q.expires_on >= DATE '2026-10-31'
)
ORDER BY v.full_name;



SELECT v.full_name
FROM volunteers v
WHERE EXISTS (
    SELECT 1
    FROM qualifications q
    WHERE q.volunteer_id = v.id
      AND q.expires_on < DATE '2026-10-31'
)
ORDER BY v.full_name;