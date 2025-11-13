# Sparky OSS Deployment - Complete Resource Map

## Overview

This document provides absolute paths and quick navigation to all infrastructure components, deployment patterns, and documentation needed to build Sparky with 100% open-source tools.

---

## Generated Documentation (Read These First)

### Quick Navigation
- **Start Here:** `/home/beengud/raibid-labs/sparky/docs/README_INFRASTRUCTURE.md`
  - 5-minute overview
  - File locations
  - Next steps

### Executive Summary
- **File:** `/home/beengud/raibid-labs/sparky/docs/EXECUTIVE_SUMMARY_OSS.md`
  - What's available
  - Key findings
  - Quick start commands
  - Cost analysis

### Technical Deep Dive
- **File:** `/home/beengud/raibid-labs/sparky/docs/OSS_DEPLOYMENT_STRATEGY.md` (22KB)
  - Complete infrastructure analysis
  - 3-tier architecture recommendations
  - Model performance benchmarks
  - Deployment patterns (ready to copy)
  - Integration guide
  - Risk assessment

---

## DGX Spark Playbooks Repository

**Location:** `/home/beengud/raibid-labs/dgx-spark-playbooks/`

### LLM Inference Services

#### 1. Ollama (Simplest - Start Here)
```
Path: /home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/ollama/
Files:
  - README.md          (Setup instructions)
  - docker-compose.yml (If available)

Key Info:
  - Performance: 30-50 tokens/sec
  - Complexity: Simple
  - GPU Memory: 8-16GB
  - Containers: 1
```

#### 2. vLLM (Production Scale)
```
Path: /home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/vllm/
Files:
  - README.md          (Setup and clustering)
  - Assets directory   (Deployment configs)

Key Info:
  - Performance: 100+ tokens/sec
  - Complexity: Medium
  - GPU Memory: Variable by model
  - Multi-GPU: Supported via Ray
```

#### 3. TensorRT-LLM (Maximum Optimization)
```
Path: /home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/trt-llm/
Files:
  - README.md                    (Complete setup guide)
  - assets/docker-compose.yml    (Docker Swarm config)
  - assets/trtllm-mn-entrypoint.sh (Multi-node script)

Key Info:
  - Performance: 2-10x faster
  - Complexity: Complex
  - Orchestration: Docker Swarm + MPI
  - Multi-node: Full support
```

### Full Stack Examples (Ready to Copy)

#### 1. Text-to-Knowledge Graph (RECOMMENDED TEMPLATE)
```
Path: /home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/txt2kg/
Key Files:
  - README.md (Full walkthrough)
  - assets/deploy/compose/docker-compose.yml (Main template)
  - assets/deploy/compose/docker-compose.complete.yml (Extended)
  - assets/deploy/services/ollama/Dockerfile
  - assets/deploy/services/sentence-transformers/Dockerfile

Services Included:
  - Ollama (LLM serving on :11434)
  - ArangoDB (Graph DB on :8529)
  - Sentence Transformers (Embeddings on :80)
  - Frontend (Next.js on :3001)
  - Pinecone (Vector DB on :5081)

Relevant for Sparky:
  ✓ Full docker-compose.yml pattern
  ✓ Health check configuration
  ✓ GPU resource allocation
  ✓ Volume management
  ✓ Multi-service coordination
  ✓ Environment variable examples
```

#### 2. Multi-Agent Chatbot (Multi-Service Pattern)
```
Path: /home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/multi-agent-chatbot/
Key Files:
  - assets/docker-compose.yml (Architecture pattern)
  - assets/docker-compose-models.yml (Model configuration)
  - assets/backend/Dockerfile
  - assets/frontend/Dockerfile
  - assets/model_download.sh

Services Included:
  - Backend API (FastAPI on :8000)
  - Frontend (React on :3000)
  - PostgreSQL (State management on :5432)
  - Milvus (Vector DB on :19530)
  - etcd (Coordination)
  - MinIO (Object storage)

Relevant for Sparky:
  ✓ Multi-container orchestration
  ✓ Backend/Frontend separation
  ✓ State persistence pattern
  ✓ Vector search integration
  ✓ Health checks and dependencies
```

