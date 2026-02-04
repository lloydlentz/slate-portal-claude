-- List Fields for Current Registration Entity
-- Purpose: Find field IDs for course registration data
SELECT
    lf.id AS field_id,
    lf.name AS field_name,
    lf.prompt,
    lf.type,
    lf.multiple,
    lf.entity
FROM [lookup.field] lf
WHERE lf.entity = '820d2fe3-0696-4cb6-97ec-c5cbd0cf91d0'  -- SSIS - Banner360 - Current Registration
  AND lf.active = 1
ORDER BY lf.name
