-- Diagnostic: Find where advisor GUID exists

SELECT 'person' AS found_in, id, first, last FROM [person] WHERE id = '639b337f-1768-4788-94f9-19d4c0c134fc'
UNION ALL
SELECT 'user' AS found_in, id, first, last FROM [user] WHERE id = '639b337f-1768-4788-94f9-19d4c0c134fc'
