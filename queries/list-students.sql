-- List Students Query
-- Purpose: Get first 10 students alphabetically for student list view
-- Returns: Basic student info (name, email)
-- Note: Major and class_year require entity joins - add when entity GUIDs identified

SELECT TOP 10
    p.id AS student_id,
    p.first,
    p.last,
    p.email
    -- TODO: Add major and class_year from appropriate entities
    -- Example: MAX(CASE WHEN f.field = 'field_id_for_major' THEN f.value END) AS major
FROM [person] p
WHERE p.id IS NOT NULL
ORDER BY p.last, p.first
