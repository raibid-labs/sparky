# DGX-Pixels Orchestration and Parallelization Patterns - Comprehensive Analysis

## Executive Summary

DGX-Pixels demonstrates a mature, enterprise-scale orchestration pattern combining:
- **Multi-tier orchestration** (Meta Orchestrator → Domain Orchestrators → Workstreams)
- **Rust + Nushell + Justfile** automation stack
- **Parallel workstream coordination** with dependency management
- **Docker Compose microservices** with GPU integration
- **ZeroMQ IPC** for inter-process communication
- **Agent-based development workflow** with GitHub integration

This document provides the complete blueprint for replicating these patterns in Sparky.

---

## 1. ORCHESTRATOR ARCHITECTURE

### 1.1 Multi-Tier Orchestration Model

DGX-Pixels uses a hierarchical orchestration pattern:

```
┌─────────────────────────────────────────┐
│      Meta Orchestrator (M0-M5)          │
│  ─ Spawns domain orchestrators          │
│  ─ Manages dependencies                 │
│  ─ Handles phase gates                  │
└──────┬──────────────────────────────────┘
       │
   ┌───┴───┬──────────┬─────────────────┐
   │       │          │                 │
   ▼       ▼          ▼                 ▼
┌──────┐┌──────┐┌──────────┐┌──────────┐
│Found-│Model  │Interface  │Integration
│ation │Orch   │Orch       │Orch
│Orch  │       │           │
└──┬───┘└──┬───┘└────┬─────┘└────┬─────┘
   │      │         │            │
┌──┴─┬────┴┬────────┴─┬──────────┴────┐
│WS-1│WS-2│WS-3    WS-4 WS-5...  WS-18│
└────┴────┴─────────────────────────────┘
```

**Key Characteristics:**

1. **Foundation Orchestrator (M0)**
   - Owns: WS-01, WS-02, WS-03
   - Duration: Weeks 1-2
   - Purpose: Hardware baselines, reproducibility, benchmarking
   - Blocks: ALL other phases
   - Pattern: Sequential execution (gates dependencies)

2. **Model Orchestrator (M1, M3)**
   - Owns: WS-04, WS-05, WS-06, WS-07
   - Duration: Weeks 3-5
   - Purpose: ComfyUI, SDXL optimization, LoRA training
   - Blocks: Interface Orchestrator (needs ComfyUI working)
   - Pattern: Parallel where possible

3. **Interface Orchestrator (M2)**
   - Owns: WS-08, WS-09, WS-10, WS-11, WS-12
   - Duration: Weeks 3-6
   - Purpose: Rust TUI, ZeroMQ backend, Sixel preview
   - Blocks: Integration Orchestrator (needs TUI + backend)
   - Pattern: Mixed sequential/parallel

4. **Integration Orchestrator (M4, M5)**
   - Owns: WS-13, WS-14, WS-15, WS-16, WS-17, WS-18
   - Duration: Weeks 7-12
   - Purpose: Bevy MCP, observability, deployment
   - Blocks: Nothing (final phase)
   - Pattern: Sequential then parallel

### 1.2 Orchestration Spawning Protocol

**Location**: `docs/orchestration/meta-orchestrator.md`

**Phase Gates Control Progress:**
```
Gate 1: Foundation → Model/Interface (End of Week 2)
✓ Hardware verification complete
✓ Baseline measurements recorded
✓ Reproducibility framework working
✓ Benchmark suite running

Gate 2: Model/Interface → Integration (End of Week 6)
✓ ComfyUI generating images (M1)
✓ Rust TUI functional with preview (M2)
✓ Python backend operational (M2)
✓ LoRA training pipeline working (M3)

Gate 3: Integration → Production (End of Week 11)
✓ Bevy MCP integration complete (M4)
✓ Asset deployment pipeline working (M4)
✓ Example game using generated sprites (M4)
```

