-- List Portal Queries
-- Purpose: Get all queries associated with a portal
-- Returns: Query IDs, names, and configuration for deployment automation

SELECT
    p.id AS portal_id,
    p.name AS portal_name,
    pq.query_id,
    pq.type AS query_type,
    lq.id AS lookup_query_id,
    lq.name AS query_name,
    lq.node AS output_node,
    lq.active AS query_active,
    lq.memo AS query_memo
FROM [portal] p
INNER JOIN [portal.query] pq ON pq.portal_id = p.id
INNER JOIN [lookup.query] lq ON lq.id = pq.query_id
WHERE p.id = 'a9e0b17b-7208-4a6c-b7f4-7b9a1c5540cd'  -- TEST - Claude Code a Portal
ORDER BY lq.name
