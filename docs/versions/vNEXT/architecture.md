# Sparky Architecture

**Version:** 1.0
**Date:** 2025-11-12
**Status:** Design Phase

## Overview

Sparky is an AI-powered automation system that monitors git activity across all raibid-labs repositories, generates intelligent summaries, and produces engaging content for blogs and social media.

## Core Mission

Transform raw development activity into compelling narratives that:
- Keep stakeholders informed
- Celebrate team accomplishments
- Build community engagement
- Maintain organization memory
- Enable data-driven insights

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Sparky Orchestrator                          │
│              (Event-Driven Meta-Coordinator)                     │
└────────────────────────┬────────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
┌─────────────────┐ ┌─────────────┐ ┌──────────────────┐
│  Data Collector │ │ Analyzer    │ │ Content Generator│
│    (Agents)     │ │  (Agents)   │ │    (Agents)      │
└────────┬────────┘ └──────┬──────┘ └────────┬─────────┘
         │                 │                  │
         ▼                 ▼                  ▼
┌─────────────────────────────────────────────────────────┐
│              Shared State & Memory Layer                 │
│         (Claude Flow Memory + GitHub Issues/PRs)         │
└─────────────────────────────────────────────────────────┘
         │                 │                  │
         ▼                 ▼                  ▼
┌─────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ GitHub API  │  │  raibid-labs    │  │  docs repo      │
│ (28+ repos) │  │   Database      │  │  (Integration)  │
└─────────────┘  └─────────────────┘  └─────────────────┘
```

## Core Components

### 1. Orchestrator (Meta-Coordinator)

**Responsibilities:**
- Schedule collection jobs (daily, weekly, monthly)
- Coordinate parallel agent execution
- Monitor agent health and progress
- Handle error recovery and retries
- Manage dependency ordering
- Trigger content generation pipelines

**Implementation:**
- GitHub Actions workflows (scheduled + webhook triggers)
- State machine for agent lifecycle management
- Health monitoring with dashboards
- Claude Flow session management

**Key Files:**
```
.github/workflows/
├── sparky-daily-collection.yml
├── sparky-weekly-summary.yml
├── sparky-monthly-digest.yml
└── sparky-orchestrator.yml

scripts/orchestration/
├── spawn-collector-agents.sh
├── spawn-analyzer-agents.sh
├── spawn-content-agents.sh
└── health-check.sh
```

### 2. Data Collector Agents

**Purpose:** Gather git activity data from all raibid-labs repositories

**Agent Types:**
- **Commit Collector:** Fetch all commits since last run
- **PR Collector:** Gather PR data (created, merged, commented)
- **Issue Collector:** Collect issue activity
- **Release Collector:** Track releases and tags
- **Contributor Collector:** Analyze contributor activity

**Technology:**
- Octokit (GitHub GraphQL API for efficiency)
- raibid-cli patterns for repository discovery
- Concurrent collection (4-8 repos in parallel)
- Rate limit management (GitHub App: 5000 req/hr)

**Output:**
```json
{
  "collection_id": "2025-11-12-daily",
  "timestamp": "2025-11-12T00:00:00Z",
  "repositories": [
    {
      "name": "raibid-cli",
      "commits": [...],
      "pull_requests": [...],
      "issues": [...],
      "contributors": [...]
    }
  ]
}
```

### 3. Analyzer Agents

**Purpose:** Extract insights and patterns from collected data

**Agent Types:**
- **Activity Analyzer:** Calculate metrics (commits/day, PR velocity, etc.)
- **Trend Detector:** Identify patterns (productivity spikes, focus areas)
- **Impact Scorer:** Determine significance of changes
- **Contributor Profiler:** Analyze individual/team contributions
- **Project Health:** Assess repository health metrics

**Technology:**
- Python data analysis (pandas, numpy)
- Claude API for semantic analysis
- Pattern recognition algorithms
- Time-series analysis for trends

**Output:**
```json
{
  "analysis_id": "2025-11-12-daily-analysis",
  "insights": {
    "top_contributors": [...],
    "active_projects": [...],
    "productivity_score": 8.5,
    "trending_topics": ["kubernetes", "ai-agents"],
    "notable_changes": [...]
  }
}
```

### 4. Content Generator Agents

**Purpose:** Transform data and insights into engaging content

**Agent Types:**
- **Daily Digest Generator:** Short summary for daily updates
- **Weekly Report Generator:** Comprehensive weekly overview
- **Monthly Review Generator:** In-depth monthly analysis
- **Blog Post Generator:** Long-form content for external publication
- **Social Media Generator:** Tweets, LinkedIn posts, etc.

**Technology:**
- Claude 4 / GPT-4o for high-quality content
- Template system for consistent formatting
- Tone adaptation (technical vs. marketing)
- Multi-format output (Markdown, HTML, JSON)

**Content Types:**
```
Daily:   200-300 words, bullet points, key highlights
Weekly:  800-1200 words, narrative style, metrics + stories
Monthly: 2000-3000 words, comprehensive review, trends
Blog:    1500-2500 words, polished, SEO-optimized
Social:  280 chars (Twitter), 1300 chars (LinkedIn)
```

### 5. Shared State & Memory Layer

**Purpose:** Coordinate agent communication and maintain system state

**Components:**
- **Claude Flow Memory:** Session state, agent coordination
- **GitHub Issues/Comments:** Persistent storage, human oversight
- **Database:** Historical data, metrics, trends
- **File System:** Generated content, artifacts

**Integration:**
```bash
# Before collecting data
npx claude-flow@alpha hooks pre-task --description "Daily collection 2025-11-12"

