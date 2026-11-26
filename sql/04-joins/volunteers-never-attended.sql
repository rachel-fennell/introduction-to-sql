
SELECT v.full_name
FROM volunteers v
LEFT JOIN bookings b
  ON b.volunteer_id = v.id
 AND b.status = 'attended'
WHERE b.id IS NULL
ORDER BY v.full_name;


SELECT v.full_name
FROM volunteers v
LEFT JOIN bookings b
  ON b.volunteer_id = v.id
WHERE b.status = 'attended'
  AND b.id IS NULL
ORDER BY v.full_name;