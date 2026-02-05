-- Diagnostic: List users to see what's in the user table

SELECT TOP 5
    id,
    first,
    last,
    email
FROM [user]
ORDER BY last, first
