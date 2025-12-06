# Sparky

**AI-Powered Development Activity Monitor & Content Generator for raibid-labs**

Sparky is an autonomous system that monitors git activity across all raibid-labs repositories, generates intelligent summaries, and produces engaging content for blogs and social media.

**Project Status:** Implementation Ready - Rust + k3s + Justfile + Nushell
**Last Updated:** 2025-11-12
**Timeline:** 60-70 days with parallel workstreams

---

## What is Sparky?

Sparky transforms raw development activity into compelling narratives using **100% open-source tools** with **zero external costs**.

- **Monitors** git activity across 28+ raibid-labs repositories (GitHub CLI)
- **Analyzes** commits, PRs, issues using **local LLM** (Ollama + Qwen2.5-Coder)
- **Generates** daily digests, weekly reports, and monthly reviews
- **Publishes** content to docs, blogs, and social media
- **Automates** the entire pipeline with zero manual intervention

**No API costs. No external dependencies. Runs completely locally.**

## Quick Start

### For Prototyping (15 Minutes)

```bash
# Using existing Bash/Python scripts
curl -fsSL https://ollama.com/install.sh | sh
ollama pull qwen2.5-coder:1.5b
./docs/examples/collect-gh.sh
python3 docs/examples/analyze-ollama.py
cat output/daily/$(date +%Y-%m-% d).md
```

**See [quickstart-oss.md](./docs/quickstart-oss.md) for this approach.**

### For Production (Rust Implementation)

```bash
# Prerequisites: Rust, Just, Nushell, Docker, k3d
just check-requirements

# Create local k3s cluster
just k3d-create

# Deploy Ollama
just deploy-ollama

# Build Sparky (once implemented)
just build

# Deploy services
just deploy-local

# Run pipeline
just demo-weekly

# Publish to raibid-labs/docs blog
just publish-weekly

# Monitor
just status
```

**Publishing Commands:**
```bash
just publish-daily    # Publish today's digest
just publish-weekly   # Publish this week's report
just publish-monthly  # Publish this month's review
```

**See [blog-publishing.md](./docs/blog-publishing.md) for blog details.**
**See [implementation-proposal.md](./docs/implementation-proposal.md) for full production details.**

## Architecture Overview

```
GitHub Repos (28+)
    ↓
Data Collectors (6 parallel agents)
    ↓
Analyzers (4 parallel agents)
    ↓
Content Generators (3 parallel agents)
    ↓
Publishers (docs, blog, social media)
```

**Pipeline Duration:** ~15-20 minutes end-to-end

## Core Features

### 1. Automated Data Collection
- Monitors all raibid-labs repositories
- Collects commits, PRs, issues, releases
- Concurrent collection (6 repos at a time)
- GitHub GraphQL API for efficiency
- Rate limit management (5000 req/hr)

### 2. Intelligent Analysis
- AI-powered semantic analysis (Claude API)
- Activity metrics (commits/day, PR velocity)
- Trend detection (productivity patterns)
- Impact scoring (change significance)
- Contributor profiling

### 3. Content Generation
- **Daily Digest:** 200-300 words, key highlights
- **Weekly Report:** 800-1200 words, comprehensive overview
- **Monthly Review:** 2000-3000 words, in-depth analysis
- **Blog Posts:** 1500-2500 words, polished content
- **Social Media:** Twitter/LinkedIn posts

### 4. Multi-Channel Publishing
- **raibid-labs/docs blog** (live! automated Quartz blog)
- Dev.to (external blog) - planned
- Twitter/LinkedIn (social engagement) - planned
- GitHub Issues/Comments (team updates) - planned

## Documentation

### 📚 Documentation Hub

All documentation is versioned and organized. See [Documentation Structure](./docs/STRUCTURE.md) for details.

### 🚀 Start Here

| Document | Description | Time |
|----------|-------------|------|
| **[Quickstart Guide](./docs/versions/vNEXT/quickstart.md)** | Get up and running quickly ⭐ | 15 min |
| **[Implementation Proposal](./docs/versions/vNEXT/implementation.md)** | Rust + k3s architecture | 30 min |
| **[Architecture](./docs/versions/vNEXT/architecture.md)** | System design and components | 30 min |
| [Justfile Reference](./justfile) | All available commands | 10 min |

### Development Guides

| Document | Description |
|----------|-------------|
| [Parallel Workstreams](./docs/guides/parallel-workstreams.md) | Development organization |
| [Parallel Issues](./docs/guides/parallel-issues.md) | GitHub issues breakdown |
| [Blog Publishing](./docs/guides/blog-publishing.md) | Publishing to raibid-labs/docs |

