# Sparky Implementation Proposal

**Version:** 3.0 (Rust + k3s + Nushell + Justfile)
**Date:** 2025-11-12
**Based on:** dgx-pixels orchestration patterns

## Executive Summary

Sparky will be implemented using:
- **Rust** for core services (collection, analysis, generation)
- **Nushell** for automation and scripting
- **Justfile** for build/test/demo workflows
- **k3s (via k3d)** for local Kubernetes deployment
- **Ollama** for zero-cost LLM inference
- **GitHub CLI** for data collection

**Timeline:** 60-70 days with 4 parallel workstreams
**Cost:** $0/month (100% OSS stack)
**Infrastructure:** Deploys on existing DGX with k3s

---

## Architecture (Rust-Based)

### High-Level Design

```
┌──────────────────────────────────────────────────────────┐
│              Meta Orchestrator (Rust)                     │
│  - Workstream coordination                                │
│  - Phase gate management                                  │
│  - Event-driven scheduling                                │
└───────────────────────┬──────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┬─────────────────┐
        │               │               │                 │
        ▼               ▼               ▼                 ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ Collector    │ │ Analyzer     │ │ Generator    │ │ Publisher    │
│ (Rust)       │ │ (Rust)       │ │ (Rust)       │ │ (Rust)       │
└──────┬───────┘ └──────┬───────┘ └──────┬───────┘ └──────┬───────┘
       │                │                │                │
       └────────────────┴────────────────┴────────────────┘
                        │
                   ZeroMQ IPC
                        │
       ┌────────────────┴────────────────┐
       │                                  │
       ▼                                  ▼
┌──────────────┐                  ┌──────────────┐
│ GitHub CLI   │                  │ Ollama       │
│ (External)   │                  │ (External)   │
└──────────────┘                  └──────────────┘
```

### Component Breakdown

#### 1. Meta Orchestrator (`sparky-orchestrator`)
**Language:** Rust
**Purpose:** Coordinate all workstreams, manage phase gates

**Key Modules:**
```rust
sparky-orchestrator/
├── src/
│   ├── main.rs              // Entry point
│   ├── orchestrator.rs      // Main orchestration logic
│   ├── phase_gates.rs       // Phase gate management
│   ├── workstream.rs        // Workstream coordination
│   ├── events.rs            // Event system (ZeroMQ)
│   └── config.rs            // Configuration management
├── Cargo.toml
└── tests/
```

**Responsibilities:**
- Schedule collection jobs (daily, weekly, monthly)
- Coordinate parallel workstreams
- Enforce phase gates
- Monitor service health
- Emit events for coordination

#### 2. Data Collector (`sparky-collector`)
**Language:** Rust
**Purpose:** Collect git data from raibid-labs repos

**Key Modules:**
```rust
sparky-collector/
├── src/
│   ├── main.rs              // Service entry
│   ├── github_client.rs     // GitHub CLI wrapper
│   ├── models.rs            // Data models (commits, PRs, issues)
│   ├── storage.rs           // JSON file storage
│   └── collector.rs         // Collection logic
├── Cargo.toml
└── tests/
```

**Responsibilities:**
- Query GitHub CLI for repo data
- Parse and structure data
- Save to JSON files
- Emit collection-complete events

#### 3. Analyzer (`sparky-analyzer`)
**Language:** Rust
**Purpose:** Analyze collected data and generate insights

**Key Modules:**
```rust
sparky-analyzer/
├── src/
│   ├── main.rs              // Service entry
│   ├── ollama_client.rs     // Ollama API wrapper
│   ├── analyzer.rs          // Analysis logic
│   ├── metrics.rs           // Statistical calculations
│   └── insights.rs          // Insight generation
├── Cargo.toml
└── tests/
```

**Responsibilities:**
- Load collected data
- Calculate metrics (commits/day, top contributors)
- Call Ollama for semantic analysis
- Generate insights JSON

#### 4. Content Generator (`sparky-generator`)
**Language:** Rust
**Purpose:** Generate markdown content from analysis

**Key Modules:**
```rust
sparky-generator/
├── src/
│   ├── main.rs              // Service entry
│   ├── ollama_client.rs     // Ollama API wrapper
│   ├── generator.rs         // Content generation
│   ├── templates.rs         // Template management
│   └── formatters.rs        // Markdown formatting
├── Cargo.toml
└── tests/
```

