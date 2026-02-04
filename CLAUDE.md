# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Technolutions Slate CRM Portal** project for Macalester College. It is NOT a traditional web application - all code runs within Slate's constrained portal framework.

## Slate Architecture (Not Real MVC)

| Slate Term | Purpose | Notes |
|------------|---------|-------|
| **Query** | Data retrieval | Limited SQL dialect, read-only |
| **Method** | HTTP endpoints | Return JSON or HTML |
| **View** | Presentation | HTML + Liquid + JS + CSS |

- Liquid executes **server-side before render**
- JavaScript executes **client-side after render**
- Views are injected into a shared DOM
- No server session; state via URL params + JS

## Hard Constraints

### Cannot Use
- No Node/PHP/Python/backend services
- No filesystem access or package managers
- No build tools or ES modules
- No control over `<head>` or global DOM
- No full SQL (limited CTEs, no custom functions/indexes)

### Can Use
- HTML, scoped CSS, client-side JavaScript
- jQuery (usually available)
- Fetch/AJAX to Slate Methods
- Liquid for light templating only

## Development Workflow

- **Source of truth:** Local Git repository
- **Deployment:** Copy/paste code into Slate UI
- **Debugging:** `console.log`, temporary debug output, Query previews

## Code Guidelines

### CSS
Scope all CSS under a root class to avoid conflicts in shared environment:
```css
.portal-<project-slug> { ... }
```
Avoid global selectors (`body`, `h1`, `a`).

### JavaScript
- Namespace everything (e.g., `SlatePortal.App`)
- Use IIFEs or closures (no ES modules)
- Re-bind events after AJAX content loads
- Assume partial page reloads

### Liquid
Use for structure and light conditioning only. Complex logic belongs in Queries or JavaScript.

### Queries
- Prefer pre-aggregated queries and configurable joins
- Avoid correlated subqueries, repeated `getFieldTopTable()` calls, heavy XML parsing
- Keep result sets small

## Performance Pattern

1. Minimal initial render
2. AJAX fetch for heavy data
3. Progressive enhancement

Never "load everything then filter" - Slate portals fail silently when overloaded.

## Security

- Access control is enforced by Queries
- Never rely on client-side filtering for PI data
- Views must not assume role visibility
