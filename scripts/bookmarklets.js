/**
 * Slate Portal Bookmarklets
 *
 * Instructions:
 * 1. Create a new bookmark in your browser
 * 2. Copy the ENTIRE bookmarklet code (starting with "javascript:")
 * 3. Paste as the bookmark URL
 * 4. Click the bookmark while on Slate admin pages
 */

// =============================================================================
// LOAD DEPLOYER (just loads the script, then use console commands)
// =============================================================================

javascript:fetch('https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js').then(r=>r.text()).then(eval).then(()=>alert('SlateDeployer loaded!'))

// =============================================================================
// DEPLOY ALL (queries + views)
// =============================================================================

javascript:fetch('https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js').then(r=>r.text()).then(eval).then(()=>SlateDeployer.deployAllQueries()).then(()=>SlateDeployer.deployAllViews()).then(()=>alert('All deployed!'))

// =============================================================================
// DEPLOY ALL QUERIES
// =============================================================================

javascript:fetch('https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js').then(r=>r.text()).then(eval).then(()=>SlateDeployer.deployAllQueries()).then(()=>alert('Queries deployed!'))

// =============================================================================
// DEPLOY ALL VIEWS
// =============================================================================

javascript:fetch('https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js').then(r=>r.text()).then(eval).then(()=>SlateDeployer.deployAllViews()).then(()=>alert('Views deployed!'))

// =============================================================================
// DEPLOY: student-courses query
// =============================================================================

javascript:fetch('https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js').then(r=>r.text()).then(eval).then(()=>SlateDeployer.deployQuerySQL('student-courses')).then(()=>alert('student-courses deployed!'))

// =============================================================================
// DEPLOY: list-students query
// =============================================================================

javascript:fetch('https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js').then(r=>r.text()).then(eval).then(()=>SlateDeployer.deployQuerySQL('list-students')).then(()=>alert('list-students deployed!'))

// =============================================================================
// DEPLOY: list-entity-fields query
// =============================================================================

javascript:fetch('https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js').then(r=>r.text()).then(eval).then(()=>SlateDeployer.deployQuerySQL('list-entity-fields')).then(()=>alert('list-entity-fields deployed!'))

// =============================================================================
// DEPLOY: student-list view
// =============================================================================

javascript:fetch('https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js').then(r=>r.text()).then(eval).then(()=>SlateDeployer.deployView('student-list')).then(()=>alert('student-list view deployed!'))

// =============================================================================
// DEPLOY: student-courses view
// =============================================================================

javascript:fetch('https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js').then(r=>r.text()).then(eval).then(()=>SlateDeployer.deployView('student-courses')).then(()=>alert('student-courses view deployed!'))
