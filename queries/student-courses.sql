-- Student Current Courses Query
-- Purpose: Get current course registrations for a student
-- Entity: SSIS - Banner360 - Current Registration (820d2fe3-0696-4cb6-97ec-c5cbd0cf91d0)
-- Pattern: person >> entity >> field
-- Parameter: @uid (person GUID from portal context)

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
    MAX(CASE WHEN f.field = 'b360_curreg_reg_status' THEN f.value END) AS reg_status
FROM [person] p
INNER JOIN [entity] e ON e.record = p.id
    AND e.entity = '820d2fe3-0696-4cb6-97ec-c5cbd0cf91d0'
INNER JOIN [field] f ON f.record = e.id
WHERE p.id = @uid
GROUP BY
    p.id,
    p.first,
    p.last,
    p.email,
    e.id
ORDER BY p.last, p.first, course
