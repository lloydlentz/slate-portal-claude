-- List Portal Queries
-- Purpose: Get all queries associated with a portal (via methods)
-- Returns: Query IDs, names, and configuration for deployment automation

SELECT
    p.id AS portal_id,
    p.name AS portal_name,
    pm.id AS method_id,
    pm.action AS method_action,
    pm.title AS method_title,
    pmq.query_id,
    lq.id AS lookup_query_id,
    lq.name AS query_name,
    lq.active AS query_active,
    lq.memo AS query_memo
FROM [portal] p
INNER JOIN [portal.method] pm ON pm.portal = p.id
INNER JOIN [portal.method.query] pmq ON pmq.method_id = pm.id
INNER JOIN [lookup.query] lq ON lq.id = pmq.query_id
WHERE p.id = 'a9e0b17b-7208-4a6c-b7f4-7b9a1c5540cd'  -- TEST - Claude Code a Portal
ORDER BY pm.action, lq.name