**Spawning Commands Pattern:**
```bash
# Phase 1: Foundation Only (Week 1)
claude-flow spawn orchestrator foundation \
  --workstreams WS-01,WS-02,WS-03 \
  --phase sequential

# Phase 2: Models + Interface (Week 3, after Gate 1)
claude-flow spawn orchestrator models \
  --workstreams WS-04,WS-05,WS-06,WS-07 \
  --phase parallel \
  --depends-on foundation

claude-flow spawn orchestrator interface \
  --workstreams WS-08,WS-09,WS-10,WS-11,WS-12 \
  --phase parallel \
  --depends-on WS-04

# Phase 3: Integration (Week 7, after Gate 2)
claude-flow spawn orchestrator integration \
  --workstreams WS-13,WS-14,WS-15,WS-16,WS-17,WS-18 \
  --phase sequential-then-parallel \
  --depends-on interface,models
```

---

## 2. PARALLEL WORKSTREAM COORDINATION

### 2.1 Workstream Structure

Each workstream follows a standardized format:

**Location**: `docs/orchestration/workstreams/`

**Structure:**
```
ws01-hardware-baselines/
├── README.md                    # Workstream specification
├── COMPLETION_SUMMARY.md        # Agent completion report
└── (sub-directories for domain-specific docs)
```

**README.md Contains:**
- Objective and deliverables
- Acceptance criteria (must-haves)
- Technical requirements
- Dependencies (blocks/unblocks)
- Estimated LOC
- Related issues/references

**Example: WS-01**
```markdown
# WS-01: Hardware Baselines

Owner: Foundation Orchestrator
Agent Type: devops-automator
Duration: 3-4 days
Priority: P0 (critical path)

Objective: Document verified DGX-Spark GB10 hardware specs

Deliverables:
1. repro/hardware_verification.sh - Automated detection
2. bench/baselines/hardware_baseline.json - Recorded metrics
3. Updated docs/hardware.md with measurements
4. Topology diagrams

Acceptance Criteria:
✓ Script captures: GPU model, VRAM, CUDA, driver, CPU, RAM
✓ Baseline JSON recorded in bench/baselines/
✓ Docs match actual hardware (GB10, 128GB unified, ARM)
✓ Verification script exits 0 on success

Dependencies: None (blocks all other phases)
```

### 2.2 Workstream Plan Matrix

**Total Workstreams**: 18 across 12 weeks

| ID | Name | Orch | Milestone | Duration | Dependencies |
|----|------|------|-----------|----------|--------------|
| WS-01 | Hardware Baselines | Foundation | M0 | 3-4d | None |
| WS-02 | Reproducibility | Foundation | M0 | 4-5d | WS-01 |
| WS-03 | Benchmark Suite | Foundation | M0 | 3-4d | WS-01 |
| WS-04 | ComfyUI Setup | Model | M1 | 4-5d | WS-01 |
| WS-05 | SDXL Optimization | Model | M1 | 5-7d | WS-04 |
| WS-06 | LoRA Training | Model | M3 | 7-10d | WS-05 |
| WS-07 | Dataset Tools | Model | M3 | 5-6d | WS-05 |
| WS-08 | Rust TUI Core | Interface | M2 | 6-8d | WS-01 |
| WS-09 | ZeroMQ IPC | Interface | M2 | 4-5d | WS-08 |
| WS-10 | Python Backend | Interface | M2 | 5-6d | WS-04, WS-09 |
| WS-11 | Sixel Preview | Interface | M2 | 3-4d | WS-08, WS-10 |
| WS-12 | Model Comparison | Interface | M2 | 4-5d | WS-10, WS-11 |
| WS-13 | FastMCP Server | Integration | M4 | 5-6d | WS-10 |
| WS-14 | Bevy Plugin | Integration | M4 | 6-7d | WS-13 |
| WS-15 | Asset Deployment | Integration | M4 | 4-5d | WS-13, WS-14 |
| WS-16 | DCGM Metrics | Integration | M5 | 5-6d | WS-05 |
| WS-17 | Docker Deployment | Integration | M5 | 4-5d | WS-10, WS-16 |
| WS-18 | CI/CD Pipeline | Integration | M5 | 6-8d | WS-17 |

**Timeline**: 90-110 days sequential → 60-70 days with proper parallelization

