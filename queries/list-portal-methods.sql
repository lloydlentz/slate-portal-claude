-- Diagnostic: Show raw field_related value for advisor
-- Check if it's a valid person GUID

SELECT TOP 5
    p.first + ' ' + p.last AS student_name,
    adv_field.field AS field_name,
    adv_field.related AS raw_related,
    CAST(adv_field.related AS NVARCHAR(100)) AS related_as_string,
    (SELECT p2.first + ' ' + p2.last FROM [person] p2 WHERE p2.id = adv_field.related) AS advisor_name_subquery
FROM [person] p
INNER JOIN [entity] adv_entity ON adv_entity.record = p.id
    AND adv_entity.entity = '06d6334d-392f-4686-aaa1-ddd2e5640c2b'
INNER JOIN [field] adv_field ON adv_field.record = adv_entity.id
    AND adv_field.field = 'advisor_person'
WHERE adv_field.related IS NOT NULL
