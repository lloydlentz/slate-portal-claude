-- Diagnostic: Check if advisor GUID exists in relationship table

SELECT TOP 100 p.id AS student_id,
    p.first,
    p.last,
    adv.id AS advisor_id,
    adv.first AS advisor_first,
    adv.last AS advisor_last
FROM [person] p
join [entity] e on e.record = p.id
join [field] f on f.record = e.id and f.field = 'advisor_person'
join [person] adv on adv.id = f.related
WHERE e.entity = '06d6334d-392f-4686-aaa1-ddd2e5640c2b'