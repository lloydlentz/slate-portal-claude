-- List All Active Entity Definitions
-- Purpose: Identify available entity types in the system
SELECT
    id,
    name,
    active
FROM [lookup.entity]
WHERE active = 1
ORDER BY name
