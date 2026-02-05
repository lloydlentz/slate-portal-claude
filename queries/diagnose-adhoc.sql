-- Diagnostic: Check if advisor GUIDs exist in user table
-- Test with known advisor ID from previous results

SELECT TOP 1 *
FROM [user]
WHERE id = '639b337f-1768-4788-94f9-19d4c0c134fc'
