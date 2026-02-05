-- Diagnostic: List person-scoped fields (no dataset, no entity)

SELECT id, name, type
FROM [lookup.field]
WHERE active = 1
  AND dataset IS NULL
  AND entity IS NULL
ORDER BY name