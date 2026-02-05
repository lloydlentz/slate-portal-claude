-- Diagnostic: List person-scoped fields

SELECT id, name, type, prompt
FROM [lookup.field]
WHERE scope = 'person'
  AND active = 1
ORDER BY name