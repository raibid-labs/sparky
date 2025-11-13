# DGX-Pixels Pattern References - Quick Index

Complete reference to all key files and patterns in dgx-pixels that should be replicated for Sparky.

## Quick Navigation

- **Comprehensive Analysis**: See `DGX_PIXELS_ORCHESTRATION_PATTERNS.md`
- **Key Files to Study**: Use the reference matrix below
- **Implementation Order**: Foundation → Patterns → Orchestration → Execution

---

## KEY FILES BY CATEGORY

### 1. ORCHESTRATION & PROJECT STRUCTURE

| File | Location | Purpose | Study Time |
|------|----------|---------|-----------|
| meta-orchestrator.md | `/dgx-pixels/docs/orchestration/meta-orchestrator.md` | Multi-tier orchestration design | 30min |
| workstream-plan.md | `/dgx-pixels/docs/orchestration/workstream-plan.md` | 18 workstreams + dependencies | 20min |
| foundation.md | `/dgx-pixels/docs/orchestration/orchestrators/foundation.md` | Foundation orchestrator spec | 15min |
| CLAUDE.md | `/dgx-pixels/CLAUDE.md` | Project guidance (applies to Sparky too) | 30min |

### 2. AUTOMATION & SCRIPTING

| File | Location | Purpose | Study Time |
|------|----------|---------|-----------|
| justfile | `/dgx-pixels/justfile` | Task automation + Docker + Git | 40min |
| config.nu | `/dgx-pixels/scripts/nu/config.nu` | Core Nushell utilities | 20min |
| github.nu | `/dgx-pixels/scripts/nu/modules/github.nu` | GitHub automation | 25min |
| dgx.nu | `/dgx-pixels/scripts/nu/modules/dgx.nu` | Hardware utilities | 15min |
| setup_docker.sh | `/dgx-pixels/scripts/setup_docker.sh` | Docker environment setup | 15min |

### 3. RUST IMPLEMENTATION

| File | Location | Purpose | Study Time |
|------|----------|---------|-----------|
| Cargo.toml | `/dgx-pixels/rust/Cargo.toml` | Dependencies + profile settings | 10min |
| main.rs | `/dgx-pixels/rust/src/main.rs` | TUI entry point + event loop | 15min |
| app.rs | `/dgx-pixels/rust/src/app.rs` | Application state architecture | 20min |
| zmq_client.rs | `/dgx-pixels/rust/src/zmq_client.rs` | ZeroMQ communication patterns | 25min |
| messages.rs | `/dgx-pixels/rust/src/messages.rs` | Protocol message definitions | 15min |

### 4. DOCKER & DEPLOYMENT

| File | Location | Purpose | Study Time |
|------|----------|---------|-----------|
| docker-compose.yml | `/dgx-pixels/docker/docker-compose.yml` | Full service stack | 30min |
| Dockerfile | `/dgx-pixels/docker/Dockerfile` | Development container | 15min |
| Dockerfile.backend | `/dgx-pixels/docker/Dockerfile.backend` | Python backend | 10min |
| Dockerfile.comfyui | `/dgx-pixels/docker/Dockerfile.comfyui` | ComfyUI service | 10min |
| DOCKER-QUICKREF.md | `/dgx-pixels/DOCKER-QUICKREF.md` | Docker commands reference | 10min |

### 5. DOCUMENTATION

| File | Location | Purpose | Study Time |
|------|----------|---------|-----------|
| README.md | `/dgx-pixels/README.md` | Project overview | 20min |
| CONTRIBUTING.md | `/dgx-pixels/CONTRIBUTING.md` | Development workflow | 25min |
| README.md | `/dgx-pixels/deploy/` | Observability setup | 10min |

---

## PATTERNS TO REPLICATE

### Pattern 1: Multi-Tier Orchestration
**Files**: `meta-orchestrator.md`, `workstream-plan.md`, `orchestrators/*.md`
**Key Concept**: Meta Orchestrator → 4 Domain Orchestrators → 18 Workstreams
**Timeline**: Create structure in Week 1-2

### Pattern 2: Justfile Task Automation
**File**: `justfile`
**Key Concept**: All development tasks as one-liner recipes
**Timeline**: Set up by Week 1

### Pattern 3: Nushell Modules
**Files**: `scripts/nu/config.nu`, `scripts/nu/modules/*.nu`
**Key Concept**: Reusable shell functions organized by domain
**Timeline**: Build incrementally

### Pattern 4: Rust + Python Hybrid
**Files**: `rust/` + `python/workers/`
**Key Concept**: Rust TUI ↔ Python Backend via ZeroMQ
**Timeline**: Parallel development in Weeks 3-6

### Pattern 5: Docker Compose Microservices
**Files**: `docker/docker-compose.yml` + `docker/Dockerfile.*`
**Key Concept**: Multiple services with dependencies + observability stack
**Timeline**: Week 1-2 setup, extended in Week 5+

### Pattern 6: ZeroMQ + MessagePack IPC
**Files**: `rust/src/zmq_client.rs`, `rust/src/messages.rs`
**Key Concept**: REQ-REP + PUB-SUB for <1ms latency
**Timeline**: WS-09 (Weeks 3-4)

### Pattern 7: GitHub Automation
**File**: `scripts/nu/modules/github.nu`
**Key Concept**: Branch creation, PR management, auto-merge
**Timeline**: Week 1 setup

### Pattern 8: Phase Gates
**Files**: `meta-orchestrator.md` § Phase Gates
**Key Concept**: Acceptance criteria block dependent phases
**Timeline**: Define in Week 1

---

## ABSOLUTE MUST-READ FILES (START HERE)

**Order of Reading:**

1. **CLAUDE.md** (dgx-pixels)
   - Understand project context and constraints
   - 30 minutes → Foundation for everything else