**Responsibilities:**
- Load analysis data
- Generate daily/weekly/monthly content
- Format as markdown
- Save to output files

#### 5. Publisher (`sparky-publisher`)
**Language:** Rust
**Purpose:** Publish content to git, docs repo, etc.

**Key Modules:**
```rust
sparky-publisher/
├── src/
│   ├── main.rs              // Service entry
│   ├── git.rs               // Git operations
│   ├── publisher.rs         // Publishing logic
│   └── destinations.rs      // Publish destinations
├── Cargo.toml
└── tests/
```

**Responsibilities:**
- Commit content to repository
- Push to docs repository
- Optionally publish to external platforms

---

## Communication: ZeroMQ Pattern

Following dgx-pixels patterns, use ZeroMQ for IPC:

### REQ-REP Pattern (Commands)
```rust
// Orchestrator sends command
let request = Command::Collect { date: "2025-11-12" };
orchestrator.send(&request)?;
let response = orchestrator.recv()?; // Wait for completion

// Collector receives and responds
let command = collector.recv()?;
match command {
    Command::Collect { date } => {
        collect_data(&date)?;
        collector.send(&Response::Success)?;
    }
}
```

### PUB-SUB Pattern (Events)
```rust
// Services publish events
collector.publish(Event::CollectionComplete {
    date: "2025-11-12",
    commit_count: 127
})?;

// Orchestrator subscribes to all events
orchestrator.subscribe("*")?;
loop {
    let event = orchestrator.recv_event()?;
    handle_event(event)?;
}
```

### Shared Crate: `sparky-common`
```rust
sparky-common/
├── src/
│   ├── lib.rs
│   ├── messages.rs         // Command/Event definitions
│   ├── models.rs           // Shared data models
│   └── zeromq.rs           // ZeroMQ helpers
└── Cargo.toml
```

---

## Deployment: k3s with k3d

### Local Development (k3d)

```bash
# Create k3s cluster
just k3d-create

# Deploy services
just deploy-local

# Monitor
just status
```

### Production (k3s on DGX)

```bash
# Use k3sup to install k3s
just k3s-install-dgx

# Deploy to DGX
just deploy-production

# Monitor
just logs-follow
```

### Kubernetes Manifests

```
k8s/
├── namespace.yaml
├── orchestrator/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
├── collector/
│   ├── deployment.yaml
│   └── service.yaml
├── analyzer/
│   ├── deployment.yaml
│   └── service.yaml
├── generator/
│   ├── deployment.yaml
│   └── service.yaml
├── publisher/
│   ├── deployment.yaml
│   └── service.yaml
└── ollama/
    ├── deployment.yaml
    ├── service.yaml
    └── pvc.yaml
```

---

## Automation: Justfile + Nushell

### Justfile Structure

```make
# justfile

# Default: Show available commands
default:
    @just --list

# === Building ===
build:
    cargo build --release

build-all:
    cargo build --release --workspace

test:
    cargo test --workspace

# === Development ===
dev-orchestrator:
    cargo run --bin sparky-orchestrator

dev-collector:
    cargo run --bin sparky-collector

# === Docker ===
docker-build:
    nu scripts/docker/build.nu

docker-push:
    nu scripts/docker/push.nu

# === k3s/k3d ===
k3d-create:
    nu scripts/k3s/create-cluster.nu

k3d-destroy:
    nu scripts/k3s/destroy-cluster.nu

deploy-local:
    nu scripts/k3s/deploy-local.nu

# === Production ===
k3s-install-dgx:
    nu scripts/k3s/install-dgx.nu

deploy-production:
    nu scripts/k3s/deploy-production.nu

# === Data Collection ===
collect-today:
    nu scripts/collect.nu --date (date now | format date "%Y-%m-%d")

collect-weekly:
    nu scripts/collect.nu --mode weekly

# === Testing ===
test-collection:
    nu scripts/test/test-collection.nu

test-analysis:
    nu scripts/test/test-analysis.nu

test-end-to-end:
    nu scripts/test/test-e2e.nu

# === Monitoring ===
status:
    nu scripts/monitor/status.nu

logs-follow:
    nu scripts/monitor/logs.nu --follow

# === Demo ===
demo:
    nu scripts/demo/run-demo.nu

demo-daily:
    nu scripts/demo/daily-digest.nu

# === Cleanup ===
clean:
    cargo clean
    rm -rf data/raw/* data/processed/* output/*

# === Git Operations ===
git-commit:
    nu scripts/git/commit.nu

git-push:
    nu scripts/git/push.nu
```

