-- Diagnostic: List all type X fields to see pattern

SELECT TOP 10
    id,
    name,
    type,
    entity
FROM [lookup.field]
WHERE type = 'X'