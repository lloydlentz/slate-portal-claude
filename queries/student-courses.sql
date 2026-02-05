-- Student Current Courses Query
-- Purpose: Get current course registrations for a student with advisor info
-- Entities:
--   Banner360 Current Registration (820d2fe3-0696-4cb6-97ec-c5cbd0cf91d0)
--   Advisor (06d6334d-392f-4686-aaa1-ddd2e5640c2b)
-- Parameter: @uid (person GUID from portal context)
-- Note: Person links use field.related, not field.value

;WITH DistinctAdvisors AS (
    SELECT DISTINCT
        adv_entity.record AS student_id,
        adv_person.first + ' ' + adv_person.last AS advisor_name
    FROM [entity] adv_entity
    INNER JOIN [field] adv_field ON adv_field.record = adv_entity.id
        AND adv_field.field = 'advisor_person'
    INNER JOIN [person] adv_person ON adv_person.id = adv_field.related
    -- Get start term
    LEFT JOIN [field] start_field ON start_field.record = adv_entity.id
        AND start_field.field = 'advisor_start'
    LEFT JOIN [lookup.prompt] start_term ON start_term.id = start_field.prompt
    -- Get stop term
    LEFT JOIN [field] stop_field ON stop_field.record = adv_entity.id
        AND stop_field.field = 'advisor_stop'
    LEFT JOIN [lookup.prompt] stop_term ON stop_term.id = stop_field.prompt
    WHERE adv_entity.entity = '06d6334d-392f-4686-aaa1-ddd2e5640c2b'
        -- Advisor has started (start term began)
        AND (start_term.export4 IS NULL OR start_term.export4 <= GETDATE())
        -- Advisor hasn't ended (stop term hasn't started yet, or no stop term)
        AND (stop_term.export4 IS NULL OR stop_term.export4 > GETDATE())
),
AggregatedAdvisors AS (
    SELECT student_id, STRING_AGG(advisor_name, ', ') AS advisors
    FROM DistinctAdvisors
    GROUP BY student_id
)
SELECT
    p.id AS student_id,
    p.first,
    p.last,
    p.email,
    display_name_field.value AS display_name,
    pronouns_prompt.value AS pronouns,
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
    aa.advisors
FROM [person] p
-- Person-scoped fields (join directly to person, not through entity)
LEFT JOIN [field] display_name_field ON display_name_field.record = p.id
    AND display_name_field.field = 'p_name_display'
LEFT JOIN [field] pronouns_field ON pronouns_field.record = p.id
    AND pronouns_field.field = 'p_pronouns'
LEFT JOIN [lookup.prompt] pronouns_prompt ON pronouns_prompt.id = pronouns_field.prompt
INNER JOIN [entity] e ON e.record = p.id
    AND e.entity = '820d2fe3-0696-4cb6-97ec-c5cbd0cf91d0'
INNER JOIN [field] f ON f.record = e.id
LEFT JOIN AggregatedAdvisors aa ON aa.student_id = p.id
WHERE p.id = @uid
GROUP BY
    p.id,
    p.first,
    p.last,
    p.email,
    display_name_field.value,
    pronouns_prompt.value,
    e.id,
    aa.advisors
ORDER BY p.last, p.first, course