### Nushell Scripts

```
scripts/
├── collect.nu              # Data collection
├── analyze.nu              # Analysis orchestration
├── generate.nu             # Content generation
├── publish.nu              # Publishing
├── config.nu               # Configuration management
├── docker/
│   ├── build.nu
│   └── push.nu
├── k3s/
│   ├── create-cluster.nu
│   ├── destroy-cluster.nu
│   ├── deploy-local.nu
│   ├── deploy-production.nu
│   └── install-dgx.nu
├── test/
│   ├── test-collection.nu
│   ├── test-analysis.nu
│   └── test-e2e.nu
├── monitor/
│   ├── status.nu
│   └── logs.nu
├── demo/
│   ├── run-demo.nu
│   └── daily-digest.nu
└── git/
    ├── commit.nu
    └── push.nu
```

---

## Project Structure

```
sparky/
├── Cargo.toml                    # Workspace manifest
├── justfile                      # Task automation
├── README.md
├── IMPLEMENTATION_PROPOSAL.md    # This file
├── docker-compose.yml            # Local development
├── Dockerfile                    # Multi-stage build
│
├── crates/
│   ├── sparky-common/            # Shared library
│   ├── sparky-orchestrator/      # Main orchestrator
│   ├── sparky-collector/         # Data collector
│   ├── sparky-analyzer/          # Analysis engine
│   ├── sparky-generator/         # Content generator
│   └── sparky-publisher/         # Publisher
│
├── scripts/                      # Nushell automation
│   ├── collect.nu
│   ├── analyze.nu
│   └── ... (see above)
│
├── k8s/                          # Kubernetes manifests
│   ├── namespace.yaml
│   ├── orchestrator/
│   ├── collector/
│   └── ... (see above)
│
├── config/                       # Configuration files
│   ├── development.toml
│   ├── production.toml
│   └── ollama.toml
│
├── data/                         # Data storage
│   ├── raw/                      # Collected data
│   ├── processed/                # Analyzed data
│   └── cache/                    # Cached results
│
├── output/                       # Generated content
│   ├── daily/
│   ├── weekly/
│   └── monthly/
│
├── docs/                         # Documentation
│   └── ... (existing docs)
│
└── tests/                        # Integration tests
    ├── fixtures/
    └── integration/
```

---

## Phase Gates and Workstreams

### Phase 0: Bootstrap (Days 1-5)
**Gate:** Infrastructure and tooling ready

**Workstreams:**
1. Project scaffolding (Cargo workspace, Justfile, Nushell scripts)
2. k3d cluster setup and testing
3. Docker images for Ollama and services
4. Basic CI/CD pipeline

### Phase 1: Core Services (Days 6-25) - 4 Parallel Workstreams

**Gate:** All services can run independently

#### Workstream 1: Collector Service (Days 6-13)
- Rust service with GitHub CLI integration
- Data models and JSON storage
- ZeroMQ command handling
- Unit tests (90%+ coverage)

#### Workstream 2: Analyzer Service (Days 6-13)
- Rust service with Ollama client
- Statistical analysis
- LLM-based semantic analysis
- Unit tests (90%+ coverage)

#### Workstream 3: Generator Service (Days 6-13)
- Rust service for content generation
- Template system
- Markdown formatting
- Unit tests (90%+ coverage)

#### Workstream 4: Publisher Service (Days 6-13)
- Rust service for git operations
- Multi-destination publishing
- Error handling and retries
- Unit tests (90%+ coverage)

### Phase 2: Orchestration (Days 14-25) - Depends on Phase 1

**Gate:** Orchestrator coordinates all services

**Workstreams:**
5. Meta orchestrator implementation
6. ZeroMQ event system
7. Phase gate enforcement
8. Health monitoring and dashboards

### Phase 3: Integration (Days 26-40)

