-- Diagnostic: Check advisor for specific student (Ahmed Abdelhai)
-- Student ID: 52ede6c5-7212-4db1-87b4-93f6fb1cb5d2

SELECT
    p.id AS student_id,
    p.first AS student_first,
    p.last AS student_last,
    adv_entity.id AS advisor_entity_id,
    adv_entity.entity AS entity_guid,
    adv_field.field AS field_name,
    adv_field.value AS field_value,
    adv_field.related AS field_related,
    adv_person.id AS advisor_id,
    adv_person.first AS advisor_first,
    adv_person.last AS advisor_last
FROM [person] p
LEFT JOIN [entity] adv_entity ON adv_entity.record = p.id
    AND adv_entity.entity = '06d6334d-392f-4686-aaa1-ddd2e5640c2b'
LEFT JOIN [field] adv_field ON adv_field.record = adv_entity.id
    AND adv_field.field = 'advisor_person'
LEFT JOIN [person] adv_person ON adv_person.id = adv_field.related
WHERE p.id = '52ede6c5-7212-4db1-87b4-93f6fb1cb5d2'
