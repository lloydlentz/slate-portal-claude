-- Diagnostic: Explore Advisor entity structure
-- Looking at how advisor_person field links to person records

SELECT TOP 10
    p.id AS student_id,
    p.first AS student_first,
    p.last AS student_last,
    adv_entity.id AS advisor_entity_id,
    adv_field.field AS field_name,
    adv_field.value AS field_value,
    adv_field.related AS field_related,
    adv_person.first AS advisor_first,
    adv_person.last AS advisor_last
FROM [person] p
INNER JOIN [entity] adv_entity ON adv_entity.record = p.id
    AND adv_entity.entity = '06d6334d-392f-4686-aaa1-ddd2e5640c2b'
INNER JOIN [field] adv_field ON adv_field.record = adv_entity.id
    AND adv_field.field = 'advisor_person'
LEFT JOIN [person] adv_person ON adv_person.id = adv_field.value
LEFT JOIN [person] adv_person2 ON adv_person2.id = adv_field.related
ORDER BY p.last, p.first
