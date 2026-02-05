-- Diagnostic: Explore lookup.prompt for terms - all fields

SELECT TOP 20
    id,
    [key],
    name,
    [start],
    [stop],
    active,
    [export],
    [export2],
    [export3],
    [export4]
FROM [lookup.prompt]
WHERE [key] = 'term'
ORDER BY [start] DESC