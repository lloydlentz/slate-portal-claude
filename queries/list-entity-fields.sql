-- List Fields for Advisor Entity
-- Purpose: Find field IDs for advisor data
SELECT
    lf.id AS field_id,
    lf.name AS field_name,
    lf.prompt,
    lf.type,
    lf.multiple,
    lf.entity
FROM [lookup.field] lf
WHERE lf.entity = '06d6334d-392f-4686-aaa1-ddd2e5640c2b'  -- Advisor
  AND lf.active = 1
ORDER BY lf.name
