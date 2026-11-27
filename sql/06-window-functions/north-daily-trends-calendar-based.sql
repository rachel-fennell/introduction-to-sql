WITH daily AS (
    SELECT sh.starts_at::date AS booking_date, COUNT(*) AS n
    FROM bookings b
    JOIN slots sl ON sl.id = b.slot_id
    JOIN shifts sh ON sh.id = sl.shift_id
    WHERE sh.warehouse_id = 1
      AND sh.starts_at >= DATE '2026-10-05'
      AND sh.starts_at < DATE '2026-11-01'
    GROUP BY sh.starts_at::date
),
calendar AS (
    SELECT generate_series(
        DATE '2026-10-05',
        DATE '2026-10-31',
        INTERVAL '1 day'
    )::date AS booking_date
),
daily_with_zeros AS (
    SELECT calendar.booking_date, COALESCE(daily.n, 0) n
    FROM calendar
    LEFT JOIN daily ON daily.booking_date = calendar.booking_date
)
SELECT booking_date AS calendar_day,
       n,
       SUM(n) OVER (
           ORDER BY booking_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) running_total,
       ROUND(AVG(n) OVER (
           ORDER BY booking_date
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) moving_avg_3_days
FROM daily_with_zeros
ORDER BY booking_date;