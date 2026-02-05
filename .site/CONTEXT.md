---

# CONTEXT.md

## Technolutions Slate CRM – Portal Project

---

## 1. Project Overview

**Project Name:** `<Portal Name>`
**Institution:** `Macalester College`
**Platform:** Technolutions Slate CRM
**Project Type:** Slate Portal (Queries + Methods + Views)

This project is built entirely within the **Slate CRM Portal framework**.
It is **not** a traditional web application and does **not** run on infrastructure we control.

All generated solutions **must respect Slate’s architectural constraints**.

---

## 2. Architectural Reality (Slate ≠ Real MVC)

Slate loosely resembles MVC, but the terminology and capabilities are different:

| Traditional MVC | Slate Term        | Notes                                 |
| --------------- | ----------------- | ------------------------------------- |
| Controller      | **Method**        | HTTP endpoints; return JSON or HTML   |
| Model           | **Query**         | Read-only data retrieval; limited SQL |
| View            | **View**          | HTML + Liquid + JS + CSS              |
| Router          | Portal Navigation | GUID-based, implicit                  |
| State           | URL params + JS   | No server session                     |

**Key Clarifications**

* Methods are *not* reusable controllers
* Queries are *not* full SQL models
* Views are injected into a shared DOM
* Liquid executes **server-side before render**
* JavaScript executes **client-side after render**

---

## 3. Hard Constraints (Non-Negotiable)

### Backend

* ❌ No Node / PHP / Python
* ❌ No filesystem access
* ❌ No package manager
* ❌ No server-side custom code
* ❌ No background jobs

### Frontend

* ✅ HTML
* ✅ CSS (scoped)
* ✅ JavaScript (client-side only)
* ✅ jQuery (usually available)
* ⚠️ Shared global DOM and styles

### Data

* Queries are defined in Slate
* Methods expose Queries as endpoints
* Views consume Query output or Method responses

---

## 4. Slate Query Engine Constraints

**SQL Reality**

* Limited SQL dialect
* No guaranteed CTE support
* Expensive subqueries
* Cannot add indexes
* Cannot create functions
* Joins must be explicit and minimal

**Best Practices**

* Prefer:

  * Pre-aggregated queries
  * Materialized views (where appropriate)
  * Configurable Joins
* Avoid:

  * Correlated subqueries
  * Repeated `getFieldTopTable()` calls
  * Heavy XML parsing
  * Large result sets

**Output**

* Queries return:

  * Liquid variables (e.g., `{{items}}`)
  * JSON via Methods

**Query Parameters**

Parameters allow queries to accept dynamic values from the portal context.

* **Defining Parameters:** In the Query's config, set:
  * Output Node: `row` (or your preferred node name)
  * Parameters: `<param id="uid" />` (XML format)

* **Using Parameters in SQL:** Reference with `@` prefix:
  ```sql
  WHERE p.id = @uid
  ```

* **Reserved Parameters (automatically available):**
  * `@identity` - The person ID of the logged-in user
  * `@id` - Reserved parameter (context-dependent)

* **Custom Parameters:** Define via `<param id="name" />` and pass via URL or portal context

**Example:**
```sql
-- Query with @identity parameter (no config needed)
SELECT * FROM [person] WHERE id = @identity

-- Query with custom @uid parameter (requires <param id="uid" />)
SELECT * FROM [person] WHERE id = @uid
```

---

## 5. Slate Data Model & Query Patterns

### Core Data Structure

Slate uses a flexible Entity-Attribute-Value (EAV) model:

```
[person] → [entity] → [field] → (value | related | prompt)
```

**Join Pattern:**
```sql
FROM [person] p
INNER JOIN [entity] e ON e.record = p.id AND e.entity = '<entity-guid>'
INNER JOIN [field] f ON f.record = e.id
```

### Field Value Types

The `[field]` table stores data in three different columns depending on the field type:

| Column | Use Case | Example |
|--------|----------|---------|
| `field.value` | Direct values (text, numbers, booleans) | `advisor_is_primary = "1"` |
| `field.related` | Person/record references (GUIDs) | `advisor_person` → person.id |
| `field.prompt` | Lookup values (term, status codes) | `advisor_start` → lookup.prompt.id |

**Important:** Always check which column a field uses. Person link fields use `field.related`, NOT `field.value`.

### Joining Person References

When a field references another person (e.g., advisor → person):

```sql
-- Get advisor name from a person-link field
INNER JOIN [field] adv_field ON adv_field.record = e.id
    AND adv_field.field = 'advisor_person'
INNER JOIN [person] adv_person ON adv_person.id = adv_field.related
```

### Lookup Prompt Values (Terms, Status Codes)

Fields with type "term" or similar store a GUID in `field.prompt` that references `[lookup.prompt]`:

**lookup.prompt Structure:**
| Column | Description |
|--------|-------------|
| `id` | GUID (stored in field.prompt) |
| `key` | Category ("term", etc.) |
| `value` | Display name ("Fall 2025", "Spring 2026") |
| `export` | Numeric sort order |
| `export2` | Year |
| `export4` | Start date (YYYY-MM-DD) |
| `export5` | End date (YYYY-MM-DD) |
| `active` | Status flag |

