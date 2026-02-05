-- Diagnostic: Show all fields for Ahmed Abdelhai's advisor entities
-- Field types: value, related, or prompt (lookup from lookup.prompt)

SELECT
    e.id AS entity_id,
    f.field AS field_name,
    f.value AS field_value,
    f.related AS field_related,
    f.prompt AS field_prompt
FROM [entity] e
JOIN [field] f ON f.record = e.id
WHERE e.record = '52ede6c5-7212-4db1-87b4-93f6fb1cb5d2'
    AND e.entity = '06d6334d-392f-4686-aaa1-ddd2e5640c2b'
ORDER BY e.id, f.field