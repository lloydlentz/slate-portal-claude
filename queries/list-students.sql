-- List Students Query
-- Purpose: Get first 10 students alphabetically who have current course registrations
-- Returns: Basic student info (name, email)
-- Only includes students with records in Banner360 Current Registration entity

SELECT TOP 10
    p.id AS student_id,
    p.first,
    p.last,
    p.email
FROM [person] p
WHERE EXISTS (
    SELECT 1 FROM [entity] e
    WHERE e.record = p.id
    AND e.entity = '820d2fe3-0696-4cb6-97ec-c5cbd0cf91d0'
)
ORDER BY p.last, p.first
