# Sparky: Parallel Workstreams & GitHub Issues

**Based on:** dgx-pixels orchestration patterns
**Total Duration:** 60-70 days (with parallelization)
**Workstreams:** 18 (4 can run in parallel during Phase 1)

---

## How to Use This Document

1. Copy each issue template below
2. Create GitHub issue with provided title, labels, and content
3. Assign to appropriate agent or team member
4. Work on parallel issues simultaneously
5. Respect phase gate dependencies

---

## Phase 0: Bootstrap (Days 1-5)

### Issue #1: Project Scaffolding & Cargo Workspace

**Title:** Bootstrap: Create Cargo workspace and project structure
**Labels:** `phase-0`, `bootstrap`, `rust`
**Assignee:** Meta-orchestrator or Tech Lead
**Duration:** 2 days

**Description:**
```markdown
## Goal
Set up Rust workspace with all crates and basic structure

## Tasks
- [ ] Create Cargo workspace manifest
- [ ] Scaffold all 6 crates:
  - [ ] sparky-common (shared library)
  - [ ] sparky-orchestrator
  - [ ] sparky-collector
  - [ ] sparky-analyzer
  - [ ] sparky-generator
  - [ ] sparky-publisher
- [ ] Add workspace dependencies
- [ ] Create basic `main.rs` for each binary crate
- [ ] Verify `cargo build --workspace` compiles
- [ ] Create basic unit test structure
- [ ] Run `cargo test --workspace` successfully

## Acceptance Criteria
- `cargo build --workspace` succeeds
- `cargo test --workspace` succeeds
- All crates follow consistent structure
- README files in each crate directory

## References
- dgx-pixels Cargo.toml patterns
- IMPLEMENTATION_PROPOSAL.md sections "Project Structure" and "Dependencies"
```

---

### Issue #2: Justfile & Nushell Scripts

**Title:** Bootstrap: Create Justfile and Nushell automation scripts
**Labels:** `phase-0`, `bootstrap`, `automation`
**Assignee:** DevOps Engineer
**Duration:** 2 days

**Description:**
```markdown
## Goal
Set up task automation with Justfile and Nushell scripts

## Tasks
- [ ] Create `justfile` with all commands from IMPLEMENTATION_PROPOSAL
- [ ] Create `scripts/` directory structure
- [ ] Implement core Nushell scripts:
  - [ ] scripts/collect.nu
  - [ ] scripts/analyze.nu
  - [ ] scripts/generate.nu
  - [ ] scripts/config.nu
- [ ] Create Docker automation:
  - [ ] scripts/docker/build.nu
  - [ ] scripts/docker/push.nu
- [ ] Create k3s automation:
  - [ ] scripts/k3s/create-cluster.nu
  - [ ] scripts/k3s/destroy-cluster.nu
- [ ] Test all `just` commands work
- [ ] Document usage in README

## Acceptance Criteria
- `just --list` shows all commands
- `just build` compiles project
- `just test` runs tests
- All Nushell scripts execute without errors
- Documentation explains how to use each command

## References
- dgx-pixels justfile
- IMPLEMENTATION_PROPOSAL.md section "Automation: Justfile + Nushell"
```

---

### Issue #3: k3d Cluster Setup

**Title:** Bootstrap: Set up k3d local Kubernetes cluster
**Labels:** `phase-0`, `bootstrap`, `k3s`, `infrastructure`
**Assignee:** DevOps Engineer
**Duration:** 1 day

**Description:**
```markdown
## Goal
Create reproducible k3d cluster for local development

## Tasks
- [ ] Install k3d (if not installed)
- [ ] Create cluster configuration file
- [ ] Implement `just k3d-create` command
- [ ] Implement `just k3d-destroy` command
- [ ] Test cluster creation/destruction cycle
- [ ] Verify kubectl access to cluster
- [ ] Create namespace: `sparky`
- [ ] Document cluster setup

## Acceptance Criteria
- `just k3d-create` creates cluster successfully
- `kubectl get nodes` shows cluster running
- `kubectl get namespace sparky` exists
- `just k3d-destroy` cleans up completely
- Documented in README

## References
- dgx-pixels k3s patterns
- k3d documentation
```

---

### Issue #4: Docker Images & Ollama Deployment