### 2.3 Dependency Management

**Critical Dependencies:**
```
M0 (Foundation) BLOCKS ALL
    └─→ [Gate 1] ─→ M1 (Models) ─→╮
                  └─→ M2 (Interface) ┤
                              └─→ [Gate 2] ─→ M4/M5 (Integration)
                                          └─→ M3 (Training)
```

**Blocking Rules:**
- Foundation Orchestrator must complete before Model/Interface start
- ComfyUI (WS-04) must complete before TUI integration (WS-10, WS-12)
- Python backend (WS-10) must complete before Bevy integration (WS-13, WS-14)
- All predecessors must complete before dependent workstreams

---

## 3. IMPLEMENTATION PATTERNS

### 3.1 Justfile Command Organization

**Location**: `/home/beengud/raibid-labs/dgx-pixels/justfile`

**Structure Pattern:**

```justfile
# === Project Initialization ===
init:
    #!/usr/bin/env bash
    # Create directory structure
    mkdir -p rust/src/{ui,zmq_client}
    mkdir -p python/workers
    mkdir -p workflows
    mkdir -p models/{checkpoints,loras,configs}
    # Initialize virtual environments, etc.

# === Build Commands ===
build:
    cargo build --workspace

# === Development Commands ===
tui:
    cargo run --package dgx-pixels-tui

backend PORT="5555":
    source venv/bin/activate
    python python/workers/generation_worker.py --port {{PORT}}

# === Testing ===
test:
    cargo test --workspace
    pytest python/tests/ -v

# === Code Quality ===
fmt:
    cargo fmt --all

lint:
    cargo clippy --workspace -- -D warnings

ci: fmt lint test
    @echo "✅ All CI checks passed!"

# === Orchestration Commands ===
orch-foundation:
    @echo "🚀 Starting Foundation Orchestrator..."

# === Docker Commands ===
docker-setup:
    ./scripts/setup_docker.sh

docker-up:
    cd docker && docker compose up -d

# === Git Commands ===
branch WS_ID:
    #!/usr/bin/env nu
    use scripts/nu/modules/github.nu *
    gh-create-branch "{{WS_ID}}"

pr TITLE:
    #!/usr/bin/env nu
    use scripts/nu/modules/github.nu *
    gh-create-pr "{{TITLE}}"
```

**Key Patterns:**
1. Recipes organized by functional area
2. Bash/Nushell shebang for polyglot support
3. Parameters using `{{var}}` syntax
4. Recipes can chain with `recipe1 recipe2 recipe3`
5. `@` suppresses echo, `!` is important

### 3.2 Nushell Automation Scripts

**Location**: `scripts/nu/`

**Module Pattern:**

```nushell
#!/usr/bin/env nu
# File: scripts/nu/modules/github.nu

use ../config.nu [COLORS, log-success, log-error, log-warning, log-info]

# Export reusable functions
export def gh-create-branch [
    branch_name: string,
    base_branch: string = "main"
] {
    # Function body with error handling, logging
    try {
        log-info $"Creating branch: ($branch_name)"
        git checkout -b $branch_name
        log-success $"Created: ($branch_name)"
        return true
    } catch {|err|
        log-error $"Failed: ($err.msg)"
        return false
    }
}

export def gh-create-pr [
    title: string,
    --body: string,
    --base: string = "main",
    --draft,
    --labels: list<string> = []
] {
    # Full implementation with validation
}
```

**Three-Layer Module Structure:**

1. **config.nu** - Core utilities
   - Color constants and logging functions
   - Project paths (project-root, docs-dir, models-dir)
   - File system utilities
   - Git utilities (current-branch, is-git-clean)
   - Hardware detection (has-nvidia-gpu, gpu-model)
   - Environment checks

2. **modules/github.nu** - GitHub automation
   - gh-create-branch
   - gh-create-pr
   - gh-auto-merge
   - gh-rebase-main
   - gh-check-status
   - gh-list-prs
   - gh-request-review