# During analysis
npx claude-flow@alpha hooks post-edit \
  --file "data/2025-11-12-collection.json" \
  --memory-key "sparky/daily/2025-11-12/collection"

# After content generation
npx claude-flow@alpha hooks post-task --task-id "daily-2025-11-12"
```

## Event-Driven Triggers

### Scheduled Events

**Daily Collection:** Every day at 00:00 UTC
```yaml
schedule:
  - cron: '0 0 * * *'  # Daily at midnight
```

**Weekly Summary:** Every Monday at 08:00 UTC
```yaml
schedule:
  - cron: '0 8 * * 1'  # Monday 8 AM
```

**Monthly Review:** First day of month at 09:00 UTC
```yaml
schedule:
  - cron: '0 9 1 * *'  # 1st of month, 9 AM
```

### Webhook Events

**On Push to Main:** Trigger immediate analysis for important repos
```yaml
on:
  push:
    branches: [main]
    paths:
      - 'src/**'
      - 'docs/**'
```

**On Release:** Generate release announcement content
```yaml
on:
  release:
    types: [published]
```

## Parallel Execution Strategy

### Daily Collection (Phase 1)

**Parallel Agents:** 4-6 collectors
```
Collector 1: Repos 1-5   (raibid-ci, raibid-cli, xptui, agents, docs)
Collector 2: Repos 6-10  (mop, osai, hack-agent-lightning, upterm, BrowserOS)
Collector 3: Repos 11-15 (dgx-spark, dgx-music, dgx-pixels, hack-k8s, hack-browser)
Collector 4: Repos 16-20 (ardour, cosmos-nvim, music-generation-mcp, ...)
Collector 5: Repos 21-25 (...)
Collector 6: Repos 26-28 (...)
```

**Execution Time:** ~5-10 minutes (parallel)

### Analysis Phase (Phase 2 - Sequential After Collection)

**Parallel Agents:** 3-4 analyzers
```
Analyzer 1: Activity metrics (commits, PRs, issues)
Analyzer 2: Trend detection (patterns, focus areas)
Analyzer 3: Contributor analysis (individual performance)
Analyzer 4: Impact scoring (change significance)
```

**Execution Time:** ~3-5 minutes (parallel)

### Content Generation (Phase 3 - Sequential After Analysis)

**Parallel Agents:** 2-3 generators
```
Generator 1: Daily digest + social media
Generator 2: Weekly report (if Monday)
Generator 3: Blog post (if significant activity)
```

**Execution Time:** ~5-8 minutes (parallel)

**Total Pipeline:** 13-23 minutes end-to-end

## Integration with raibid-labs Ecosystem

### Integration with raibid-cli

Use existing repository discovery patterns:
```bash
# Discover all raibid-labs repositories
raibid-cli list --format json > repos.json

# Filter repos with recent activity
cat repos.json | jq '.[] | select(.updated_at > "2025-11-11")'
```

### Integration with docs Repository

Publish summaries to documentation hub:
```
content/updates/
├── daily/
│   ├── 2025-11-12.md
│   ├── 2025-11-13.md
│   └── ...
├── weekly/
│   ├── 2025-W45.md
│   └── ...
└── monthly/
    ├── 2025-11.md
    └── ...
```

### Integration with raibid-ci Orchestrator

Use proven GitHub Actions patterns:
```yaml
# Reuse orchestrator patterns
- name: Check Readiness
  uses: ./.github/actions/check-readiness

- name: Spawn Collector Agents
  uses: ./.github/actions/spawn-agents
  with:
    agent_type: collector
    parallel_count: 6
```

## Data Flow

```
GitHub Repos (28+)
    ↓ (Collection via GitHub API)
Raw Activity Data (JSON)
    ↓ (Analysis via AI + algorithms)
Insights & Metrics (JSON)
    ↓ (Generation via Claude API)
Content Artifacts (MD, HTML, JSON)
    ↓ (Publishing)
├─→ docs repository (updates/)
├─→ GitHub Issues (summaries as comments)
├─→ Blog platform (Beehiiv, Dev.to)
└─→ Social media (Twitter, LinkedIn)
```

## State Management

### Agent States

```javascript
SPAWNING → INITIALIZING → COLLECTING/ANALYZING/GENERATING
    ↓           ↓                    ↓
  PAUSED ← → DEGRADED → UNHEALTHY → FAILED
    ↓                                 ↓
  COMPLETE ← ← ← ← ← ← ← ← ← ← ← ← RETRY
```

### Session Management

```bash
# Create session for daily pipeline
session_id="sparky-daily-$(date +%Y-%m-%d)"