2. **meta-orchestrator.md**
   - Learn hierarchical orchestration model
   - Understand phase gates and dependencies
   - 30 minutes → Core architecture pattern

3. **justfile**
   - See concrete task automation
   - Learn recipe patterns and polyglot approach
   - 40 minutes → Practical example

4. **workstream-plan.md**
   - Understand all 18 workstreams
   - See dependency matrix
   - 20 minutes → Scope definition

5. **docker-compose.yml**
   - See full service stack
   - Understand microservices pattern
   - 30 minutes → Deployment architecture

**Total: ~2.5 hours → Complete overview**

---

## IMPLEMENTATION CHECKLIST FOR SPARKY

### Week 1: Foundation
- [ ] Copy orchestration documentation structure
- [ ] Adapt meta-orchestrator.md to Sparky context
- [ ] Create 4 domain orchestrator specs
- [ ] Create justfile with core recipes
- [ ] Set up Nushell modules (config.nu, github.nu)
- [ ] Create docker-compose.yml skeleton
- [ ] Define Phase Gate acceptance criteria

### Week 2-3: Workstreams
- [ ] Create workstream template
- [ ] Write all workstream README.md files
- [ ] Document dependencies in workstream-plan.md
- [ ] Create example workstream specs
- [ ] Set up GitHub issue templates

### Week 4+: Implementation
- [ ] Spawn Foundation Orchestrator
- [ ] Monitor WS-01, WS-02, WS-03
- [ ] Gate Phase 1 → Phase 2
- [ ] Spawn Model + Interface Orchestrators
- [ ] Execute parallel workstreams
- [ ] Monitor metrics and observability

---

## QUICK COPY COMMANDS

### Copy Entire Orchestration Structure
```bash
cp -r /dgx-pixels/docs/orchestration /sparky/docs/
cp /dgx-pixels/docs/orchestration/meta-orchestrator.md /sparky/
```

### Copy Justfile
```bash
cp /dgx-pixels/justfile /sparky/
# Then customize for Sparky-specific commands
```

### Copy Script Modules
```bash
cp -r /dgx-pixels/scripts/nu /sparky/scripts/
```

### Copy Docker Compose
```bash
cp /dgx-pixels/docker/docker-compose.yml /sparky/docker/
cp /dgx-pixels/docker/Dockerfile* /sparky/docker/
```

---

## ADAPTATION NOTES FOR SPARKY

DGX-Pixels patterns apply directly to Sparky with these adaptations:

### Same Pattern
- Multi-tier orchestration
- Workstream structure
- Phase gates
- Justfile automation
- Nushell modules
- GitHub workflow
- Docker Compose

### Different Details
- **Replace**: ComfyUI → Sparky's ML components
- **Replace**: Bevy integration → Sparky's target integration
- **Replace**: SDXL/LoRA → Sparky's ML models
- **Replace**: Sixel preview → Sparky's UI components
- **Replace**: ZeroMQ → May use same or different IPC

### Same Principles
- Test-Driven Development
- Phase gates prevent rework
- Parallel workstreams maximize velocity
- Observability from day 1
- Documentation as code

---

## DEPENDENCY GRAPH

```
meta-orchestrator.md (foundation)
├── workstream-plan.md (planning)
│   └── orchestrators/*.md (specs)
│       └── workstreams/ws*/README.md (tasks)
│
├── justfile (execution)
│   ├── scripts/nu/config.nu (utilities)
│   └── scripts/nu/modules/*.nu (automation)
│
├── docker/docker-compose.yml (deployment)
│   └── docker/Dockerfile* (containers)
│
└── CONTRIBUTING.md (workflow)
    └── github.nu (automation)
```

---

## STUDYING PATTERNS: LEARNING PATH

**Path 1: Executive Overview (2.5 hours)**
→ CLAUDE.md → meta-orchestrator.md → justfile → workstream-plan.md → docker-compose.yml

**Path 2: Deep Implementation (1 day)**
→ All of Path 1 + 
→ github.nu → config.nu → Cargo.toml → zmq_client.rs → messages.rs

**Path 3: Complete Mastery (2-3 days)**
→ All of Path 2 +
→ All Nushell modules → All Dockerfiles → CONTRIBUTING.md → Example workstreams

---

## QUICK REFERENCE: FILE LOCATIONS

```
/home/beengud/raibid-labs/dgx-pixels/

Orchestration:
  docs/orchestration/meta-orchestrator.md
  docs/orchestration/workstream-plan.md
  docs/orchestration/orchestrators/
  docs/orchestration/workstreams/

Automation:
  justfile
  scripts/nu/config.nu
  scripts/nu/modules/github.nu
  scripts/nu/modules/dgx.nu
  scripts/setup_docker.sh

Rust:
  rust/Cargo.toml
  rust/src/main.rs
  rust/src/app.rs
  rust/src/zmq_client.rs
  rust/src/messages.rs

Docker:
  docker/docker-compose.yml
  docker/Dockerfile
  docker/Dockerfile.backend
  docker/Dockerfile.comfyui
  DOCKER-QUICKREF.md

Documentation:
  README.md
  CONTRIBUTING.md
  CLAUDE.md
```

---

## NEXT STEPS

1. **Read this week**: CLAUDE.md + meta-orchestrator.md
2. **Study this week**: justfile + docker-compose.yml
3. **Plan next week**: Adapt orchestration to Sparky context
4. **Implement Week 2**: Create Sparky-specific orchestration structure
5. **Execute Week 3+**: Spawn agents and manage workstreams

---

**Version**: 1.0
**Created**: 2025-11-13
**Based on**: /home/beengud/raibid-labs/dgx-pixels/ (12 weeks, 18 workstreams, 4 domain orchestrators)
**For**: Sparky project replication