**Title:** Bootstrap: Create Docker images and deploy Ollama to k3s
**Labels:** `phase-0`, `bootstrap`, `docker`, `ollama`
**Assignee:** DevOps Engineer
**Duration:** 2 days

**Description:**
```markdown
## Goal
Create Dockerfiles and deploy Ollama for local testing

## Tasks
- [ ] Create multi-stage Dockerfile for Rust services
- [ ] Test Docker build locally
- [ ] Create Ollama k8s manifest (deployment + service)
- [ ] Deploy Ollama to k3d cluster
- [ ] Verify Ollama accessible from cluster
- [ ] Pull qwen2.5-coder:1.5b model
- [ ] Test model inference
- [ ] Document deployment process

## Acceptance Criteria
- `just docker-build` creates images
- Ollama pod running in k3d cluster
- Model loaded and responding to test prompts
- Service accessible at `http://ollama.sparky.svc.cluster.local:11434`
- Documented in deployment guide

## References
- dgx-spark-playbooks Ollama deployment
- IMPLEMENTATION_PROPOSAL.md section "Deployment: k3s with k3d"
```

---

## Phase 1: Core Services (Days 6-25)

**Gate:** Phase 0 complete (infrastructure ready)

### Issue #5: Collector Service Implementation

**Title:** Phase 1 WS1: Implement sparky-collector service
**Labels:** `phase-1`, `workstream-1`, `rust`, `collector`
**Assignee:** Backend Developer 1
**Duration:** 8 days
**Parallel With:** Issues #6, #7, #8

**Description:**
```markdown
## Goal
Implement data collection service using GitHub CLI

## Tasks
- [ ] Define data models (Commit, PR, Issue, etc.) in sparky-common
- [ ] Implement GitHub CLI wrapper
- [ ] Implement collection logic:
  - [ ] List repositories
  - [ ] Collect commits (last 24h)
  - [ ] Collect PRs (merged, last 24h)
  - [ ] Collect issues (updated, last 24h)
- [ ] Implement JSON storage
- [ ] Add ZeroMQ command handling:
  - [ ] REQ-REP for commands
  - [ ] PUB for events
- [ ] Write unit tests (90%+ coverage)
- [ ] Integration test with real GitHub CLI
- [ ] Error handling and retries
- [ ] Logging and metrics
- [ ] Documentation

## Acceptance Criteria
- `cargo test -p sparky-collector` passes (90%+ coverage)
- Service starts and responds to health check
- Can collect data from raibid-labs repos
- Emits `CollectionComplete` event
- JSON files saved to correct location
- Handles errors gracefully

## File Ownership
- `crates/sparky-collector/`
- `crates/sparky-common/src/models.rs` (data models)

## References
- docs/examples/collect-gh.sh (bash version to replicate)
- IMPLEMENTATION_PROPOSAL.md section "Data Collector"
```

---

### Issue #6: Analyzer Service Implementation

**Title:** Phase 1 WS2: Implement sparky-analyzer service
**Labels:** `phase-1`, `workstream-2`, `rust`, `analyzer`
**Assignee:** Backend Developer 2
**Duration:** 8 days
**Parallel With:** Issues #5, #7, #8

**Description:**
```markdown
## Goal
Implement analysis service with Ollama integration

## Tasks
- [ ] Implement Ollama API client
- [ ] Implement statistical analysis:
  - [ ] Calculate commit metrics
  - [ ] Identify top contributors
  - [ ] Find active repositories
  - [ ] Detect patterns
- [ ] Implement LLM-based semantic analysis:
  - [ ] Prompt engineering
  - [ ] Call Ollama API
  - [ ] Parse responses
- [ ] Generate insights JSON
- [ ] Add ZeroMQ command handling
- [ ] Write unit tests (90%+ coverage)
- [ ] Mock Ollama for testing
- [ ] Error handling
- [ ] Logging and metrics
- [ ] Documentation

## Acceptance Criteria
- `cargo test -p sparky-analyzer` passes (90%+ coverage)
- Service starts and responds to health check
- Can analyze sample data
- Generates meaningful insights
- Ollama integration working
- Emits `AnalysisComplete` event

## File Ownership
- `crates/sparky-analyzer/`
- `crates/sparky-common/src/insights.rs`