**Gate:** End-to-end pipeline works

**Workstreams:**
9. Integration tests
10. k8s deployment manifests
11. Configuration management
12. Performance optimization

### Phase 4: Production (Days 41-60)

**Gate:** Production-ready deployment

**Workstreams:**
13. k3s production deployment
14. Monitoring and alerting
15. Documentation and runbooks
16. CI/CD automation

### Phase 5: Enhancements (Days 61-70)

**Optional workstreams:**
17. Web dashboard (optional)
18. Additional content formats (optional)

---

## Development Workflow

### Day-to-Day Development

```bash
# Start local k3d cluster
just k3d-create

# Deploy Ollama
just deploy-ollama

# Run services in dev mode
just dev-orchestrator   # Terminal 1
just dev-collector      # Terminal 2
just dev-analyzer       # Terminal 3

# Test collection
just collect-today

# Run tests
just test

# Build everything
just build-all
```

### Testing Workflow

```bash
# Unit tests
cargo test --workspace

# Integration tests
just test-end-to-end

# Load testing
just test-load
```

### Deployment Workflow

```bash
# Build Docker images
just docker-build

# Push to registry
just docker-push

# Deploy to k3s
just deploy-production

# Monitor
just status
just logs-follow
```

---

## Dependencies

### Rust Crates

```toml
[workspace.dependencies]
# Async runtime
tokio = { version = "1", features = ["full"] }

# HTTP/API clients
reqwest = { version = "0.11", features = ["json"] }

# Serialization
serde = { version = "1", features = ["derive"] }
serde_json = "1"

# ZeroMQ
zeromq = "0.3"

# Configuration
config = "0.13"
toml = "0.8"

# CLI
clap = { version = "4", features = ["derive"] }

# Error handling
anyhow = "1"
thiserror = "1"

# Logging
tracing = "0.1"
tracing-subscriber = "0.3"

# Git operations
git2 = "0.18"

# Testing
mockall = "0.12"
```

### System Dependencies

- **Rust:** 1.75+ (stable)
- **Nushell:** 0.88+ (for scripts)
- **Just:** 1.20+ (task runner)
- **Docker:** 24.0+ (containerization)
- **k3d:** 5.6+ (local k3s)
- **k3sup:** 0.13+ (k3s installation)
- **GitHub CLI:** 2.40+ (data collection)
- **Ollama:** 0.1.20+ (LLM inference)

---

## Configuration Management

### Environment-Specific Configs

```toml
# config/development.toml
[orchestrator]
bind_address = "0.0.0.0:5555"
event_port = 5556

[collector]
github_org = "raibid-labs"
data_dir = "./data/raw"
cache_ttl = 3600

[analyzer]
ollama_url = "http://localhost:11434"
model = "qwen2.5-coder:1.5b"

[generator]
ollama_url = "http://localhost:11434"
output_dir = "./output"

[publisher]
git_repo = "./output"
auto_push = false
```

```toml
# config/production.toml
[orchestrator]
bind_address = "0.0.0.0:5555"
event_port = 5556

[collector]
github_org = "raibid-labs"
data_dir = "/data/raw"
cache_ttl = 3600

[analyzer]
ollama_url = "http://ollama.sparky.svc.cluster.local:11434"
model = "qwen2.5-coder:1.5b"

[generator]
ollama_url = "http://ollama.sparky.svc.cluster.local:11434"
output_dir = "/output"

[publisher]
git_repo = "/output"
auto_push = true
docs_repo_url = "git@github.com:raibid-labs/docs.git"
```

---

## Monitoring and Observability

### Metrics (Prometheus)

```rust
// Each service exposes metrics
use prometheus::{Counter, Histogram, Registry};

pub struct Metrics {
    pub requests_total: Counter,
    pub request_duration: Histogram,
    pub errors_total: Counter,
}
```

### Health Checks

```rust
// /health endpoint for k8s
#[get("/health")]
async fn health() -> &'static str {
    "OK"
}

// /ready endpoint for k8s
#[get("/ready")]
async fn ready() -> Result<&'static str> {
    check_dependencies().await?;
    Ok("READY")
}
```

### Logging