3. **modules/dgx.nu** - Hardware utilities
   - dgx-gpu-stats
   - dgx-validate-hardware
   - dgx-benchmark-memory
   - dgx-export-topology

**Usage Pattern:**
```nushell
# In justfile
validate-gpu:
    #!/usr/bin/env nu
    use scripts/nu/config.nu *
    check-dgx-prerequisites

# Or directly
use scripts/nu/modules/github.nu *
let result = (gh-create-branch "feature/new-ui")
if $result {
    print "Branch created successfully"
}
```

### 3.3 Rust Project Structure

**Location**: `rust/` with monorepo Cargo workspace

```
rust/
├── Cargo.toml              # Workspace definition
├── Cargo.lock
├── src/
│   ├── main.rs            # TUI entry point
│   ├── app.rs             # Application state (Screen enum, JobStatus, App struct)
│   ├── zmq_client.rs      # ZeroMQ communication
│   ├── messages.rs        # Protocol messages (Request, Response, ProgressUpdate)
│   ├── comparison.rs      # Side-by-side model comparison logic
│   ├── reports.rs         # Report generation
│   ├── events/
│   │   ├── mod.rs
│   │   └── handler.rs     # Event handling (keyboard, resize)
│   ├── ui/
│   │   ├── mod.rs         # Main render function
│   │   ├── layout.rs      # Grid layout for screens
│   │   ├── theme.rs       # Colors and styles
│   │   └── screens/
│   │       ├── mod.rs
│   │       ├── generation.rs
│   │       ├── comparison.rs    # NEW: Side-by-side UI
│   │       ├── gallery.rs
│   │       ├── models.rs
│   │       ├── queue.rs
│   │       ├── monitor.rs
│   │       ├── settings.rs
│   │       └── help.rs
│   └── sixel/
│       ├── mod.rs
│       ├── image_renderer.rs    # Sixel encoding
│       ├── preview_manager.rs   # Async image preview loading
│       └── terminal_detection.rs # Detect Sixel support
├── tests/
│   └── integration_test.rs
└── benches/
    └── (benchmarks)
```

**Cargo.toml Pattern:**
```toml
[package]
name = "dgx-pixels-tui"
version = "0.1.0"
edition = "2021"
rust-version = "1.70"

[[bin]]
name = "dgx-pixels-tui"
path = "src/main.rs"

[dependencies]
# TUI framework
ratatui = "0.26"
crossterm = "0.27"

# Async runtime
tokio = { version = "1.35", features = ["full"] }

# Serialization
serde = { version = "1.0", features = ["derive"] }

# Error handling
anyhow = "1.0"
thiserror = "1.0"

# Logging
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter"] }

# IPC
zmq = "0.10.0"
rmp-serde = "1.3.0"

# Image processing
image = "0.24"
viuer = "0.7"

# Performance
dashmap = "5.5"
parking_lot = "0.12"

[profile.release]
opt-level = 3
lto = true
codegen-units = 1
strip = true
```

### 3.4 Python Project Structure

```
python/
├── requirements.txt
├── requirements-base.txt
├── requirements-extra.txt
├── requirements-comfyui.txt
├── workers/
│   ├── __init__.py
│   ├── generation_worker.py     # Main worker
│   └── zmq_server.py            # ZeroMQ server
├── mcp_server/
│   ├── __init__.py
│   └── server.py                # FastMCP server
├── training/
│   ├── lora_trainer.py
│   └── dataset_tools.py
├── tests/
│   ├── test_worker.py
│   └── test_mcp.py
└── pyproject.toml
```

**Key Implementation Patterns:**

1. **ZeroMQ Server (REQ-REP + PUB-SUB)**
   - REQ-REP (Request-Reply): Job submission, status queries
   - PUB-SUB (Publish-Subscribe): Progress updates, notifications

2. **Worker Loop**
   - Listen on REQ-REP socket for job requests
   - Publish progress on SUB socket
   - Communicate with ComfyUI via HTTP
   - Return results and status

3. **MCP Server**
   - FastMCP for MCP protocol
   - Tools for Bevy integration
   - Handles asset deployment

---

