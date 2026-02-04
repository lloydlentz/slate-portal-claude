-- Schema Discovery Script for Slate
-- Purpose: Returns table and column metadata to understand data structure
-- Usage: Create as a Slate Query, expose via Method, return as JSON

-- Option 1: Full schema with column details
-- Try this first - gives complete picture of available tables and columns
SELECT
    t.TABLE_SCHEMA,
    t.TABLE_NAME,
    c.COLUMN_NAME,
    c.DATA_TYPE,
    c.CHARACTER_MAXIMUM_LENGTH,
    c.IS_NULLABLE,
    c.COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.TABLES t
INNER JOIN INFORMATION_SCHEMA.COLUMNS c
    ON t.TABLE_NAME = c.TABLE_NAME
    AND t.TABLE_SCHEMA = c.TABLE_SCHEMA
WHERE t.TABLE_TYPE = 'BASE TABLE'
ORDER BY t.TABLE_SCHEMA, t.TABLE_NAME, c.ORDINAL_POSITION;


-- Option 2: Table names only (if Option 1 is blocked)
-- Simpler query that may have fewer permission issues
/*
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;
*/


-- Option 3: Probe common Slate entities (if INFORMATION_SCHEMA is restricted)
-- Uncomment individual lines to test which tables are accessible
/*
SELECT TOP 10 * FROM person;
SELECT TOP 10 * FROM application;
SELECT TOP 10 * FROM record;
SELECT TOP 10 * FROM form;
SELECT TOP 10 * FROM event;
SELECT TOP 10 * FROM organization;
*/
