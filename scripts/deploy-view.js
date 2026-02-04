/**
 * Slate Portal View Deployment Script
 *
 * Usage: Run in browser console while logged into Slate admin
 *
 * 1. Log into Slate admin (https://student.macalester.edu/manage/)
 * 2. Open browser console (F12 > Console)
 * 3. Paste and run this script
 * 4. Call: SlateDeployer.deployView('student-courses')
 */

window.SlateDeployer = (function() {
    'use strict';

    // Configuration - maps view names to their Slate IDs and GitHub sources
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
            }
        }
    };

    async function fetchFromGitHub(filePath) {
        const url = `https://raw.githubusercontent.com/${config.repo}/${config.branch}/${filePath}`;
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Failed to fetch ${filePath}: ${response.status}`);
        }
        return await response.text();
    }

    async function deployToSlate(viewConfig, html) {
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
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        });

        return await response.text();
    }

    return {
        // Deploy a single view by name
        async deployView(viewName) {
            const viewConfig = config.views[viewName];
            if (!viewConfig) {
                console.error(`Unknown view: ${viewName}`);
                console.log('Available views:', Object.keys(config.views).join(', '));
                return;
            }

            console.log(`Deploying ${viewName}...`);

            try {
                // Fetch source from GitHub
                console.log(`  Fetching from GitHub: ${viewConfig.sourceFile}`);
                const html = await fetchFromGitHub(viewConfig.sourceFile);
                console.log(`  Fetched ${html.length} bytes`);

                // Deploy to Slate
                console.log(`  Posting to Slate...`);
                const result = await deployToSlate(viewConfig, html);

                if (result.includes('error')) {
                    console.error(`  Error: ${result}`);
                } else {
                    console.log(`  Success! View "${viewName}" deployed.`);
                }
            } catch (err) {
                console.error(`  Failed: ${err.message}`);
            }
        },

        // Deploy all views
        async deployAll() {
            for (const viewName of Object.keys(config.views)) {
                await this.deployView(viewName);
            }
        },

        // List available views
        listViews() {
            console.log('Available views:');
            for (const [name, cfg] of Object.entries(config.views)) {
                console.log(`  - ${name} (${cfg.sourceFile})`);
            }
        }
    };
})();

console.log('SlateDeployer loaded. Commands:');
console.log('  SlateDeployer.listViews()              - List available views');
console.log('  SlateDeployer.deployView("view-name")  - Deploy a specific view');
console.log('  SlateDeployer.deployAll()              - Deploy all views');