## References
- docs/examples/analyze-ollama.py (Python version to replicate)
- research/git-commit-summarization-oss-models.md (prompts)
```

---

### Issue #7: Generator Service Implementation

**Title:** Phase 1 WS3: Implement sparky-generator service
**Labels:** `phase-1`, `workstream-3`, `rust`, `generator`
**Assignee:** Backend Developer 3
**Duration:** 8 days
**Parallel With:** Issues #5, #6, #8

**Description:**
```markdown
## Goal
Implement content generation service with templates

## Tasks
- [ ] Design template system
- [ ] Implement Markdown formatter
- [ ] Create content generation logic:
  - [ ] Daily digest (200-300 words)
  - [ ] Weekly report (800-1200 words)
  - [ ] Monthly review (2000-3000 words)
- [ ] Integrate with Ollama for AI-powered content
- [ ] Add ZeroMQ command handling
- [ ] Write unit tests (90%+ coverage)
- [ ] Test with sample data
- [ ] Error handling
- [ ] Logging and metrics
- [ ] Documentation

## Acceptance Criteria
- `cargo test -p sparky-generator` passes (90%+ coverage)
- Service starts and responds to health check
- Generates well-formatted markdown
- Content quality matches examples
- Emits `GenerationComplete` event
- Templates are customizable

## File Ownership
- `crates/sparky-generator/`
- `templates/` directory

## References
- docs/examples/claude-code-agent.yml (style guide)
- output/daily/ examples (format reference)
```

---

### Issue #8: Publisher Service Implementation

**Title:** Phase 1 WS4: Implement sparky-publisher service
**Labels:** `phase-1`, `workstream-4`, `rust`, `publisher`
**Assignee:** Backend Developer 4
**Duration:** 8 days
**Parallel With:** Issues #5, #6, #7

**Description:**
```markdown
## Goal
Implement publishing service for git operations

## Tasks
- [ ] Implement git operations using git2-rs:
  - [ ] Add files
  - [ ] Commit with message
  - [ ] Push to remote
- [ ] Support multiple destinations:
  - [ ] Local repository
  - [ ] docs repository (submodule)
  - [ ] (Optional) External platforms
- [ ] Add ZeroMQ command handling
- [ ] Write unit tests (90%+ coverage)
- [ ] Test git operations in sandbox
- [ ] Error handling and retries
- [ ] Logging and metrics
- [ ] Documentation

## Acceptance Criteria
- `cargo test -p sparky-publisher` passes (90%+ coverage)
- Service starts and responds to health check
- Can commit and push files
- Handles git errors gracefully
- Emits `PublishComplete` event
- Supports dry-run mode for testing

## File Ownership
- `crates/sparky-publisher/`

## References
- dgx-pixels git automation patterns
- git2-rs documentation
```

---

## Phase 2: Orchestration (Days 14-25)

**Gate:** Phase 1 services functional
**Note:** Can start Day 14 (overlaps with Phase 1)

### Issue #9: Meta Orchestrator Implementation

**Title:** Phase 2 WS5: Implement meta orchestrator
**Labels:** `phase-2`, `workstream-5`, `rust`, `orchestrator`
**Assignee:** Senior Developer
**Duration:** 10 days
**Depends On:** Issues #5, #6, #7, #8 (at least partially complete)

**Description:**
```markdown
## Goal
Implement central orchestrator that coordinates all services

## Tasks
- [ ] Design orchestration state machine
- [ ] Implement ZeroMQ REQ-REP pattern for commands
- [ ] Implement ZeroMQ PUB-SUB pattern for events
- [ ] Implement scheduling:
  - [ ] Daily collection (cron-like)
  - [ ] Weekly summary
  - [ ] Monthly review
- [ ] Implement phase gates
- [ ] Implement workstream coordination
- [ ] Add service health monitoring
- [ ] Write unit tests (90%+ coverage)
- [ ] Integration tests with mock services
- [ ] Error handling
- [ ] Logging and metrics
- [ ] Documentation

## Acceptance Criteria
- `cargo test -p sparky-orchestrator` passes (90%+ coverage)
- Can coordinate all services
- Enforces phase gates
- Health monitoring functional
- Events flow correctly
- Schedules jobs accurately