## 4. DOCKER & CONTAINERIZATION STRATEGY

### 4.1 Docker Compose Architecture

**Location**: `docker/docker-compose.yml`

**Service Stack:**

```yaml
services:
  comfyui:
    # AI inference engine
    build: docker/Dockerfile.comfyui
    depends_on: none
    ports: 8188
    volumes: models, outputs, workflows

  backend-worker:
    # Python ZeroMQ server + ComfyUI client
    build: docker/Dockerfile.backend
    depends_on: comfyui (service_healthy)
    ports: 5555 (REQ-REP), 5556 (PUB-SUB)
    volumes: workflows, outputs

  mcp-server:
    # FastMCP for Bevy integration
    build: docker/Dockerfile.mcp
    depends_on: backend-worker (service_healthy)
    ports: 3001

  dcgm-exporter:
    # GPU metrics (NVIDIA DCGM)
    image: nvidia/dcgm-exporter:3.1.7
    ports: 9400

  prometheus:
    # Time-series metrics database
    image: prom/prometheus:v2.48.0
    ports: 9090
    depends_on: dcgm-exporter, backend-worker

  grafana:
    # Metrics visualization
    image: grafana/grafana:10.2.2
    ports: 3000
    depends_on: prometheus

  node-exporter:
    # Host system metrics
    image: prom/node-exporter:v1.7.0
    ports: 9100

  dgx-pixels-dev:
    # Development container (optional, profile:dev)
    build: docker/Dockerfile
    depends_on: none
    profiles: [dev]
```

**Network Configuration:**
```yaml
networks:
  dgx-pixels-net:
    driver: bridge
    subnet: 172.28.0.0/16
```

**Volume Configuration:**
```yaml
volumes:
  # Persistent storage for models (shared across services)
  comfyui-models:
  
  # Persistent storage for outputs
  comfyui-outputs:
  backend-outputs:
  
  # Development bind mounts
  dgx-pixels-models: (bind to host ./models)
  dgx-pixels-outputs: (bind to host ./outputs)
  
  # Observability
  prometheus-data:
  grafana-data:
```

### 4.2 Dockerfile Patterns

**Base Image Strategy:**
```dockerfile
# Main development container (ARM64 compatible)
FROM nvcr.io/nvidia/pytorch:24.11-py3

# Why NGC base:
# - PyTorch wheels for ARM+CUDA unavailable on PyPI
# - Pre-built with CUDA support
# - NVIDIA optimized
# - Includes Python 3.12 + PyTorch 2.6
```

**Layer Optimization:**
```dockerfile
# 1. System packages (slow - do first)
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim curl git ...

# 2. Python dependencies (medium - do middle)
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# 3. Application code (fast - do last)
COPY src/ /app/src/
```

**Health Checks:**
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=60s \
    CMD curl -f http://localhost:8188/system_stats
```

### 4.3 Docker Setup Script

**Location**: `scripts/setup_docker.sh`

**Checks Performed:**
1. Docker v20.10+
2. Docker Compose v2+
3. NVIDIA Container Toolkit
4. NVIDIA drivers
5. DGX-Spark GB10 hardware

**Creates:**
- `docker/.env` configuration
- Directory structure
- Initial Docker images
- Networks

---

## 5. ZEROMQ IPC PATTERNS

### 5.1 Communication Architecture

**Pattern: REQ-REP + PUB-SUB Hybrid**

```
Rust TUI                        Python Backend
  │                                  │
  ├──→ REQ (Request) ──────→┐        │
  │                         │        │
  │                    ┌────▼────┐   │
  │                    │ REQ-REP  │   │
  │                    │ Socket   │   │
  │                    │ Port 5555│   │
  │                    └────┬────┘   │
  │                         │        │
  │    ┌──────────PUB/SUB───┤        │
  │    │ Updates (Progress) │        │
  │    │ Port 5556          │        │
  │    │                    │        │
  └────┴──────────Sub────────────────┘
       │
       └─ Receives progress updates
