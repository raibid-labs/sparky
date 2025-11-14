## Sparky Scripts (Nushell)

Collection and analysis scripts using **Nushell** - following the raibid-labs/dgx-pixels flavor.

### Why Nushell?

- **dgx-pixels pattern**: Proven in raibid-labs projects
- **Structured data**: Native JSON handling (no jq/Python needed!)
- **Modern**: Better than bash for structured data pipelines
- **Consistent**: Matches Sparky's Rust + k3s + Justfile + Nushell stack

### Quick Start

```bash
# Install prerequisites
just install-demo-deps

# Run pipelines
just demo-daily     # Daily digest (last 24 hours)
just demo-weekly    # Weekly report (last 7 days)
just demo-monthly   # Monthly review (last 30 days)
```

### Individual Scripts

**Data Collection:**
- `collect-daily.nu` - Collect last 24 hours of GitHub activity
- `collect-weekly.nu` - Collect last 7 days of GitHub activity
- `collect-monthly.nu` - Collect last 30 days of GitHub activity

**Analysis:**
- `analyze-daily.nu` - Generate 200-300 word daily digest
- `analyze-weekly.nu` - Generate 800-1200 word weekly report
- `analyze-monthly.nu` - Generate 2000-3000 word monthly review

**Pipeline:**
- `pipeline.nu` - Unified pipeline orchestrator

### Run Directly

```bash
# Collection
nu scripts/collect-daily.nu
nu scripts/collect-weekly.nu
nu scripts/collect-monthly.nu

# Analysis
nu scripts/analyze-daily.nu
nu scripts/analyze-weekly.nu
nu scripts/analyze-monthly.nu

# Full pipeline
nu scripts/pipeline.nu daily
nu scripts/pipeline.nu weekly
nu scripts/pipeline.nu monthly
```

### Output Locations

- **Daily**: `output/daily/YYYY-MM-DD.md`
- **Weekly**: `output/weekly/YYYY-WNN.md`
- **Monthly**: `output/monthly/YYYY-MM.md`

### Data Storage

Raw data saved to `data/raw/`:
- `*-repos.json` - Repository list
- `*-commits.json` - Commit activity
- `*-prs.json` - Pull requests
- `*-issues.json` - Issue activity
- `*-releases.json` - Releases (monthly only)
- `*-summary.json` - Summary statistics

### Cost

**$0/month** - Everything runs locally:
- GitHub CLI (free, no API limits)
- Ollama (local LLM inference)
- Nushell (native structured data handling)
- Git repository (free storage)

### Tech Stack

✅ **Nushell** - Modern shell with structured data
✅ **GitHub CLI** - Free access to GitHub data
✅ **Ollama** - Local LLM (qwen2.5-coder:1.5b)
✅ **Justfile** - Task automation

### Advantages of Nushell Approach

**vs Bash:**
- Native JSON parsing (no jq dependency)
- Structured data pipelines
- Type safety and error handling
- Better readability

**vs Python:**
- Simpler for shell-like operations
- No virtual environment needed
- Matches dgx-pixels patterns
- Integrated with justfile workflows

### Next Steps

These Nushell scripts are production-ready prototypes. The full Rust implementation will:
- Use these patterns as reference
- Add Kubernetes orchestration (k3s)
- Include monitoring and health checks
- Support automated scheduling
- Publish to multiple channels

See the main [README.md](../README.md) for the full production roadmap.