## File Ownership
- `crates/sparky-orchestrator/`
- `crates/sparky-common/src/messages.rs`
- `crates/sparky-common/src/zeromq.rs`

## References
- dgx-pixels meta-orchestrator.md
- DGX_PIXELS_ORCHESTRATION_PATTERNS.md
```

---

### Issue #10: ZeroMQ Event System

**Title:** Phase 2 WS6: Implement ZeroMQ event bus
**Labels:** `phase-2`, `workstream-6`, `rust`, `zeromq`
**Assignee:** Backend Developer
**Duration:** 5 days
**Depends On:** Issue #9 (started)

**Description:**
```markdown
## Goal
Implement robust ZeroMQ communication layer

## Tasks
- [ ] Define all message types in sparky-common
- [ ] Implement REQ-REP helper functions
- [ ] Implement PUB-SUB helper functions
- [ ] Add serialization (MessagePack)
- [ ] Add error handling and retries
- [ ] Write comprehensive tests
- [ ] Performance testing
- [ ] Documentation

## Acceptance Criteria
- All services can communicate via ZeroMQ
- < 1ms message latency
- Handles network errors gracefully
- Tests verify message delivery
- Well-documented API

## File Ownership
- `crates/sparky-common/src/zeromq.rs`
- `crates/sparky-common/src/messages.rs`

## References
- dgx-pixels ZeroMQ patterns
```

---

## Phase 3: Integration (Days 26-40)

**Gate:** Phase 2 complete (all services coordinated)

### Issue #11: Integration Testing

**Title:** Phase 3 WS7: Implement integration tests
**Labels:** `phase-3`, `workstream-7`, `testing`
**Assignee:** QA Engineer
**Duration:** 10 days

**Description:**
```markdown
## Goal
Comprehensive integration testing of full pipeline

## Tasks
- [ ] Create test fixtures (sample data)
- [ ] Implement end-to-end tests:
  - [ ] Daily collection → analysis → generation → publish
  - [ ] Weekly summary pipeline
  - [ ] Error scenarios
- [ ] Set up test environment with Docker Compose
- [ ] Implement load tests
- [ ] Performance benchmarking
- [ ] Document test procedures

## Acceptance Criteria
- All integration tests pass
- Test coverage > 85%
- Performance meets targets
- Load tests validate scalability
- CI pipeline runs tests automatically

## File Ownership
- `tests/integration/`
- `tests/fixtures/`
- `.github/workflows/ci.yml`
```

---

### Issue #12: Kubernetes Deployment Manifests

**Title:** Phase 3 WS8: Create k8s deployment manifests
**Labels:** `phase-3`, `workstream-8`, `k8s`, `infrastructure`
**Assignee:** DevOps Engineer
**Duration:** 8 days

**Description:**
```markdown
## Goal
Production-ready Kubernetes manifests

## Tasks
- [ ] Create manifests for all services:
  - [ ] Namespace
  - [ ] Deployments
  - [ ] Services
  - [ ] ConfigMaps
  - [ ] Secrets (templates)
- [ ] Create Ollama deployment with PVC
- [ ] Set up resource limits
- [ ] Configure health checks
- [ ] Test deployment to k3d
- [ ] Document deployment process

## Acceptance Criteria
- `kubectl apply -k k8s/` deploys everything
- All pods running and healthy
- Services accessible
- Ollama persistent storage working
- Documented deployment guide

## File Ownership
- `k8s/` directory
- `scripts/k3s/deploy-local.nu`
- `scripts/k3s/deploy-production.nu`
```

---

### Issue #13: Configuration Management

**Title:** Phase 3 WS9: Implement configuration management
**Labels:** `phase-3`, `workstream-9`, `configuration`
**Assignee:** Backend Developer
**Duration:** 5 days

**Description:**
```markdown
## Goal
Flexible configuration for different environments

## Tasks
- [ ] Create configuration schema
- [ ] Implement config loading in all services
- [ ] Create environment-specific configs:
  - [ ] development.toml
  - [ ] production.toml
- [ ] Support environment variables
- [ ] Validate configurations
- [ ] Document configuration options

## Acceptance Criteria
- All services read config correctly
- Environment variables override file config
- Invalid configs rejected with clear errors
- Well-documented configuration options