```

### 5.2 Message Patterns

**Rust Implementation (zmq_client.rs):**
```rust
pub struct ZmqClient {
    req_sender: Sender<ClientRequest>,
    resp_receiver: Receiver<Response>,
    update_receiver: Receiver<ProgressUpdate>,
    _req_thread: thread::JoinHandle<()>,
    _sub_thread: thread::JoinHandle<()>,
}

impl ZmqClient {
    pub fn new(req_addr: &str, pub_addr: &str) -> Result<Self> {
        // Spawn two threads:
        // 1. REQ-REP thread for request/response
        // 2. PUB-SUB thread for updates
    }
}
```

**Message Protocol (messages.rs):**
```rust
pub enum Request {
    Generate { prompt: String, model: String },
    GetStatus { job_id: String },
    Cancel { job_id: String },
}

pub enum Response {
    JobQueued { job_id: String },
    Status { job_id: String, status: JobStatus },
    Result { image_path: PathBuf, metadata: ... },
    Error { message: String },
}

pub struct ProgressUpdate {
    job_id: String,
    stage: String,
    progress: f32,
    eta_s: f32,
}
```

**Serialization: MessagePack (rmp-serde)**
- Binary format (smaller than JSON)
- Fast serialization/deserialization
- Type-safe in both Rust and Python

---

## 6. PROJECT STRUCTURE TEMPLATE

### 6.1 Directory Organization

```
sparky/
├── README.md
├── CONTRIBUTING.md
├── CLAUDE.md                    # Claude Code guidance
├── justfile                     # Task automation
│
├── docs/
│   ├── orchestration/           # Orchestration patterns
│   │   ├── meta-orchestrator.md
│   │   ├── workstream-plan.md
│   │   ├── orchestrators/
│   │   │   ├── foundation.md
│   │   │   ├── model.md
│   │   │   ├── interface.md
│   │   │   └── integration.md
│   │   └── workstreams/
│   │       ├── start-here.md
│   │       ├── template.md
│   │       ├── ws01-xxx/README.md
│   │       └── ...
│   ├── adr/                    # Architecture Decision Records
│   │   └── 0001-decision.md
│   └── (domain-specific docs)
│
├── rust/
│   ├── Cargo.toml              # Workspace
│   ├── src/
│   │   ├── main.rs
│   │   ├── app.rs
│   │   ├── events/
│   │   ├── ui/
│   │   └── (domain modules)
│   ├── tests/
│   └── benches/
│
├── python/
│   ├── requirements.txt
│   ├── workers/
│   ├── mcp_server/
│   ├── training/
│   └── tests/
│
├── docker/
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── Dockerfile.backend
│   ├── Dockerfile.mcp
│   ├── requirements-base.txt
│   └── requirements-comfyui.txt
│
├── scripts/
│   ├── setup_docker.sh
│   ├── docker_health_check.sh
│   ├── docker_cleanup.sh
│   └── nu/
│       ├── config.nu
│       └── modules/
│           ├── github.nu
│           ├── dgx.nu
│           └── (domain modules)
│
├── config/
│   ├── mcp_config.yaml
│   └── (service configs)
│
├── deploy/
│   ├── prometheus/
│   ├── grafana/
│   └── dcgm/
│
├── models/
│   ├── checkpoints/
│   ├── loras/
│   └── configs/
│
├── workflows/
│   └── (workflow templates)
│
└── examples/
    └── (example implementations)
```

### 6.2 Configuration Files

**docker/.env**
```bash
# Ports
COMFYUI_PORT=8188
ZMQ_PORT=5555
GRAFANA_PORT=3000

# Paths
PROJECT_ROOT=/path/to/sparky
MODELS_DIR=./models
OUTPUTS_DIR=./outputs

# Credentials
GRAFANA_ADMIN_PASSWORD=admin
```

**dgx-pixels.toml (project config)**
```toml
[api]
port = 8000
zmq_req_port = 5555
zmq_pub_port = 5556

[comfyui]
url = "http://localhost:8188"

[models]
dir = "models"

