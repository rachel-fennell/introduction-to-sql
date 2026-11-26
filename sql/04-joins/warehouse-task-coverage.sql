
SELECT w.name warehouse, t.name task, COUNT(sl.id) slots
FROM warehouses w
CROSS JOIN tasks t
LEFT JOIN shifts sh ON sh.warehouse_id = w.id
LEFT JOIN slots sl
  ON sl.shift_id = sh.id
 AND sl.task_id = t.id
GROUP BY w.name, t.name
ORDER BY w.name, t.name;



BEGIN;

INSERT INTO tasks (name) VALUES ('Driving');

SELECT w.name warehouse, t.name task, COUNT(sl.id) slots
FROM warehouses w
CROSS JOIN tasks t
LEFT JOIN shifts sh ON sh.warehouse_id = w.id
LEFT JOIN slots sl
  ON sl.shift_id = sh.id
 AND sl.task_id = t.id
GROUP BY w.name, t.name
ORDER BY w.name, t.name;

ROLLBACK;