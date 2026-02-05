-- Diagnostic: Check person-scoped fields for Ahmed Abdelhai

SELECT
    f.field AS field_name,
    f.value AS field_value,
    f.prompt AS field_prompt,
    lp.value AS prompt_display_value
FROM [field] f
LEFT JOIN [lookup.prompt] lp ON lp.id = f.prompt
WHERE f.record = '52ede6c5-7212-4db1-87b4-93f6fb1cb5d2'
  AND f.field IN ('p_name_display', 'p_pronouns')
ORDER BY f.field