[observability]
prometheus_url = "http://localhost:9090"
grafana_url = "http://localhost:3000"
```

---

## 7. CI/CD AND TESTING PATTERNS

### 7.1 Test-Driven Development (TDD)

**Pattern Used:**
1. Write tests FIRST
2. Implement code
3. Run tests
4. Code review with passing tests

**Test Locations:**
```
rust/tests/integration_test.rs
python/tests/test_*.py
```

**Test Command:**
```bash
just test                    # Run all tests
just test-coverage          # With coverage report
just test-integration       # Integration tests only
```

### 7.2 Pre-commit Checks

**Command Chain:**
```bash
just ci                     # Runs: fmt + lint + test
```

**Components:**
1. **fmt** - Code formatting
   ```bash
   cargo fmt --all          # Rust
   ruff format python/      # Python
   ```

2. **lint** - Code quality checks
   ```bash
   cargo clippy --workspace -- -D warnings
   ```

3. **test** - Unit + integration tests

### 7.3 GitHub Workflow

**Standard PR Workflow:**
```bash
# 1. Create branch for workstream
just branch WS-01

# 2. Implement with TDD
# (write tests, implement, run tests)

# 3. Run CI checks
just ci

# 4. Create PR
just pr "Implement WS-01: Title"

# 5. Enable auto-merge
gh-auto-merge --merge-method squash

# 6. Before next workstream, rebase
gh-rebase-main

# 7. Push with force-with-lease
git push --force-with-lease
```

---

## 8. MONITORING & OBSERVABILITY

### 8.1 Observability Stack

**Components:**
1. **DCGM Exporter** - GPU metrics (NVIDIA Data Center GPU Manager)
2. **Prometheus** - Time-series metrics collection
3. **Grafana** - Visualization dashboards
4. **Node Exporter** - Host system metrics

**Metrics Collected:**
- GPU utilization, memory, temperature
- Power draw, clock speeds
- Inference latency, throughput
- Queue depth, job completion rate
- Model accuracy metrics

**URLs:**
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin)
- DCGM metrics: http://localhost:9400/metrics

---

## 9. AGENT SPAWNING PATTERNS

### 9.1 Agent Types by Workstream

| Workstream Type | Agent Type | Rationale |
|-----------------|-----------|-----------|
| Infrastructure/DevOps | `devops-automator` | Docker, shell, CI/CD |
| Rust TUI | `rust-pro` | TUI frameworks, async |
| Python/AI | `ai-engineer` + `python-pro` | ML models, optimization |
| Integration | `backend-architect` | API design, protocols |

### 9.2 Workstream Spawn Command

**Standard Pattern:**
```bash
npx claude-flow@alpha spawn agent {agent-type} \
  --workstream {WS-XX} \
  --spec docs/orchestration/workstreams/{ws-name}/README.md \
  --priority {P0-P3} \
  --depends {WS-YY} \
  --output {completion-path}
```

**Example:**
```bash
npx claude-flow@alpha spawn agent devops-automator \
  --workstream WS-01 \
  --spec docs/orchestration/workstreams/ws01-hardware-baselines/README.md \
  --priority P0 \
  --output docs/orchestration/workstreams/ws01-hardware-baselines/COMPLETION_SUMMARY.md
