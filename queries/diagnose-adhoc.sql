-- Diagnostic: Check advisor records for Ahmed Abdelhai

SELECT
    e.id AS entity_id,
    f.id AS field_id,
    f.related AS advisor_person_id,
    adv.first AS advisor_first,
    adv.last AS advisor_last
FROM [entity] e
JOIN [field] f ON f.record = e.id AND f.field = 'advisor_person'
JOIN [person] adv ON adv.id = f.related
WHERE e.record = '52ede6c5-7212-4db1-87b4-93f6fb1cb5d2'
    AND e.entity = '06d6334d-392f-4686-aaa1-ddd2e5640c2b'