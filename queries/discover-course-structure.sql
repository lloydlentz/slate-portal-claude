-- Discovery Query 1: Find all entity definitions
-- Purpose: Identify the entity type used for courses/registrations
SELECT
    id,
    name,
    active
FROM [lookup.entity]
WHERE active = 1
ORDER BY name;


-- Discovery Query 2: Find fields that belong to entities
-- Purpose: See which fields are defined for each entity type
SELECT
    lf.id AS field_id,
    lf.name AS field_name,
    lf.prompt,
    lf.type,
    lf.entity,
    le.name AS entity_name
FROM [lookup.field] lf
LEFT JOIN [lookup.entity] le ON le.id = lf.entity
WHERE lf.entity IS NOT NULL
  AND lf.active = 1
ORDER BY le.name, lf.name;


-- Discovery Query 3: Sample entity instances for a person
-- Purpose: See what entities exist and how they link to person
SELECT TOP 50
    e.id AS entity_instance_id,
    e.record AS person_id,
    e.entity AS entity_type_id,
    le.name AS entity_name,
    e.created,
    e.external_id
FROM [entity] e
INNER JOIN [lookup.entity] le ON le.id = e.entity
ORDER BY e.created DESC;


-- Discovery Query 4: Sample field values for entities
-- Purpose: See how field data is stored for entity instances
SELECT TOP 100
    f.id,
    f.field AS field_id,
    lf.name AS field_name,
    f.value,
    f.record AS entity_instance_id,
    e.entity AS entity_type_id,
    le.name AS entity_name
FROM [field] f
INNER JOIN [entity] e ON e.id = f.record
INNER JOIN [lookup.entity] le ON le.id = e.entity
LEFT JOIN [lookup.field] lf ON lf.id = f.field
ORDER BY f.timestamp DESC;


-- Discovery Query 5: Find course-related field definitions
-- Purpose: Narrow down which fields store course data
SELECT
    lf.id AS field_id,
    lf.name AS field_name,
    lf.prompt,
    lf.type,
    lf.entity,
    le.name AS entity_name
FROM [lookup.field] lf
LEFT JOIN [lookup.entity] le ON le.id = lf.entity
WHERE lf.active = 1
  AND (
    lf.id LIKE '%course%'
    OR lf.name LIKE '%course%'
    OR lf.id LIKE '%registration%'
    OR lf.name LIKE '%registration%'
    OR lf.id LIKE '%section%'
    OR lf.name LIKE '%section%'
    OR lf.id LIKE '%enroll%'
    OR lf.name LIKE '%enroll%'
  )
ORDER BY le.name, lf.name;
