WITH ana_shifts AS (
    SELECT DISTINCT sh.id, sh.starts_at
    FROM bookings b
    JOIN slots sl ON sl.id = b.slot_id
    JOIN shifts sh ON sh.id = sl.shift_id
    WHERE b.volunteer_id = 1
)
SELECT starts_at::date AS shift_date,
       LAG(starts_at::date) OVER (ORDER BY starts_at) AS previous_shift_date,
       starts_at::date
         - LAG(starts_at::date) OVER (ORDER BY starts_at)
         AS days_since_previous_shift
FROM ana_shifts
ORDER BY starts_at;