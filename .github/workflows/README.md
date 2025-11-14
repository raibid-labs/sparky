# GitHub Actions Workflows

## Sync Docs to Wiki

**File**: `sync-docs-to-wiki.yml`

Automatically syncs the `/docs` directory to the GitHub wiki whenever changes are pushed to the main branch.

### How It Works

1. **Triggers**: Runs on every push to `docs/**` in the main/master branch, or manually via workflow dispatch
2. **Process**:
   - Checks out the main repository
   - Checks out the wiki repository
   - Copies all markdown files from `/docs` to wiki
   - Copies images and assets (png, jpg, jpeg, gif, svg)
   - Generates `Home.md` (from README.md or auto-generated)
   - Generates `_Sidebar.md` for navigation
   - Commits and pushes to wiki if there are changes

### Prerequisites

**IMPORTANT**: The wiki must be initialized before the first workflow run.

To initialize the wiki:
1. Go to https://github.com/raibid-labs/sparky/wiki
2. Click "Create the first page"
3. Add any content and save (this will be overwritten by the workflow)

Alternatively, you can enable the wiki in repository settings:
- Settings → Features → Enable "Wikis"

### Directory Structure Preserved

The workflow preserves the directory structure from `/docs`:

```
docs/
├── README.md              → Home.md (wiki landing page)
├── architecture.md        → architecture.md
├── guides/
│   └── setup.md          → guides/setup.md
└── images/
    └── diagram.png       → images/diagram.png
```

### Manual Sync

You can manually trigger the workflow:
1. Go to Actions tab in GitHub
2. Select "Sync Docs to Wiki"
3. Click "Run workflow"

### Customization

To customize the sync behavior, edit `sync-docs-to-wiki.yml`:

- **File types**: Add extensions to the copy loops
- **Exclusions**: Add filters to the `find` commands
- **Home page**: Modify the Home.md generation logic
- **Sidebar**: Customize the _Sidebar.md generation

### Troubleshooting

**Wiki not updating?**
- Check that the wiki has been initialized (see Prerequisites)
- Verify the workflow ran successfully in the Actions tab
- Check that changes were actually made to `/docs` directory

**Permission errors?**
- The default `GITHUB_TOKEN` has wiki write permissions
- If using a custom PAT, ensure it has `repo` scope

**Files missing?**
- Check file extensions are included in the copy loops
- Verify files are in the `/docs` directory

### Testing Locally

You can test the sync logic locally before pushing:

```bash
# Clone the wiki repo
git clone https://github.com/raibid-labs/sparky.wiki.git

# Run the sync commands manually
cd sparky.wiki
# ... copy the sync commands from the workflow
```

### Rollout to Other Repositories

To add this workflow to other raibid-labs repositories:

1. Copy `.github/workflows/sync-docs-to-wiki.yml` to the target repo
2. Initialize the wiki for that repository
3. Push changes to the target repo's main branch
4. The workflow will run automatically on the next docs change

For bulk rollout across the organization, see the documentation in the `docs` hub repository.
