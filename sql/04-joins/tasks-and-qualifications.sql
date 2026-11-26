SELECT t.name task, qt.name requires
FROM tasks t
LEFT JOIN qualification_types qt
  ON qt.id = t.required_qualification_type_id
ORDER BY t.id;