#### 3. TRT-LLM Multi-Node (Distributed Pattern)
```
Path: /home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/trt-llm/assets/
Key Files:
  - docker-compose.yml (Swarm template)
  - trtllm-mn-entrypoint.sh (Entrypoint script)

Features:
  - Docker Swarm orchestration
  - MPI-based distributed inference
  - Multi-GPU tensor parallelism
  - Automatic node coordination
  - Health checks and restart policies

Relevant for Sparky (Later):
  ✓ Multi-node deployment pattern
  ✓ Resource reservation syntax
  ✓ Docker Swarm initialization
  ✓ Distributed processing setup
```

### Reference Playbooks

Additional playbooks useful for understanding patterns:

- **Open WebUI:** `/home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/open-webui/`
  - REST API to UI layer example
  - Custom app integration

- **LLaMA Factory:** `/home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/llama-factory/`
  - Fine-tuning examples

- **NIM (NVIDIA Inference Microservices):** `/home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/nim-llm/`
  - Alternative inference solution (proprietary)

---

## Sparky Project Structure

**Location:** `/home/beengud/raibid-labs/sparky/`

### Documentation (Your Analysis)
```
sparky/docs/
├── README_INFRASTRUCTURE.md          (Navigation guide)
├── EXECUTIVE_SUMMARY_OSS.md          (5-min overview)
├── OSS_DEPLOYMENT_STRATEGY.md        (Complete technical guide)
├── RESOURCE_MAP.md                   (This file)
├── architecture.md                   (Original project architecture)
├── parallel-workstreams.md           (Workstream organization)
└── zero-cost-architecture.md         (Original planning)
```

### Project Files
```
sparky/
├── README.md                         (Project overview)
├── EXECUTIVE_SUMMARY.md              (Original summary)
├── QUICK_START_GUIDE.md              (Day-by-day plan)
├── RESEARCH_REPORT_DEV_AUTOMATION_2025.md
├── TOOLS_AND_LIBRARIES.md
└── docs/examples/
    └── claude-code-agent.yml
```

---

## Key Files to Copy for Sparky Implementation

### Template 1: Simple Docker Compose (Start Here)
**Source:** `/home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/txt2kg/assets/deploy/compose/docker-compose.yml`

**What to Copy:**
- Ollama service configuration
- Health check pattern
- GPU resource allocation
- Volume definitions
- Network bridge setup

**How to Adapt:**
1. Keep Ollama service as-is
2. Replace Next.js frontend with Sparky processor service
3. Add PostgreSQL for summaries
4. Add Redis for caching (optional Phase 2)
5. Remove ArangoDB (unless needed)

### Template 2: Multi-Container Orchestration
**Source:** `/home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/multi-agent-chatbot/assets/docker-compose.yml`

**What to Copy:**
- Backend/Frontend pattern
- PostgreSQL configuration
- Service dependencies
- Health check patterns
- Network configuration

### Template 3: Distributed Setup (Phase 3)
**Source:** `/home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/trt-llm/assets/docker-compose.yml`

**What to Copy:**
- Docker Swarm syntax
- GPU resource reservation
- Multi-node coordination
- Entrypoint scripts
- Restart policies

---

## Models Available (All Free, OSS)

### Via Ollama (Recommended)
```
Command: ollama pull <model-name>

Models:
  - llama3.1:8b           (Recommended start)
  - llama3.1:70b          (Higher quality)
  - qwen2.5:32b           (Excellent balance)
  - qwen2.5:7b            (Lightweight)
  - gpt-oss:20b           (High quality)
  - phi4:latest           (Small, fast)
  - deepseek-coder:6.7b   (Code-focused)

Full list: https://ollama.com/library
```

### Via HuggingFace (Direct Download)
```
Models:
  - meta-llama/Llama-3.1-8B-Instruct
  - meta-llama/Llama-3.1-70B-Instruct
  - Qwen/Qwen2.5-32B-Instruct
  - openai/gpt-oss-20b
  - openai/gpt-oss-120b
  - mistralai/Mistral-7B-Instruct-v0.3

Via vLLM:
  vllm serve meta-llama/Llama-3.1-8B-Instruct

Via TRT-LLM:
  Pre-quantized NVFP4/FP8 versions available
```

---

## Infrastructure Status

### Hardware
```
GPU:            NVIDIA GB10 (Blackwell architecture)
Driver:         NVIDIA 580.95.05
CUDA:           13.0
Storage:        3.7TB available
```

### Container Infrastructure
```
Docker:         28.3.3 (GPU-enabled, configured)
Docker Compose: Available
Kubernetes:     K3s cluster (k3d-raibid-ci) running
Registry:       Internal registry at localhost:5000
```