## File Ownership
- `config/` directory
- Config loading code in each service
```

---

## Phase 4: Production (Days 41-60)

**Gate:** Phase 3 complete (integration verified)

### Issue #14: k3s Production Deployment

**Title:** Phase 4 WS10: Deploy to production k3s on DGX
**Labels:** `phase-4`, `workstream-10`, `production`, `k3s`
**Assignee:** DevOps Engineer
**Duration:** 10 days

**Description:**
```markdown
## Goal
Deploy Sparky to production k3s cluster on DGX

## Tasks
- [ ] Use k3sup to install k3s on DGX (if not already)
- [ ] Configure kubectl access
- [ ] Deploy Ollama with GPU support
- [ ] Deploy all Sparky services
- [ ] Verify GPU access from Ollama pod
- [ ] Configure persistent storage
- [ ] Set up TLS/certificates
- [ ] Test production deployment
- [ ] Document deployment process

## Acceptance Criteria
- All services running on DGX k3s
- Ollama using GPU successfully
- Daily pipeline executes automatically
- Persistent storage working
- Monitoring collecting metrics
- Runbook documents operations

## File Ownership
- Deployment scripts for production
- Production configuration
```

---

### Issue #15: Monitoring and Alerting

**Title:** Phase 4 WS11: Implement monitoring and alerting
**Labels:** `phase-4`, `workstream-11`, `monitoring`, `observability`
**Assignee:** DevOps Engineer
**Duration:** 8 days

**Description:**
```markdown
## Goal
Production monitoring and alerting system

## Tasks
- [ ] Set up Prometheus
- [ ] Instrument all services with metrics
- [ ] Create Grafana dashboards
- [ ] Set up alerting rules:
  - [ ] Service down
  - [ ] Pipeline failures
  - [ ] High error rates
- [ ] Configure notifications (email, Slack)
- [ ] Document monitoring setup

## Acceptance Criteria
- Prometheus scraping all services
- Grafana dashboards showing metrics
- Alerts trigger on failures
- Notifications working
- Documented monitoring guide

## File Ownership
- `monitoring/` directory
- Prometheus/Grafana configs
```

---

### Issue #16: Documentation and Runbooks

**Title:** Phase 4 WS12: Complete documentation and runbooks
**Labels:** `phase-4`, `workstream-12`, `documentation`
**Assignee:** Technical Writer
**Duration:** 10 days

**Description:**
```markdown
## Goal
Comprehensive documentation for operators and developers

## Tasks
- [ ] Update README with production info
- [ ] Create operator runbooks:
  - [ ] Deployment procedures
  - [ ] Troubleshooting guide
  - [ ] Common issues and solutions
  - [ ] Backup and recovery
- [ ] Create developer guides:
  - [ ] Contributing guide
  - [ ] Architecture overview
  - [ ] API documentation
  - [ ] Testing guide
- [ ] Generate API docs with rustdoc
- [ ] Create video walkthrough (optional)

## Acceptance Criteria
- All documentation up-to-date
- Runbooks cover common scenarios
- Developer guide enables contributions
- API docs generated and published
- README has complete setup instructions

## File Ownership
- `README.md`
- `docs/` directory
- `CONTRIBUTING.md`
```

---

## Phase 5: Enhancements (Days 61-70, Optional)

**Gate:** Phase 4 complete (production deployed)

### Issue #17: Web Dashboard (Optional)

**Title:** Phase 5 WS13: Build web dashboard for Sparky
**Labels:** `phase-5`, `workstream-13`, `enhancement`, `frontend`
**Assignee:** Frontend Developer
**Duration:** 10 days

**Description:**
```markdown
## Goal
Web UI for viewing digests and managing Sparky

## Tasks
- [ ] Choose framework (e.g., Leptos, Yew, Dioxus)
- [ ] Create dashboard views:
  - [ ] Latest digests
  - [ ] Historical view
  - [ ] Statistics
  - [ ] Pipeline status
- [ ] Add REST API to orchestrator
- [ ] Deploy dashboard to k8s
- [ ] Document usage

## Acceptance Criteria
- Dashboard accessible via browser
- Shows latest digests
- Real-time pipeline status
- Responsive design
- Documented

