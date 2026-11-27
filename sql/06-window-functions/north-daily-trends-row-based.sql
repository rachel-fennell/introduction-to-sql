WITH daily AS (
    SELECT sh.starts_at::date AS booking_date, COUNT(*) AS n
    FROM bookings b
    JOIN slots sl ON sl.id = b.slot_id
    JOIN shifts sh ON sh.id = sl.shift_id
    WHERE sh.warehouse_id = 1
      AND sh.starts_at >= DATE '2026-10-05'
      AND sh.starts_at < DATE '2026-11-01'
    GROUP BY sh.starts_at::date
)
SELECT booking_date,
       n,
       SUM(n) OVER (
           ORDER BY booking_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total,
       ROUND(AVG(n) OVER (
           ORDER BY booking_date
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS moving_avg_3_rows
FROM daily
ORDER BY booking_date;