### Network
```
All containers run locally
No external networking required after model downloads
Internal service-to-service communication via Docker networks
```

---

## Implementation Checklist

### Phase 0: Validation (Days 1-2)
- [ ] Read `/home/beengud/raibid-labs/sparky/docs/EXECUTIVE_SUMMARY_OSS.md`
- [ ] Review txt2kg docker-compose.yml
- [ ] Copy template to sparky/docker-compose.yml
- [ ] Deploy Ollama container
- [ ] Test LLM API with curl
- [ ] Record performance metrics

### Phase 1: Integration (Days 3-5)
- [ ] Create Sparky processor service
- [ ] Implement git data collector
- [ ] Connect to Ollama API
- [ ] Implement batch processing
- [ ] Add error handling and logging
- [ ] Test with 5-10 repositories

### Phase 2: Optimization (Days 6-10)
- [ ] Evaluate vLLM for upgrade
- [ ] Add PostgreSQL for summaries
- [ ] Implement Redis caching
- [ ] Tune batch sizes
- [ ] Add health checks
- [ ] Test with 50+ repositories

### Phase 3: Production (Days 11-15)
- [ ] Multi-worker deployment
- [ ] Add monitoring/observability
- [ ] Kubernetes manifests (optional)
- [ ] Integration with raibid-labs CI/CD
- [ ] Documentation and runbooks
- [ ] Launch production pipeline

---

## Quick Command Reference

### Deploy Ollama
```bash
docker run -d \
  --name ollama \
  --gpus all \
  -p 11434:11434 \
  -v ollama_data:/root/.ollama \
  ollama/ollama:latest
```

### Test LLM API
```bash
curl http://localhost:11434/api/chat \
  -d '{
    "model": "llama3.1:8b",
    "messages": [{"role": "user", "content": "Test"}],
    "stream": false
  }'
```

### Using Docker Compose (Recommended)
```bash
# Copy template
cp dgx-spark-playbooks/nvidia/txt2kg/assets/deploy/compose/docker-compose.yml \
   sparky/docker-compose.yml

# Deploy
docker compose -f sparky/docker-compose.yml up -d

# Check health
docker compose -f sparky/docker-compose.yml ps

# View logs
docker compose -f sparky/docker-compose.yml logs -f ollama
```

---

## Support & Resources

### Official Documentation
- Ollama: https://ollama.com
- vLLM: https://github.com/vllm-project/vllm
- TensorRT-LLM: https://github.com/NVIDIA/TensorRT-LLM
- Docker: https://docs.docker.com
- Kubernetes (K3s): https://k3s.io

### Local Resources
- DGX Spark Playbooks: `/home/beengud/raibid-labs/dgx-spark-playbooks/`
- Sparky Project: `/home/beengud/raibid-labs/sparky/`
- Each playbook includes detailed README.md

---

## File Manifest

### Documentation Files (Created)
```
/home/beengud/raibid-labs/sparky/docs/
├── README_INFRASTRUCTURE.md         (6.0 KB - Start here)
├── EXECUTIVE_SUMMARY_OSS.md         (6.0 KB - Quick overview)
├── OSS_DEPLOYMENT_STRATEGY.md       (22 KB - Complete guide)
└── RESOURCE_MAP.md                  (This file)
```

### Example Files (Ready to Copy)
```
/home/beengud/raibid-labs/dgx-spark-playbooks/nvidia/

txt2kg/ (RECOMMENDED TEMPLATE)
├── README.md
├── assets/deploy/compose/
│   ├── docker-compose.yml           (COPY THIS)
│   └── docker-compose.complete.yml

multi-agent-chatbot/
├── README.md
├── assets/docker-compose.yml        (COPY THIS)
└── assets/docker-compose-models.yml

trt-llm/
├── README.md
├── assets/docker-compose.yml        (FOR LATER)
└── assets/trtllm-mn-entrypoint.sh
```

---

## Next Steps

1. Start with this resource map to understand what's available
2. Read EXECUTIVE_SUMMARY_OSS.md for quick overview (5 min)
3. Review OSS_DEPLOYMENT_STRATEGY.md for details (25 min)
4. Copy txt2kg docker-compose.yml as template
5. Adapt for Sparky and deploy

Estimated time to production: 15 days

Good luck with Sparky!
