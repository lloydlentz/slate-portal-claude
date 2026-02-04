-- List Portal View Parts
-- Purpose: Get metadata needed for automated view updates
-- Returns: IDs required for POST to /manage/database/portal/widget/html

SELECT
    p.id AS portal_id,
    p.name AS portal_name,
    p.[key] AS portal_key,
    v.id AS view_id,
    v.name AS view_name,
    v.[key] AS view_key,
    pt.id AS part_id,
    pt.name AS part_name,
    pt.type AS part_type,
    pt.[view] AS part_view,
    pt.base AS part_base,
    pt.active AS part_active,
    pt.[column] AS part_column,
    pt.[row] AS part_row,
    pt.[order] AS part_order
FROM [portal] p
INNER JOIN [portal.view] v ON v.portal = p.id
INNER JOIN [portal.part] pt ON pt.[view] = v.id
WHERE p.id = 'a9e0b17b-7208-4a6c-b7f4-7b9a1c5540cd'  -- TEST - Claude Code a Portal
ORDER BY v.name, pt.[order]
