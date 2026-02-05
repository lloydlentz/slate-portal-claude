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

javascript:(function(){var s=document.createElement('script');s.src='https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js?t='+Date.now();s.onload=function(){console.log('SlateDeployer loaded')};document.body.appendChild(s)})();

// =============================================================================
// DEPLOY ALL (queries + views)
// =============================================================================

javascript:(function(){var s=document.createElement('script');s.src='https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js?t='+Date.now();s.onload=function(){SlateDeployer.deployAllQueries().then(function(){return SlateDeployer.deployAllViews()}).then(function(){alert('All deployed!')})};document.body.appendChild(s)})();

// =============================================================================
// DEPLOY ALL QUERIES
// =============================================================================

javascript:(function(){var s=document.createElement('script');s.src='https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js?t='+Date.now();s.onload=function(){SlateDeployer.deployAllQueries().then(function(){alert('Queries deployed!')})};document.body.appendChild(s)})();

// =============================================================================
// DEPLOY ALL VIEWS
// =============================================================================

javascript:(function(){var s=document.createElement('script');s.src='https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js?t='+Date.now();s.onload=function(){SlateDeployer.deployAllViews().then(function(){alert('Views deployed!')})};document.body.appendChild(s)})();

// =============================================================================
// DEPLOY: student-courses query
// =============================================================================

javascript:(function(){var s=document.createElement('script');s.src='https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js?t='+Date.now();s.onload=function(){SlateDeployer.deployQuerySQL('student-courses').then(function(){alert('student-courses deployed!')})};document.body.appendChild(s)})();

// =============================================================================
// DEPLOY: list-students query
// =============================================================================

javascript:(function(){var s=document.createElement('script');s.src='https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js?t='+Date.now();s.onload=function(){SlateDeployer.deployQuerySQL('list-students').then(function(){alert('list-students deployed!')})};document.body.appendChild(s)})();

// =============================================================================
// DEPLOY: list-entity-fields query
// =============================================================================

javascript:(function(){var s=document.createElement('script');s.src='https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js?t='+Date.now();s.onload=function(){SlateDeployer.deployQuerySQL('list-entity-fields').then(function(){alert('list-entity-fields deployed!')})};document.body.appendChild(s)})();

// =============================================================================
// DEPLOY: student-list view
// =============================================================================

javascript:(function(){var s=document.createElement('script');s.src='https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js?t='+Date.now();s.onload=function(){SlateDeployer.deployView('student-list').then(function(){alert('student-list view deployed!')})};document.body.appendChild(s)})();

// =============================================================================
// DEPLOY: student-courses view
// =============================================================================

javascript:(function(){var s=document.createElement('script');s.src='https://raw.githubusercontent.com/lloydlentz/slate-portal-claude/main/scripts/deploy-view.js?t='+Date.now();s.onload=function(){SlateDeployer.deployView('student-courses').then(function(){alert('student-courses view deployed!')})};document.body.appendChild(s)})();
