# Documentation Structure

This document describes the organization and structure of the Sparky documentation.

## Directory Layout

```
docs/
├── STRUCTURE.md              # This file - documentation organization guide
├── versions/                 # Versioned documentation
│   ├── v0.1.0/              # Version 0.1.0 docs
│   │   ├── quickstart.md    # Getting started guide
│   │   ├── architecture.md  # System architecture
│   │   └── api.md           # API reference (when applicable)
│   └── vNEXT/               # Unreleased/development docs
├── examples/                 # Code examples and demos
├── guides/                   # User guides and tutorials
└── reference/                # Technical reference documentation

research/                     # Research and investigation notes
└── (technical research)      # Model comparisons, benchmarks, etc.
```

## Documentation Standards

### Required Sections

All documentation should include:

1. **Introduction** - What is this? Why does it exist?
2. **Installation** - How to install and set up
3. **Usage** - How to use the tool/feature
4. **Examples** - Real-world usage examples
5. **API Reference** - For libraries and programmatic interfaces
6. **Changelog** - Link to version history

### File Naming Conventions

- Use lowercase with hyphens: `getting-started.md`, `api-reference.md`
- Keep names descriptive but concise
- Version-specific docs go in `docs/versions/vX.Y.Z/`

### Content Guidelines

1. **Keep it user-focused**: Write for the person using the software
2. **Be concise**: Remove unnecessary jargon and wordiness
3. **Use examples**: Show, don't just tell
4. **Keep it current**: Outdated docs are worse than no docs
5. **Link appropriately**: Cross-reference related documentation

## Version Management

### Versioning Policy

- **vNEXT**: Unreleased features and changes in development
- **vX.Y.Z**: Released versions following semantic versioning
  - X = Major version (breaking changes)
  - Y = Minor version (new features, backward compatible)
  - Z = Patch version (bug fixes)

### Version Documentation Lifecycle

1. Development docs live in `docs/versions/vNEXT/`
2. On release, `vNEXT` is copied to `docs/versions/vX.Y.Z/`
3. A new `vNEXT` directory is created for next release
4. README.md links to latest stable version

### Archival Policy

- Keep last 3 major versions in `docs/versions/`
- Archive older versions to separate repository if needed
- Never delete research notes - they inform future decisions

## Research vs. Documentation

### Research (`research/`)
- Technical investigations and explorations
- Model comparisons and benchmarks
- Proof-of-concept findings
- Can be informal, exploratory
- Retained for historical reference

### Documentation (`docs/`)
- User-facing content only
- Clear, actionable information
- Well-structured and maintained
- Updated with each release

## Maintenance

### CI Validation

Documentation is validated in CI for:
- Broken internal links
- Missing required sections
- Orphaned files (not linked from anywhere)
- Markdown syntax errors

### Review Process

1. All doc changes require PR review
2. Reviewers check for clarity and accuracy
3. Test all code examples before merging
4. Update version in docs when releasing

## Quick Links

- [Main README](../README.md) - Project overview
- [Quickstart Guide](versions/v0.1.0/quickstart.md) - Get started quickly
- [Architecture](versions/v0.1.0/architecture.md) - System design
- [Research](../research/) - Technical investigations

## Questions?

For documentation questions, open an issue with the `documentation` label.