## File Ownership
- `crates/sparky-dashboard/`
- API endpoints in orchestrator
```

---

### Issue #18: Additional Content Formats (Optional)

**Title:** Phase 5 WS14: Add blog posts and social media generation
**Labels:** `phase-5`, `workstream-14`, `enhancement`
**Assignee:** Backend Developer
**Duration:** 8 days

**Description:**
```markdown
## Goal
Generate additional content formats beyond basic digests

## Tasks
- [ ] Implement blog post generator:
  - [ ] Long-form content (1500-2500 words)
  - [ ] SEO optimization
  - [ ] Featured images
- [ ] Implement social media posts:
  - [ ] Twitter/X format
  - [ ] LinkedIn format
  - [ ] Dev.to format
- [ ] Add publishing to external platforms
- [ ] Test and validate quality

## Acceptance Criteria
- Blog posts generated successfully
- Social media posts formatted correctly
- External publishing working (optional)
- Quality matches standards

## File Ownership
- Additional modules in sparky-generator
- New templates
```

---

## Issue Creation Workflow

### Step 1: Create Issues

```bash
# Use GitHub CLI to create issues
gh issue create --title "Bootstrap: Create Cargo workspace" \
  --label "phase-0,bootstrap,rust" \
  --body-file .github/issue-templates/issue-01.md

# Or use Nushell script
nu scripts/issues/create-all-issues.nu
```

### Step 2: Assign Issues

Assign to agents or developers:
- Issues #5-8: Can be done in parallel (Phase 1)
- Issue #9: Depends on #5-8 starting
- Issue #10: Depends on #9 starting
- Issues #11-13: Can be done in parallel after Phase 2

### Step 3: Track Progress

Use GitHub Projects board with columns:
- Todo
- In Progress
- Blocked
- Review
- Done

### Step 4: Phase Gates

Before moving to next phase:
- Review all issues in current phase
- Ensure acceptance criteria met
- Run integration tests
- Get approval from tech lead

---

## Parallelization Benefits

### Without Parallelization (Sequential)
```
Phase 0: 5 days
Phase 1: 32 days (4 workstreams × 8 days each)
Phase 2: 15 days
Phase 3: 23 days
Phase 4: 28 days
Total: 103 days (~3.5 months)
```

### With Parallelization (This Plan)
```
Phase 0: 5 days
Phase 1: 8 days (4 workstreams in parallel)
Phase 2: 10 days (overlaps with Phase 1)
Phase 3: 15 days (some parallel work)
Phase 4: 20 days (some parallel work)
Total: 60 days (~2 months)
```

**Time Saved: 43 days (42%)**

---

## Communication and Coordination

### Daily Standups (Async)

Each workstream posts daily update to GitHub issue:
```markdown
## Update - 2025-11-13
- ✅ Completed: Unit tests for collector
- 🔄 In Progress: Integration with GitHub CLI
- ⏳ Blocked: Waiting for data models in sparky-common
- 📋 Next: Implement JSON storage
```

### Weekly Sync

All workstreams meet to:
- Review progress
- Identify blockers
- Coordinate cross-workstream dependencies
- Plan next week

### Slack/Discord Channels

- `#sparky-general`: General discussion
- `#sparky-phase-1`: Phase 1 coordination
- `#sparky-phase-2`: Phase 2 coordination
- `#sparky-blockers`: Report blockers immediately

---

## Risk Management

### Risk: Workstreams out of sync

**Mitigation:** Daily async updates, clear file ownership, phase gates

### Risk: Integration issues

**Mitigation:** Early integration testing (Phase 2 overlaps Phase 1), ZeroMQ message contracts defined upfront

### Risk: Performance issues

**Mitigation:** Load testing in Phase 3, performance benchmarks in CI

### Risk: Ollama inference too slow

**Mitigation:** Upgrade path to vLLM documented, fallback to rule-based analysis

---

## Success Metrics

### Development Velocity
- Issues closed per week
- Phase completion rate
- Blocker resolution time

### Quality Metrics
- Test coverage > 85%
- CI pipeline pass rate > 95%
- Zero critical bugs in production

### Production Metrics
- Daily pipeline success rate > 99%
- Content generation time < 5 minutes
- Zero downtime deployments

---

**Status:** Ready for issue creation and workstream launch
**Last Updated:** 2025-11-12
