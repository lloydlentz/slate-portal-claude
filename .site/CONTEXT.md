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

---

## 5. Liquid Markup (Use Carefully)

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

## 6. JavaScript Environment

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

## 7. CSS Rules

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

## 8. Navigation & State

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

## 9. Performance Expectations

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

## 10. Development Workflow

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

## 11. UX & Design Principles

This portal prioritizes:

* Maintainability over cleverness
* Clear data ownership
* Configurable joins over hard-coded logic
* Readable, commented code
* Explicit empty and error states
* Mobile-friendly layouts
* Accessible markup

---

## 12. Explicit “Do Not Do” List

The following are **not allowed** in generated solutions:

* ❌ Inventing backend services
* ❌ Assuming real MVC routing
* ❌ Assuming full SQL support
* ❌ Assuming build tools
* ❌ Assuming control over `<head>` or global DOM
* ❌ Heavy Liquid logic
* ❌ Client-side security assumptions

---

## 13. Instruction to the Code Generator

> You are assisting with a Technolutions Slate CRM Portal project.
> All solutions must fit within Slate’s Portal framework and its limitations.
> Optimize for maintainability, performance, and long-term administrative support.
> When uncertain, choose the simpler, more explicit solution.