```

### 9.3 Orchestrator Coordination

**Meta Orchestrator** monitors:
- Workstream completion status
- Cross-domain dependencies
- Blocker resolution
- Phase gate readiness

**Status Update Format (JSON):**
```json
{
  "orchestrator": "Model Orchestrator",
  "status": "active",
  "workstreams": {
    "WS-04": {"status": "complete", "completion_time": "2025-11-12T14:30:00Z"},
    "WS-05": {"status": "in_progress", "progress": 0.65, "eta": "2025-11-13T10:00:00Z"},
    "WS-06": {"status": "blocked", "blocker": "WS-05 incomplete"}
  },
  "blockers": [],
  "decisions_needed": []
}
```

---

## 10. KEY TAKEAWAYS FOR SPARKY

### 10.1 Core Patterns to Adopt

1. **Multi-tier Orchestration**
   - One Meta Orchestrator
   - Multiple Domain Orchestrators
   - Sequential → Parallel progression

2. **Workstream Structure**
   - Standardized README format
   - Clear acceptance criteria
   - Tracked completion summaries

3. **Automation Stack**
   - Justfile for command orchestration
   - Nushell modules for reusable automation
   - GitHub CLI for workflow automation

4. **Technology Stack**
   - Rust for performance-critical components
   - Python for ML/AI components
   - ZeroMQ for inter-process communication
   - Docker Compose for deployment

5. **Phase Gates**
   - Gating prevents out-of-order work
   - Clear acceptance criteria
   - Blocks dependent workstreams

### 10.2 Implementation Roadmap for Sparky

**Week 1-2: Foundation**
- Copy orchestration structure from dgx-pixels
- Adapt workstream templates
- Set up initial Docker Compose
- Establish Justfile and Nushell modules

**Week 3-4: Domain Orchestrators**
- Create domain orchestrator specs
- Populate workstream specs
- Establish automation scripts
- Set up GitHub workflows

**Week 5+: Parallel Execution**
- Spawn agents for first workstreams
- Monitor progress via status reports
- Manage phase gates
- Escalate blockers as needed

### 10.3 File Reference Summary

**Must-Read Patterns:**
- `/home/beengud/raibid-labs/dgx-pixels/justfile` - Task automation
- `/home/beengud/raibid-labs/dgx-pixels/docs/orchestration/meta-orchestrator.md` - Orchestration strategy
- `/home/beengud/raibid-labs/dgx-pixels/docker/docker-compose.yml` - Service architecture
- `/home/beengud/raibid-labs/dgx-pixels/scripts/nu/config.nu` - Nushell utilities
- `/home/beengud/raibid-labs/dgx-pixels/scripts/nu/modules/github.nu` - GitHub automation
- `/home/beengud/raibid-labs/dgx-pixels/CONTRIBUTING.md` - Development workflow

---

## 11. CRITICAL INSIGHTS

1. **Orchestration is Hierarchical**
   - Don't try to manage 18 workstreams flat
   - Group by domain (4 orchestrators)
   - Each orchestrator owns 3-6 workstreams

2. **Phase Gates Are Crucial**
   - Prevent out-of-order work
   - Save rework and integration pain
   - Make dependencies explicit

3. **Automation Saves Repetition**
   - Nushell modules provide reusable functions
   - Justfile provides task entry points
   - GitHub automation reduces manual work

4. **Docker is Non-Negotiable**
   - Reproducible environments
   - GPU access through NVIDIA Container Toolkit
   - Network of interdependent services

5. **ZeroMQ + MessagePack** is Optimal for IPC
   - Low latency (<1ms)
   - Binary format saves bandwidth
   - REQ-REP + PUB-SUB patterns are flexible

6. **Metrics-First Observability**
   - DCGM for GPU metrics
   - Prometheus for time-series
   - Grafana for visualization
   - Track from day 1, not at end

7. **Test-Driven Development**
   - Tests first, implementation second
   - Prevents integration surprises
   - CI gates enforce quality

8. **Documentation as Code**
   - Markdown in docs/ alongside code
   - Workstream specs are contracts
   - Architecture decisions in ADRs

---

## APPENDIX: Quick Command Reference

```bash
# Project initialization
just init                       # One-time setup
just validate-gpu              # Verify hardware

# Development
just tui                        # Run Rust TUI
just backend                    # Run Python backend
just comfyui                    # Run ComfyUI server

# Testing & Quality
just test                       # Run tests
just ci                         # Format, lint, test
just pre-commit                 # Pre-commit checks

# Docker
docker compose up -d            # Start all services
docker compose logs -f          # Follow logs
./scripts/docker_health_check.sh

# Git workflow
just branch WS-01               # Create workstream branch
just pr "Title"                 # Create PR
gh-auto-merge --merge-method squash
gh-rebase-main                  # Rebase onto main

# Monitoring
just gpu-status                 # One-time GPU stats
just gpu-watch                  # Live GPU monitoring
just hw-info                    # All hardware info
open http://localhost:3000      # Grafana
```