### Technical Reference

| Document | Description |
|----------|-------------|
| [Zero-Cost Architecture](./docs/reference/zero-cost-architecture.md) | OSS design decisions |
| [OSS Deployment Strategy](./docs/reference/oss-deployment-strategy.md) | Deployment approaches |
| [dgx-pixels Patterns](./docs/reference/dgx-pixels-orchestration-patterns.md) | Orchestration patterns |

### Research

Technical investigations and findings (optional reading):

| Resource | Description |
|----------|-------------|
| [Model Research](./research/git-commit-summarization-oss-models.md) | Best OSS models for summarization |
| [Research Report](./research/research-report-dev-automation-2025.md) | External market research |
| [Quick Start Guide](./research/quick-start-guide.md) | Early quick start research |

---

## Technology Stack (100% OSS)

### Core Technologies
- **Implementation Language:** Rust (all services)
- **Task Automation:** Just + Nushell scripts
- **Orchestration:** k3s (Kubernetes) via k3d (local) or k3sup (production)
- **Data Collection:** GitHub CLI (gh) - free, no API limits
- **LLM Inference:** Ollama + Qwen2.5-Coder-1.5B (local, Apache 2.0)
- **IPC:** ZeroMQ (REQ-REP + PUB-SUB patterns)
- **Storage:** Git repository (JSON + Markdown files)
- **Containerization:** Docker + Docker Compose

### Why This Stack?
- ✅ **$0/month** operating cost
- ✅ **No API rate limits** (GitHub CLI is special)
- ✅ **Full data privacy** (everything runs locally)
- ✅ **Fast inference** (< 1 second per summary)
- ✅ **High quality** (code-specialized models)
- ✅ **Easy deployment** (works on existing DGX infrastructure)

### Integration with DGX Infrastructure
- **dgx-spark-playbooks:** Deployment patterns (Ollama, vLLM, Docker)
- **Kubernetes:** Optional K8s deployment using existing K3s cluster
- **Docker:** Containerized services for isolation
- **GPU:** Efficient inference using NVIDIA GPUs

---

## Development Roadmap

### Phase 0: Bootstrap (Days 1-2)
- [x] Research and architecture design
- [x] Create documentation
- [ ] Initialize repository structure
- [ ] Set up GitHub Actions workflows
- [ ] Configure secrets and environment

### Phase 1: Parallel Workstreams (Days 3-9)
**All workstreams execute concurrently:**

- [ ] **Workstream 1:** Orchestration & Infrastructure
- [ ] **Workstream 2:** Data Collection System
- [ ] **Workstream 3:** Analysis Engine
- [ ] **Workstream 4:** Content Generation Pipeline

### Phase 2: Integration & Testing (Days 10-13)
- [ ] End-to-end pipeline testing
- [ ] Integration tests across workstreams
- [ ] Performance optimization
- [ ] Security audit

### Phase 3: Deployment & Documentation (Days 14-15)
- [ ] Production deployment
- [ ] Monitoring setup
- [ ] User guides and runbooks
- [ ] Launch first daily/weekly/monthly report

**Target Timeline:** 15 days (3 weeks)

---

## Parallel Workstream Organization

Sparky development is split into **4 independent workstreams** that can be executed concurrently:

```
┌─────────────────────┬─────────────────────┬─────────────────────┬─────────────────────┐
│   Workstream 1      │   Workstream 2      │   Workstream 3      │   Workstream 4      │
│   Orchestration     │   Collection        │   Analysis          │   Generation        │
├─────────────────────┼─────────────────────┼─────────────────────┼─────────────────────┤
│ GitHub Actions      │ GitHub API          │ AI Integration      │ Content Templates   │
│ Monitoring          │ Data Models         │ Metrics Calculation │ Publishing          │
│ Health Checks       │ Rate Limiting       │ Insight Generation  │ Multi-Format Output │
│ Agent Spawning      │ Storage Layer       │ Pattern Detection   │ Social Media        │
├─────────────────────┼─────────────────────┼─────────────────────┼─────────────────────┤
│ Owns:               │ Owns:               │ Owns:               │ Owns:               │
│ .github/workflows/  │ collectors/         │ analyzers/          │ generators/         │
│ scripts/            │ api/                │ ai/                 │ templates/          │
│ monitoring/         │ models/             │ analytics/          │ publishers/         │
│                     │ storage/            │ insights/           │ content/            │
├─────────────────────┼─────────────────────┼─────────────────────┼─────────────────────┤
│ Agent:              │ Agent:              │ Agent:              │ Agent:              │
│ devops-automator    │ backend-architect   │ ai-engineer         │ frontend-developer  │
├─────────────────────┼─────────────────────┼─────────────────────┼─────────────────────┤
│ Duration: 3-5 days  │ Duration: 4-6 days  │ Duration: 4-6 days  │ Duration: 4-6 days  │
└─────────────────────┴─────────────────────┴─────────────────────┴─────────────────────┘
```

