-- Diagnostic: Explore lookup.prompt for terms

SELECT TOP 20
    id,
    [key],
    name,
    [start],
    [stop],
    active
FROM [lookup.prompt]
WHERE [key] = 'term'
ORDER BY [start] DESC