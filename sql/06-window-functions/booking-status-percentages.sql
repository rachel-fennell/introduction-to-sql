SELECT status,
       COUNT(*) n,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) pct
FROM bookings
GROUP BY status
ORDER BY n DESC;