**Joining to get term dates:**
```sql
LEFT JOIN [field] start_field ON start_field.record = e.id
    AND start_field.field = 'advisor_start'
LEFT JOIN [lookup.prompt] start_term ON start_term.id = start_field.prompt
```

### Filtering by Date Ranges (e.g., Current Advisors)

To filter for "current" records based on term dates:

```sql
WHERE
    -- Has started (start term date <= today)
    (start_term.export4 IS NULL OR start_term.export4 <= GETDATE())
    -- Hasn't ended (stop term date > today, or no stop term)
    AND (stop_term.export4 IS NULL OR stop_term.export4 > GETDATE())
```

### Aggregating Multiple Values

Use `STRING_AGG` for combining multiple related records. Note: T-SQL does not support `DISTINCT` inside `STRING_AGG`, so use a CTE:

```sql
;WITH DistinctValues AS (
    SELECT DISTINCT
        parent.id AS parent_id,
        child.name AS child_name
    FROM [parent]
    INNER JOIN [child] ON ...
),
AggregatedValues AS (
    SELECT parent_id, STRING_AGG(child_name, ', ') AS children
    FROM DistinctValues
    GROUP BY parent_id
)
SELECT p.*, av.children
FROM [parent] p
LEFT JOIN AggregatedValues av ON av.parent_id = p.id
```

### Entity GUIDs (Project-Specific)

Document your entity GUIDs for reference:

```
-- Example entity GUIDs (replace with your actual values)
-- Banner360 Current Registration: 820d2fe3-0696-4cb6-97ec-c5cbd0cf91d0
-- Advisor: 06d6334d-392f-4686-aaa1-ddd2e5640c2b
```

### Discovering Field Names

Use `[lookup.field]` to find available fields for an entity:

```sql
SELECT id, name, type, prompt
FROM [lookup.field]
WHERE entity = '<entity-guid>'
  AND active = 1
ORDER BY name
```

Field types:
- `X` = Cross-reference (person link, uses `field.related`)
- `term` = Term lookup (uses `field.prompt`)
- `bit` = Boolean (uses `field.value`)
- `date` = Date (uses `field.value`)

---

## 6. Liquid Markup (Use Carefully)

**Liquid Is Limited**

* `for`, `if`, `assign`
* Basic filters (`map`, `uniq`, `size`)
* Simple string handling

**Liquid Cannot**

* Define functions
* Perform complex logic
* Reliably group data
* Handle advanced date math

**Rule**

> Liquid is for **structure and light conditioning only**.
> All real logic belongs in Queries or JavaScript.

---

## 7. JavaScript Environment

**Allowed**

* Vanilla JS
* jQuery
* Fetch / AJAX to Slate Methods

**Risky / Discouraged**

* ES modules
* Build steps
* React / Vue (unless fully isolated)
* Global selectors or globals

**Guidelines**

* Namespace everything (e.g., `SlatePortal.App`)
* Use IIFEs or modules via closures
* Bind events defensively
* Re-bind after AJAX content loads
* Assume partial page reloads

---

## 8. CSS Rules

Slate portals run in a **shared CSS environment**.

**Rules**

* Scope all CSS under a root class:

  ```css
  .portal-<project-slug> { ... }
  ```
* Avoid global selectors (`body`, `h1`, `a`)
* Do not assume Bootstrap version (or presence)
* Prefer utility classes and explicit selectors

---

## 9. Navigation & State

**Identity**

* Views are identified by GUIDs
* URLs are not stable or semantic

**State Management**

* URL parameters
* Hidden inputs
* JavaScript state objects

**Security**

* Access control is enforced by Queries
* Views must not assume role visibility
* Never rely on client-side filtering for PI data

---

## 10. Performance Expectations

Slate portals fail silently when overloaded.

**Rules**

* Do not load unnecessary data on page load
* Methods must be idempotent
* Lazy-load secondary content
* Avoid “load everything then filter”

**Preferred Pattern**

1. Minimal initial render
2. AJAX fetch for heavy data
3. Progressive enhancement

---

## 11. Development Workflow

**Source of Truth**

* Local Git repository
* Slate UI is a deployment target only

**Editing**

* Code written externally
* Pasted into Slate Views / Methods
* No built-in diffing or version history

**Debugging**

* `console.log`
* Temporary debug output
* Query previews

---

## 12. UX & Design Principles

This portal prioritizes:

* Maintainability over cleverness
* Clear data ownership
* Configurable joins over hard-coded logic
* Readable, commented code
* Explicit empty and error states
* Mobile-friendly layouts
* Accessible markup

---

## 13. Explicit "Do Not Do" List

The following are **not allowed** in generated solutions:

* ❌ Inventing backend services
* ❌ Assuming real MVC routing
* ❌ Assuming full SQL support
* ❌ Assuming build tools
* ❌ Assuming control over `<head>` or global DOM
* ❌ Heavy Liquid logic
* ❌ Client-side security assumptions

---

## 14. Instruction to the Code Generator

> You are assisting with a Technolutions Slate CRM Portal project.
> All solutions must fit within Slate’s Portal framework and its limitations.
> Optimize for maintainability, performance, and long-term administrative support.
> When uncertain, choose the simpler, more explicit solution.
