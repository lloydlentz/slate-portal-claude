-- Student Current Courses Query
-- Purpose: Get current course registrations for a student with advisor info
-- Entities:
--   Banner360 Current Registration (820d2fe3-0696-4cb6-97ec-c5cbd0cf91d0)
--   Advisor (06d6334d-392f-4686-aaa1-ddd2e5640c2b)
-- Parameter: @uid (person GUID from portal context)
-- Note: Person links use field.related, not field.value

SELECT
    p.id AS student_id,
    p.first,
    p.last,
    p.email,
    e.id AS registration_id,
    MAX(CASE WHEN f.field = 'b360_curreg_course' THEN f.value END) AS course,
    MAX(CASE WHEN f.field = 'b360_curreg_course_title' THEN f.value END) AS course_title,
    MAX(CASE WHEN f.field = 'b360_curreg_credits' THEN f.value END) AS credits,
    MAX(CASE WHEN f.field = 'b360_curreg_days' THEN f.value END) AS days,
    MAX(CASE WHEN f.field = 'b360_curreg_time' THEN f.value END) AS time,
    MAX(CASE WHEN f.field = 'b360_curreg_location' THEN f.value END) AS location,
    MAX(CASE WHEN f.field = 'b360_curreg_instructor' THEN f.value END) AS instructor,
    MAX(CASE WHEN f.field = 'b360_curreg_grade' THEN f.value END) AS grade,
    MAX(CASE WHEN f.field = 'b360_curreg_term' THEN f.value END) AS term,
    MAX(CASE WHEN f.field = 'b360_curreg_reg_status' THEN f.value END) AS reg_status,
    STRING_AGG(DISTINCT adv_person.first + ' ' + adv_person.last, ', ') AS advisors
FROM [person] p
INNER JOIN [entity] e ON e.record = p.id
    AND e.entity = '820d2fe3-0696-4cb6-97ec-c5cbd0cf91d0'
INNER JOIN [field] f ON f.record = e.id
-- Join to Advisor entity (person link is in field.related)
LEFT JOIN [entity] adv_entity ON adv_entity.record = p.id
    AND adv_entity.entity = '06d6334d-392f-4686-aaa1-ddd2e5640c2b'
LEFT JOIN [field] adv_field ON adv_field.record = adv_entity.id
    AND adv_field.field = 'advisor_person'
LEFT JOIN [person] adv_person ON adv_person.id = adv_field.related
WHERE p.id = @uid
GROUP BY
    p.id,
    p.first,
    p.last,
    p.email,
    e.id
ORDER BY p.last, p.first, course
