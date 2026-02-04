/**
 * Slate Portal Deployment Script
 *
 * Usage: Run in browser console while logged into Slate admin
 *
 * 1. Log into Slate admin (https://student.macalester.edu/manage/)
 * 2. Open browser console (F12 > Console)
 * 3. Paste and run this script
 * 4. Call commands (see help at bottom)
 */

window.SlateDeployer = (function() {
    'use strict';

    // Configuration - maps names to Slate IDs and sources
    const config = {
        repo: 'lloydlentz/slate-portal-claude',
        branch: 'main',

        views: {
            'student-courses': {
                sourceFile: 'views/student-courses.html',
                part_id: '8c388fc7-ddc2-4cbf-8680-3eb0b3dfecbe',
                view_id: 'e5469709-59d3-49fb-a30a-2677b745e96a',
                base: '4ea0ba73-ced1-4996-a50d-3d861d539c1e',
                type: 'html',
                name: 'student-courses'
            },
            'student-list': {
                sourceFile: 'views/student-list.html',
                part_id: 'fc91dd5f-2e69-4940-82d3-cd01127355b0',
                view_id: 'f7014bb5-dccb-4317-bedf-804cea1caba1',
                base: '4ea0ba73-ced1-4996-a50d-3d861d539c1e',
                type: 'html',
                name: 'student-list'
            }
        },

        queries: {
            'student-courses': {
                id: 'bb2ff552-3995-40e6-b679-e1a89250168b',
                node: 'row',
                parameters: '<param id="uid" />'
            },
            'list-students': {
                id: '1e4d685b-3166-4044-8969-a89df23edb00',
                node: 'row',
                parameters: ''
            }
        }
    };

    // ========== View Deployment ==========

    async function fetchFromGitHub(filePath) {
        const url = `https://raw.githubusercontent.com/${config.repo}/${config.branch}/${filePath}`;
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Failed to fetch ${filePath}: ${response.status}`);
        }
        return await response.text();
    }

    async function deployViewToSlate(viewConfig, html) {
        const queryString = new URLSearchParams({
            cmd: 'edit_part',
            type: viewConfig.type,
            view: viewConfig.view_id,
            id: viewConfig.part_id,
            div: `div_${viewConfig.part_id}`
        }).toString();

        const formData = new URLSearchParams({
            cmd: 'save',
            type: viewConfig.type,
            active: '1',
            id: viewConfig.part_id,
            div: `div_${viewConfig.part_id}`,
            view: viewConfig.view_id,
            base: viewConfig.base,
            name: viewConfig.name,
            html: html
        });

        const response = await fetch(`/manage/database/portal/widget/html?${queryString}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        });

        return await response.text();
    }

    // ========== Query Parameter Management ==========

    async function updateQueryParams(queryId, node, parameters) {
        const url = `/manage/query/build?id=${queryId}&cmd=param`;

        const formData = new URLSearchParams({
            cmd: 'save',
            config_xml_node: node,
            config_xml_parameters: parameters
        });

        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        });

        return await response.text();
    }

    // ========== Public API ==========

    return {
        // ----- Views -----

        async deployView(viewName) {
            const viewConfig = config.views[viewName];
            if (!viewConfig) {
                console.error(`Unknown view: ${viewName}`);
                console.log('Available views:', Object.keys(config.views).join(', '));
                return;
            }

            console.log(`Deploying view "${viewName}"...`);
            try {
                console.log(`  Fetching from GitHub: ${viewConfig.sourceFile}`);
                const html = await fetchFromGitHub(viewConfig.sourceFile);
                console.log(`  Fetched ${html.length} bytes`);
                console.log(`  Posting to Slate...`);
                const result = await deployViewToSlate(viewConfig, html);

                if (result.includes('error')) {
                    console.error(`  Error: ${result}`);
                } else {
                    console.log(`  Success!`);
                }
            } catch (err) {
                console.error(`  Failed: ${err.message}`);
            }
        },

        async deployFromClipboard(viewName) {
            const viewConfig = config.views[viewName];
            if (!viewConfig) {
                console.error(`Unknown view: ${viewName}`);
                console.log('Available views:', Object.keys(config.views).join(', '));
                return;
            }

            console.log(`Deploying view "${viewName}" from clipboard...`);
            try {
                const html = await navigator.clipboard.readText();
                if (!html || html.trim().length === 0) {
                    console.error('  Clipboard is empty. Copy the view HTML first.');
                    return;
                }
                console.log(`  Read ${html.length} bytes from clipboard`);
                console.log(`  Posting to Slate...`);
                const result = await deployViewToSlate(viewConfig, html);

                if (result.includes('error')) {
                    console.error(`  Error: ${result}`);
                } else {
                    console.log(`  Success!`);
                }
            } catch (err) {
                console.error(`  Failed: ${err.message}`);
            }
        },

        async deployAllViews() {
            for (const viewName of Object.keys(config.views)) {
                await this.deployView(viewName);
            }
        },

        listViews() {
            console.log('Available views:');
            for (const [name, cfg] of Object.entries(config.views)) {
                console.log(`  - ${name} (${cfg.sourceFile})`);
            }
        },

        // ----- Queries -----

        async setQueryParams(queryName, node, parameters) {
            // If queryName is a GUID, use it directly
            let queryId = queryName;
            let queryConfig = config.queries[queryName];

            if (queryConfig) {
                queryId = queryConfig.id;
            } else if (!queryName.match(/^[0-9a-f-]{36}$/i)) {
                console.error(`Unknown query: ${queryName}`);
                console.log('Available queries:', Object.keys(config.queries).join(', ') || '(none configured)');
                console.log('Or pass a query GUID directly.');
                return;
            }

            console.log(`Updating query parameters...`);
            console.log(`  Query ID: ${queryId}`);
            console.log(`  Node: ${node}`);
            console.log(`  Parameters: ${parameters}`);

            try {
                const result = await updateQueryParams(queryId, node, parameters);
                if (result.includes('error') || result.includes('Error')) {
                    console.error(`  Error: ${result}`);
                } else {
                    console.log(`  Success!`);
                }
            } catch (err) {
                console.error(`  Failed: ${err.message}`);
            }
        },

        // Convenience: Update from config
        async deployQuery(queryName) {
            const queryConfig = config.queries[queryName];
            if (!queryConfig) {
                console.error(`Unknown query: ${queryName}`);
                console.log('Available queries:', Object.keys(config.queries).join(', ') || '(none configured)');
                return;
            }
            await this.setQueryParams(queryName, queryConfig.node, queryConfig.parameters);
        },

        listQueries() {
            console.log('Configured queries:');
            if (Object.keys(config.queries).length === 0) {
                console.log('  (none configured)');
                console.log('  Add queries to config.queries in this script.');
            } else {
                for (const [name, cfg] of Object.entries(config.queries)) {
                    console.log(`  - ${name} (node: ${cfg.node})`);
                }
            }
        },

        // ----- Utility -----

        help() {
            console.log(`
SlateDeployer Commands:

VIEWS:
  listViews()                         List configured views
  deployView('name')                  Deploy view from GitHub (public repo)
  deployFromClipboard('name')         Deploy view from clipboard (private repo)
  deployAllViews()                    Deploy all views from GitHub

QUERIES:
  listQueries()                       List configured queries
  deployQuery('name')                 Update query params from config
  setQueryParams('name|guid', 'node', '<param ... />')
                                      Update query params directly

EXAMPLES:
  SlateDeployer.deployFromClipboard('student-courses')
  SlateDeployer.setQueryParams('bb2ff552-3995-40e6-b679-e1a89250168b', 'students', '<param id="uid" />')
`);
        }
    };
})();

console.log('SlateDeployer loaded. Type SlateDeployer.help() for commands.');
