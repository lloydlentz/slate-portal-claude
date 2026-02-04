# Slate Portal Development HOWTO

## Quick Reference

### Deploy a View to Slate

1. Log into Slate admin: https://student.macalester.edu/manage/
2. Open browser console (F12 → Console)
3. Paste contents of `scripts/deploy-view.js`
4. Run:
   ```javascript
   SlateDeployer.deployView('student-courses')
   ```

### Available Commands

```javascript
SlateDeployer.listViews()              // List available views
SlateDeployer.deployView('view-name')  // Deploy a specific view
SlateDeployer.deployAll()              // Deploy all views
```

---

## Development Workflow

### 1. Create/Edit a Query

1. Write SQL in `queries/your-query.sql`
2. Test in Slate Query Builder (paste SQL)
3. Update `slate-config.json` with query metadata

### 2. Create a Method

1. In Slate: Create Method pointing to your Query
2. Set: Name, Action, Type (GET), Output (JSON)
3. Update `slate-config.json` with method metadata
4. Test endpoint: `https://student.macalester.edu/portal/test-claude-code-portal?cmd=your-action`

### 3. Create a View

1. Write HTML/CSS/JS in `views/your-view.html`
2. Follow scoping rules:
   - CSS: `.portal-your-view { ... }`
   - JS: `SlatePortal.YourView = { ... }`
3. Create View in Slate UI (initial deployment)
4. Run `list-portal-parts` to get Slate IDs
5. Add view config to `scripts/deploy-view.js`
6. Commit and push to GitHub
7. Use `SlateDeployer.deployView()` for future updates

### 4. Fetch Data from Methods

Views fetch data via AJAX:
```javascript
fetch('?cmd=your-method')
    .then(r => r.json())
    .then(data => { /* render data.row */ });
```

---

## Adding a New View to the Deployer

After creating a view in Slate, get its IDs:

```javascript
// Fetch from the list-portal-parts endpoint
fetch('?cmd=list-portal-parts')
    .then(r => r.json())
    .then(d => console.log(d.row));
```

Add to `scripts/deploy-view.js`:

```javascript
views: {
    'your-view-name': {
        sourceFile: 'views/your-view.html',
        part_id: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
        view_id: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
        base: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
        type: 'html',
        name: 'your-view-name'
    }
}
```

---

## Project Structure

```
slate-portal-claude/
├── .site/
│   ├── CONTEXT.md          # Slate platform constraints
│   ├── WORKFLOW.md         # Development process
│   ├── HOWTO.md            # This file
│   └── data/               # Cached schema and metadata
├── queries/                # SQL source files
├── views/                  # HTML/CSS/JS view files
├── scripts/
│   └── deploy-view.js      # Browser deployment script
├── slate-config.json       # Portal inventory
└── CLAUDE.md               # Claude Code guidance
```

---

## Troubleshooting

### "Unsupported method" error
- Verify Method exists in Slate with correct action name
- Check Method is set to Active
- Ensure Query is attached to Method

### SQL syntax errors
- Escape reserved words: `[key]`, `[view]`, `[order]`, `[column]`, `[row]`
- Use `[schema.table]` format for table names

### Deployment script fails
- Ensure you're logged into Slate admin (not portal)
- Check browser console for CORS errors
- Verify GitHub repo is public (for raw file access)

### View not updating
- Clear browser cache
- Check Slate's view cache (may need to toggle Active off/on)
- Verify the part_id matches the correct widget