**Benefits:**
- Parallel execution (4x faster than sequential)
- Clear ownership (prevents conflicts)
- Independent testing (each workstream validated separately)
- Flexible staffing (4 agents or developers working simultaneously)

See [Parallel Workstreams](./docs/parallel-workstreams.md) for detailed breakdown.

---

## Cost Analysis

### 100% OSS Stack (Current)

```
Ollama (local LLM):   $0/month (self-hosted)
GitHub CLI:           $0/month (free, no limits)
Storage (git):        $0/month (repository)
Electricity:          ~$0.50/month (minimal GPU usage)
Total:                ~$0.50/month
```

### Comparison to API-Based Approach

| Component | API-Based | OSS |
|-----------|-----------|-----|
| LLM Inference | $15-45/mo (Claude API) | **$0** (Ollama) |
| GitHub Data | $0 (rate limited) | **$0** (gh CLI, unlimited) |
| Storage | $0-25/mo (database) | **$0** (git) |
| Infrastructure | $0-20/mo (cloud) | **$0** (existing DGX) |
| **Total** | **$15-90/mo** | **~$0.50/mo** |

**Savings: $14.50 - $89.50/month**

### Quality Comparison

| Model | Quality | Speed | Monthly Cost |
|-------|---------|-------|--------------|
| GPT-4 API | 9/10 | 5-10s | $30-60 |
| Claude 3.5 API | 9.5/10 | 3-5s | $15-45 |
| **Qwen2.5-Coder-1.5B** | **8.5/10** | **<1s** | **$0** |

**For git commit summarization:** Code-specialized models like Qwen2.5-Coder are actually better than general-purpose LLMs while being free and 10x faster.

---

## Implementation Approach

### Why Rust + k3s + Justfile + Nushell?

**Based on dgx-pixels successful patterns:**
- **Rust:** Type safety, performance, excellent ecosystem
- **k3s:** Lightweight Kubernetes, perfect for DGX deployment
- **Justfile:** Task automation, better than Make for this use case
- **Nushell:** Modern shell scripting, structured data handling
- **ZeroMQ:** Fast IPC, proven in dgx-pixels (<1ms latency)

### Architecture

```
Meta Orchestrator (Rust)
    ↓ (ZeroMQ)
Collector → Analyzer → Generator → Publisher (all Rust)
    ↓ (calls)
GitHub CLI + Ollama (external)
```

All services run in k3s pods, communicate via ZeroMQ, and are orchestrated by the meta orchestrator following phase gates.

### Available Commands

```bash
# See all commands
just --list

# Common workflows
just build                # Build all Rust crates
just test                 # Run all tests
just k3d-create          # Create local k3s cluster
just deploy-local        # Deploy to local k3s
just pipeline-daily      # Run daily pipeline
just status              # Check system status
just logs-follow         # Follow service logs

# Over 50 commands available!
```

## Acknowledgments

Sparky's architecture is based on proven patterns from raibid-labs projects:

- **dgx-pixels:** Orchestration patterns, ZeroMQ, Justfile + Nushell automation ⭐
- **dgx-spark-playbooks:** Ollama deployment, Docker, k8s patterns
- **raibid-cli:** Multi-repository management (Rust)
- **raibid-ci:** Event-driven workflows
- **XPTui:** Parallel workstream coordination

Special thanks to all raibid-labs contributors whose work made this possible.

---

## License

MIT License - See [LICENSE](./LICENSE) file

## Contact

- **GitHub Issues:** [raibid-labs/sparky/issues](https://github.com/raibid-labs/sparky/issues)
- **Organization:** [raibid-labs](https://github.com/raibid-labs)
- **Documentation:** [raibid-labs.github.io/docs](https://raibid-labs.github.io/docs)

---

**Status:** Design Phase Complete | Ready for Phase 0 Bootstrap

**Last Updated:** 2025-11-12
