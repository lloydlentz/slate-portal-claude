-- Discover Portal Configuration Tables
-- Purpose: Find tables that store portal Views/Methods/Queries

-- Check for portal-related tables in schema
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND (
    TABLE_NAME LIKE '%portal%'
    OR TABLE_NAME LIKE '%view%'
    OR TABLE_NAME LIKE '%method%'
  )
ORDER BY TABLE_NAME;