```rust
// Structured logging with tracing
use tracing::{info, warn, error, instrument};

#[instrument(skip(self))]
async fn collect_data(&self, date: &str) -> Result<()> {
    info!(date = %date, "Starting data collection");
    // ...
    info!(commit_count = commits.len(), "Collection complete");
    Ok(())
}
```

---

## Testing Strategy

### Unit Tests (90%+ Coverage)

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_commit() {
        let json = r#"{"sha": "abc123", "author": "test"}"#;
        let commit = parse_commit(json).unwrap();
        assert_eq!(commit.sha, "abc123");
    }

    #[tokio::test]
    async fn test_collect_repos() {
        let collector = Collector::new_mock();
        let repos = collector.collect().await.unwrap();
        assert!(!repos.is_empty());
    }
}
```

### Integration Tests

```rust
// tests/integration/pipeline_test.rs
#[tokio::test]
async fn test_full_pipeline() {
    // Start services
    let orchestrator = spawn_orchestrator().await;
    let collector = spawn_collector().await;

    // Trigger collection
    orchestrator.send(Command::Collect { date: "2025-11-12" }).await?;

    // Wait for completion
    let event = orchestrator.wait_for_event().await?;
    assert!(matches!(event, Event::CollectionComplete { .. }));
}
```

### Load Tests

```bash
# Use k6 or similar
just test-load
```

---

## CI/CD Pipeline

### GitHub Actions

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - run: cargo test --workspace

  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: cargo build --release --workspace

  docker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/raibid-labs/sparky:${{ github.sha }}
```

---

## Cost Analysis

### Development Costs

```
Rust toolchain:     $0 (open source)
Nushell:            $0 (open source)
Just:               $0 (open source)
k3d:                $0 (open source)
Docker:             $0 (open source)
Ollama:             $0 (open source)
GitHub CLI:         $0 (free)
```

### Infrastructure Costs

```
k3s on DGX:         $0 (existing infrastructure)
Ollama inference:   $0 (local GPU)
Storage:            $0 (git repository)
CI/CD:              $0 (GitHub Actions free tier)
```

### Total Monthly Cost: **$0**

---

## Timeline Summary

```
Phase 0:  Days 1-5    (Bootstrap)
Phase 1:  Days 6-25   (4 parallel workstreams)
Phase 2:  Days 14-25  (Orchestration, overlaps with Phase 1)
Phase 3:  Days 26-40  (Integration)
Phase 4:  Days 41-60  (Production)
Phase 5:  Days 61-70  (Optional enhancements)

Total: 60-70 days
```

With proper parallelization: **~60 days** (vs 90-110 days sequential)

---

## Success Criteria

### Phase 0 Complete
- [x] Cargo workspace created
- [x] Justfile with basic commands
- [x] k3d cluster running locally
- [x] Docker images built

### Phase 1 Complete
- [ ] All 4 services compile and run
- [ ] Unit tests passing (90%+ coverage)
- [ ] Services respond to ZeroMQ commands
- [ ] Basic functionality verified

### Phase 2 Complete
- [ ] Orchestrator coordinates all services
- [ ] Events flow correctly
- [ ] Phase gates enforce order
- [ ] Health monitoring working

### Phase 3 Complete
- [ ] End-to-end pipeline successful
- [ ] Integration tests passing
- [ ] k8s deployment working
- [ ] Configuration management solid

### Phase 4 Complete
- [ ] Deployed to production k3s
- [ ] Monitoring and alerting operational
- [ ] Documentation complete
- [ ] Daily digests generating automatically

---

## Next Steps

1. **Review this proposal** and provide feedback
2. **Create GitHub issues** for each workstream (see PARALLEL_ISSUES.md)
3. **Bootstrap Phase 0** (Cargo workspace, Justfile, k3d)
4. **Launch Phase 1 workstreams** (4 parallel teams)
5. **Iterate and refine** based on learnings

---

## References

- **dgx-pixels patterns:** `DGX_PIXELS_ORCHESTRATION_PATTERNS.md`
- **OSS architecture:** `docs/zero-cost-architecture.md`
- **Infrastructure:** `docs/OSS_DEPLOYMENT_STRATEGY.md`
- **Model research:** `research/git-commit-summarization-oss-models.md`

---

**Status:** Proposal ready for review and implementation
**Last Updated:** 2025-11-12
