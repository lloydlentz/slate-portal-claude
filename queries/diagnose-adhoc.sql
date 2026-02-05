-- Diagnostic: Check if advisor GUIDs exist in person table
-- Test with known advisor ID from previous results

SELECT
    p.id,
    p.first,
    p.last,
    p.email
FROM [person] p
WHERE p.id = '639b337f-1768-4788-94f9-19d4c0c134fc'