# Restore context between phases
npx claude-flow@alpha hooks session-restore --session-id "$session_id"

# Export metrics at end
npx claude-flow@alpha hooks session-end \
  --session-id "$session_id" \
  --export-metrics true
```

## Error Handling & Recovery

### Retry Strategy

```yaml
retry:
  max_attempts: 3
  backoff: exponential  # 1s, 2s, 4s
  on_failure: notify_human
```

### Health Monitoring

```javascript
health_check: {
  interval: 30,  // seconds
  thresholds: {
    response_time: 5000,    // ms
    error_count: 2,
    timeout: 300            // seconds
  },
  on_unhealthy: "spawn_troubleshooter"
}
```

### Fallback Modes

- **Degraded Mode:** Skip non-critical analysis, basic summary only
- **Manual Mode:** Human review required before publishing
- **Emergency Stop:** Halt all operations, notify maintainers

## Scalability Considerations

### Current Scale (28 repositories)
- Collection: ~10 minutes
- Analysis: ~5 minutes
- Generation: ~8 minutes
- **Total: ~23 minutes**

### Future Scale (100+ repositories)
- Increase parallel collectors: 6 → 12
- Implement caching layer (Redis)
- Use incremental collection (delta only)
- Batch GraphQL queries
- **Target: <30 minutes**

### Cost Projections

**Daily Pipeline:**
- GitHub API: Free (GitHub App: 5000 req/hr)
- Claude API: ~$0.50/day (summarization)
- Infrastructure: ~$20/month (Vercel, DB)
- **Monthly: ~$35**

**At Scale (100 repos):**
- Claude API: ~$1.50/day
- Infrastructure: ~$50/month
- **Monthly: ~$95**

## Security & Privacy

### API Keys
- Store in GitHub Secrets
- Rotate every 90 days
- Use GitHub Apps (not personal tokens)

### Data Handling
- Only public repository data
- No sensitive information in summaries
- Human review for external publication

### Access Control
- GitHub App permissions: read-only
- Limited to raibid-labs organization
- Audit logs for all operations

## Monitoring & Observability

### Dashboards

```
╔════════════════════════════════════════════════╗
║      Sparky Daily Pipeline Dashboard           ║
║ Progress: ██████████████░░░░ 75%              ║
╠════════════════════════════════════════════════╣
║ Phase 1: Collection       ✅ COMPLETE (8m 23s) ║
║   Collector 1 (repos 1-5)   ✅ 5/5 repos       ║
║   Collector 2 (repos 6-10)  ✅ 5/5 repos       ║
║   Collector 3 (repos 11-15) ✅ 5/5 repos       ║
║   Collector 4 (repos 16-20) ✅ 5/5 repos       ║
║   Collector 5 (repos 21-25) ✅ 5/5 repos       ║
║   Collector 6 (repos 26-28) ✅ 3/3 repos       ║
╠════════════════════════════════════════════════╣
║ Phase 2: Analysis         🔄 IN PROGRESS (2m)  ║
║   Activity Analyzer         ✅ COMPLETE        ║
║   Trend Detector            🔄 RUNNING         ║
║   Contributor Profiler      ⏳ PENDING         ║
║   Impact Scorer             ⏳ PENDING         ║
╠════════════════════════════════════════════════╣
║ Phase 3: Content          ⏳ PENDING           ║
║   Daily Digest              ⏳ QUEUED          ║
║   Social Media Posts        ⏳ QUEUED          ║
╚════════════════════════════════════════════════╝
```

### Metrics

**Collection Metrics:**
- Repositories processed: 28/28
- Commits collected: 127
- PRs collected: 15
- Issues collected: 8
- Duration: 8m 23s

**Analysis Metrics:**
- Insights generated: 12
- Trends detected: 3
- Contributors profiled: 8
- Duration: 4m 12s

**Content Metrics:**
- Daily digest: 287 words
- Social posts: 3 generated
- Blog post: 1 drafted
- Duration: 6m 45s

## Future Enhancements

### Phase 2 (Q1 2026)
- [ ] Slack/Discord integration
- [ ] Real-time updates (webhooks)
- [ ] Custom report templates
- [ ] Interactive dashboards

### Phase 3 (Q2 2026)
- [ ] ML-based anomaly detection
- [ ] Predictive analytics
- [ ] Automated A/B testing for content
- [ ] Multi-organization support

## References

### Existing Patterns
- Event-driven orchestration: `/home/beengud/raibid-labs/agents/ORCHESTRATOR_AUTOMATION_PLAN.md`
- Parallel coordination: `/home/beengud/raibid-labs/xptui/scripts/dev/agent-coordination.md`
- Meta-orchestrator: `/home/beengud/raibid-labs/mop/docs/agents/orchestration.md`
- Repository management: `/home/beengud/raibid-labs/raibid-cli/SUMMARY.md`

### Technology Stack
- GitHub Actions (orchestration)
- Octokit (GitHub API)
- Claude API (content generation)
- Claude Flow (agent coordination)
- Nushell (scripting)
- Rust (performance-critical components)
- Python (data analysis)

---

**Next:** See [components.md](./components.md) for detailed component specifications
