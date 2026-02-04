# Slate Portal Development Workflow

## Project Structure

```
slate-portal-claude/
├── .site/
│   ├── CONTEXT.md          # Slate platform constraints
│   ├── WORKFLOW.md         # This file - development process
│   └── data/
│       └── schema.json     # Database schema snapshot
├── queries/                # SQL source files
├── views/                  # HTML/Liquid/JS source files
├── methods/                # Method configurations (if needed)
├── slate-config.json       # Portal inventory (queries, methods, views)
└── CLAUDE.md               # Claude Code guidance
```

## Development Cycle

### 1. Define Requirements
Document what you're building in a requirements file or describe it to Claude.

### 2. Explore Schema
Reference `.site/data/schema.json` to find relevant tables and columns.

**Key schemas:**
- `build.*` - Custom/institution-specific tables
- `dbo.*` - Core Slate tables

### 3. Write Query
Create SQL in `queries/` folder. Follow Slate SQL constraints:
- Limited SQL dialect
- Avoid correlated subqueries
- Keep result sets small
- Use configurable joins

### 4. Test in Slate
1. Create Query in Slate UI (paste from local file)
2. Use Query Preview to validate results
3. Update `slate-config.json` with query metadata

### 5. Create Method (if API access needed)
1. Create Method in Slate UI pointing to Query
2. Test endpoint: `{{baseUrl}}portal/{{slug}}?cmd={{action}}`
3. Update `slate-config.json` with method metadata

### 6. Build View (if UI needed)
1. Write HTML/Liquid/JS in `views/` folder
2. Paste into Slate View
3. Update `slate-config.json` with view metadata

## Query Development Pattern

```sql
-- queries/my-feature.sql
-- Purpose: [What this query does]
-- Tables: [Which tables it uses]
-- Parameters: [Any expected parameters]

SELECT ...
FROM build.my_table
WHERE ...
```

## Asking Claude to Build Queries

Provide:
1. **Goal** - What data do you need?
2. **Context** - Which tables are relevant? (reference schema.json)
3. **Output** - How will this be used? (View, Method, export)
4. **Filters** - Any required parameters or conditions?

Example:
> "Build a query to show all students with their advisors.
> Use the build.advising_student_search table.
> Output as JSON via Method for a dashboard View."
