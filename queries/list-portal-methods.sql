-- List Portal Methods (diagnostic)
-- Purpose: See all methods and their query associations via method.query table

SELECT
    pm.id AS method_id,
    pm.action,
    pmq.query_id
FROM [portal.method] pm
LEFT JOIN [portal.method.query] pmq ON pmq.method_id = pm.id
WHERE pm.portal = 'a9e0b17b-7208-4a6c-b7f4-7b9a1c5540cd'
ORDER BY pm.action
