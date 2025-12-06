# Release Process

This document describes how to create and publish releases for Sparky.

## Overview

Sparky uses semantic versioning (MAJOR.MINOR.PATCH) and automated release workflows via GitHub Actions.

- **MAJOR**: Breaking changes (e.g., 1.0.0 → 2.0.0)
- **MINOR**: New features, backward compatible (e.g., 1.0.0 → 1.1.0)
- **PATCH**: Bug fixes, backward compatible (e.g., 1.0.0 → 1.0.1)

## Release Workflow

### 1. Prepare the Release

1. **Update version documentation**
   ```bash
   # Ensure docs/versions/vNEXT has latest documentation
   ls docs/versions/vNEXT/
   ```

2. **Run local tests**
   ```bash
   just ci-check
   ```

3. **Update version references** (if needed)
   - Check `README.md` for version references
   - Update version in `justfile` if present

### 2. Create Release Branch (Optional)

For major/minor releases, create a release branch:
```bash
git checkout -b release/v0.1.0
git push -u origin release/v0.1.0
```

### 3. Tag the Release

1. **Create and push the tag**
   ```bash
   # Format: vMAJOR.MINOR.PATCH
   git tag -a v0.1.0 -m "Release v0.1.0"
   git push origin v0.1.0
   ```

2. **GitHub Actions will automatically:**
   - Run all CI tests
   - Build distribution packages (.tar.gz and .zip)
   - Generate checksums (SHA256)
   - Create changelog from git commits
   - Publish GitHub Release with artifacts
   - Update versioned documentation

### 4. Verify Release

1. **Check GitHub Actions**
   - Go to: https://github.com/raibid-labs/sparky/actions
   - Verify "Release" workflow completed successfully

2. **Review the release**
   - Go to: https://github.com/raibid-labs/sparky/releases
   - Verify release notes are correct
   - Check artifacts are present:
     - sparky-vX.Y.Z.tar.gz
     - sparky-vX.Y.Z.zip
     - Checksums (.sha256 files)

3. **Test the release**
   ```bash
   # Download and test
   wget https://github.com/raibid-labs/sparky/releases/download/v0.1.0/sparky-v0.1.0.tar.gz
   sha256sum -c sparky-v0.1.0.tar.gz.sha256
   tar -xzf sparky-v0.1.0.tar.gz
   cd sparky-v0.1.0
   just --list
   ```

### 5. Post-Release

1. **Announce the release**
   - Update raibid-labs/docs blog
   - Post to social media (if applicable)
   - Notify team via Slack/Discord

2. **Create next version docs**
   ```bash
   # vNEXT should be copied automatically by release workflow
   # Verify it exists for the next development cycle
   ls docs/versions/vNEXT/
   ```

## Manual Release (Alternative)

If you need to trigger a release manually (without pushing a tag):

1. **Go to GitHub Actions**
   - Navigate to: https://github.com/raibid-labs/sparky/actions/workflows/release.yml
   - Click "Run workflow"
   - Enter version (e.g., v0.1.0)
   - Click "Run workflow"

2. **Create the tag afterward**
   ```bash
   git tag -a v0.1.0 -m "Release v0.1.0"
   git push origin v0.1.0
   ```

## Hotfix Releases

For urgent bug fixes on a released version:

1. **Create hotfix branch from tag**
   ```bash
   git checkout -b hotfix/v0.1.1 v0.1.0
   ```

2. **Make fixes and commit**
   ```bash
   # Fix the bug
   git add .
   git commit -m "fix: Critical bug description"
   ```

3. **Tag and release**
   ```bash
   git tag -a v0.1.1 -m "Hotfix v0.1.1"
   git push origin v0.1.1
   ```

4. **Merge back to main**
   ```bash
   git checkout main
   git merge hotfix/v0.1.1
   git push origin main
   ```

## Rollback a Release

If a release has critical issues:

1. **Mark release as draft** (on GitHub)
   - Go to the release page
   - Edit release
   - Check "Set as a pre-release" or "Save draft"

2. **Delete the tag** (if necessary)
   ```bash
   git tag -d v0.1.0
   git push origin :refs/tags/v0.1.0
   ```

3. **Fix issues and re-release** with a patch version

## Branch Protection

The `main` branch has the following protections:

- Require pull request reviews before merging
- Require status checks to pass before merging
  - CI workflow must pass
  - Documentation check must pass
  - Policy check must pass
- Require signed commits (optional, recommended)
- No force pushes
- No deletions

### Overriding Protection (Admins Only)

In rare cases, admins can bypass protection:
- Use with extreme caution
- Document the reason in PR or issue
- Only for critical hotfixes or repo maintenance

## Release Checklist

Before creating a release, verify:

- [ ] All tests pass locally (`just ci-check`)
- [ ] Documentation is up to date (`docs/versions/vNEXT/`)
- [ ] CHANGELOG reflects new features/fixes
- [ ] Version follows semantic versioning
- [ ] No uncommitted changes
- [ ] All PRs merged to main
- [ ] CI passing on main branch

After creating a release:

- [ ] GitHub Actions release workflow completed
- [ ] Release published on GitHub
- [ ] Artifacts present and checksums valid
- [ ] Documentation versioned correctly
- [ ] Announcement posted (if applicable)

## Troubleshooting

### Release Workflow Failed

1. Check GitHub Actions logs
2. Common issues:
   - Tests failing: Fix and re-tag
   - Permission issues: Check GITHUB_TOKEN permissions
   - Artifact upload failed: Re-run workflow

### Tag Already Exists

```bash
# Delete local and remote tag
git tag -d v0.1.0
git push origin :refs/tags/v0.1.0

# Create new tag
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin v0.1.0
```

### Documentation Not Updated

The release workflow automatically copies `vNEXT` to the versioned docs.
If this fails, manually create the version docs:

```bash
cp -r docs/versions/vNEXT docs/versions/v0.1.0
git add docs/versions/v0.1.0
git commit -m "docs: Add v0.1.0 documentation"
git push origin main
```

## References

- [Semantic Versioning](https://semver.org/)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github)
- [GitHub Actions](https://docs.github.com/en/actions)

## Questions?

For questions about the release process, open an issue with the `release` label.
