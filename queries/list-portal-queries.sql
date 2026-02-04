-- List Portal Queries
-- Purpose: Get all queries associated with a portal (via methods)
-- Returns: Query IDs and method associations for deployment automation

SELECT
    pm.id AS method_id,
    pm.action AS method_action,
    pm.title AS method_title,
    pmq.query_id
FROM [portal.method] pm
INNER JOIN [portal.method.query] pmq ON pmq.method_id = pm.id
WHERE pm.portal = 'a9e0b17b-7208-4a6c-b7f4-7b9a1c5540cd'
ORDER BY pm.action
