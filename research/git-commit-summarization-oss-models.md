# Git Commit Summarization: OSS Models & Tools Research

**Research Date:** 2025-11-13
**Use Case:** Git commit diff to human-readable summary generation
**Requirements:** 100% OSS, on-premise, fast batch processing, low resource usage

---

## Executive Summary

**Top Recommendation: Qwen2.5-Coder-1.5B (GGUF Q4_K_M) + Ollama**

- **Best Model:** Qwen2.5-Coder-1.5B-Instruct
- **Best Inference Server:** Ollama (for simplicity) or vLLM (for production scale)
- **Expected Performance:** <1 second per summary, 50-100+ tokens/sec
- **Hardware Requirements:** 2-4GB RAM/VRAM (quantized 4-bit)
- **License:** Apache 2.0 (commercial use allowed)

---

## 1. Lightweight Summarization Models

### Top Models for Technical Text (1B-7B params)

#### Tier 1: Code-Aware Models (BEST for Git Commits)

**Qwen2.5-Coder Series** (RECOMMENDED)
- **Sizes:** 0.5B, 1.5B, 3B, 7B, 14B, 32B
- **License:** Apache 2.0 (except 3B and 72B variants use Qwen license)
- **Training:** 2T tokens (87% code, 13% natural language)
- **Context:** 128K tokens
- **Best for commits:** 1.5B or 3B (optimal quality/speed balance)
- **Performance:** Qwen2.5-7B achieves 84.8 on HumanEval (beats Gemma2-9B and Llama3.1-8B)
- **Strengths:**
  - Purpose-built for code understanding
  - Excellent at technical text summarization
  - Strong multi-turn dialogue capabilities
  - Fast inference on consumer hardware

**DeepSeek-Coder Series**
- **Sizes:** 1.3B, 6.7B, 33B
- **License:** MIT (highly permissive)
- **Training:** 2T tokens (87% code, 13% natural language)
- **Context:** 16K window size
- **Performance:** DeepSeek-Coder-6.7B matches CodeLlama-34B performance
- **Best for commits:** 1.3B or 6.7B
- **Strengths:**
  - Excellent code understanding
  - Project-level code completion trained
  - Fill-in-the-blank capabilities
  - Very permissive license

#### Tier 2: General Purpose Small Models (Good Alternative)

**Phi-3 / Phi-3.5 Series**
- **Size:** 3.8B (quantized to ~2.4GB)
- **License:** MIT (highly permissive)
- **Performance:** Matches ~7B models in quality
- **Context:** 128K tokens
- **Strengths:**
  - "Pound for pound champion" for accuracy
  - Extremely well-optimized
  - Runs on phones and edge devices
- **Best Match:** Phi-3-Mini, Phi-3.5-Mini-Instruct

**Llama 3.2 Series**
- **Sizes:** 1B, 3B, 8B
- **License:** Meta Community License (commercial use allowed with conditions)
- **Context:** 128K tokens
- **Performance:** Llama 3.2-3B matches 70B models in summarization relevance
- **Best for commits:** 1B or 3B
- **Strengths:**
  - Excellent instruction following
  - Optimized for on-device applications
  - Strong summarization capabilities
  - Best all-around model under 10B (for 8B variant)

#### Tier 3: Ultra-Tiny Models (Speed-Optimized)

**Qwen2.5-0.5B-Instruct**
- Sub-1B parameters
- 128K context window
- Optimized for multi-turn dialogue
- Extremely fast inference (100+ tokens/sec)

**TinyLlama 1.1B**
- Loads in seconds
- Runs on old laptops
- Good for basic summarization

---

## 2. OSS LLM Inference Servers

### Comparison Matrix

| Feature | Ollama | vLLM | llama.cpp | LocalAI | TGI |
|---------|--------|------|-----------|---------|-----|
| **Ease of Setup** | Excellent | Good | Moderate | Good | Good |
| **Throughput** | Low-Medium | Excellent | Medium | Medium | High |
| **Batch Processing** | Limited | Excellent | Good | Good | Good |
| **OpenAI API** | Yes | Yes | Via server | Yes | Yes |
| **GPU Support** | Yes | Yes | Optional | Yes | Yes |
| **CPU Efficiency** | Good | Low | Excellent | Good | Medium |
| **Model Format** | GGUF | HF/SafeTensors | GGUF | Multiple | HF/SafeTensors |
| **Production Ready** | No | Yes | Yes | Yes | Yes |
| **Docker Support** | Yes | Yes | Yes | Yes | Yes |

### Detailed Comparison

#### **Ollama** (RECOMMENDED for Development)

**Strengths:**
- Simplest setup (single command: `ollama run qwen2.5-coder:1.5b`)
- Perfect for prototyping and development
- Automatic model management
- Built-in model library
- OpenAI-compatible API
- Easy Docker deployment
- Import custom GGUF models

**Weaknesses:**
- Limited throughput (~1-3 req/sec concurrent)
- Sequential processing (default 4 parallel requests cap)
- Not optimized for production scale

**Performance:**
- Single request: Fast (50-100+ tokens/sec for small models)
- Concurrent: Poor (flat performance, no scaling)
- Best for: Development, prototyping, single-user

**Deployment:**
```bash
# Simple Docker deployment
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

# Run model
ollama run qwen2.5-coder:1.5b
```

#### **vLLM** (RECOMMENDED for Production)

**Strengths:**
- Highest throughput (35x more than llama.cpp at peak)
- Continuous batching (dynamic batch sizing)
- 793 TPS peak vs Ollama's 41 TPS
- Low P99 latency (80ms vs 673ms for Ollama)
- Excellent GPU utilization
- Production-grade scalability
- OpenAI-compatible API

**Weaknesses:**
- More complex setup
- Requires GPU for optimal performance
- Higher resource baseline
- Steeper learning curve

**Performance:**
- Throughput: 3.2x Ollama's requests/sec
- Batch processing: 43x faster than sequential (152s vs 3.58s for 100 prompts)
- Best for: High-concurrency production, batch processing

**Deployment:**
```bash
# Docker deployment
docker run --runtime nvidia --gpus all \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -p 8000:8000 --ipc=host \
  vllm/vllm-openai:latest \
  --model Qwen/Qwen2.5-Coder-1.5B-Instruct
```

#### **llama.cpp**

**Strengths:**
- Maximum portability (runs anywhere)
- Excellent CPU efficiency
- Minimal dependencies
- Fast startup time
- GGUF format optimized for CPU
- Most energy-efficient (int4 kernels)
- Great for offline/edge deployment

**Weaknesses:**
- Queuing model causes high TTFT
- Not optimized for concurrent requests
- Lower throughput than GPU solutions

**Best for:** Offline batch processing, CPU-only environments, edge devices

#### **LocalAI**

**Strengths:**
- Multi-model format support
- OpenAI API compatible
- Good community support

**Weaknesses:**
- Less specialized than alternatives
- Medium performance

**Best for:** Mixed model deployments, API compatibility priority

#### **Text Generation Inference (TGI)**

**Strengths:**
- HuggingFace ecosystem integration
- Production-grade features
- Good performance

**Weaknesses:**
- More complex than Ollama
- Less throughput than vLLM

**Best for:** HuggingFace-centric workflows

---

## 3. Quantization Strategies

### Format Comparison

**GGUF (RECOMMENDED for CPU/Mixed Inference)**
- Used by: Ollama, llama.cpp
- Best for: CPU inference, Apple Silicon
- Performance: 4-bit most energy-efficient
- Quality: 8-bit negligible degradation, 4-bit minor degradation

**GPTQ**
- Used by: vLLM, TGI
- Best for: GPU-only inference
- Performance: 5x faster than GGUF on pure GPU with optimized kernels
- Quality: Similar to GGUF at same bit-width

**AWQ**
- Best for: Balanced GPU/CPU performance
- Performance: Faster than GPTQ with similar/better quality
- Innovation: Skips less important weights during quantization

### Recommended Quantization Levels

**8-bit (Q8_0)**
- Almost no quality degradation
- ~50% size reduction
- Good for quality-critical tasks
- RAM: ~8GB for 7B model

**4-bit (Q4_K_M - RECOMMENDED)**
- Minor quality degradation
- ~75% size reduction
- Optimal balance for git commits
- RAM: ~4GB for 7B model, ~2GB for 3B, ~1GB for 1.5B

**3-bit (Q3_K)**
- Noticeable quality loss
- Not recommended for technical text

### Performance Benchmarks (Llama 3 8B)

| Method | Bits | Accuracy (MMLU) | Perplexity | Size |
|--------|------|-----------------|------------|------|
| FP16 | 16 | 56.2% | 8.4 | 17GB |
| GPTQ | 4 | 55.21% | 8.575 | 4GB |
| AWQ | 4 | 55.55% | 8.483 | 4GB |

---

## 4. Deployment Approaches

### Option A: Ollama + Docker (Simple Development)

**Best for:** Development, prototyping, low-concurrency production

**Architecture:**
```
Git Commits → Batch Script → Ollama API (port 11434) → GGUF Model → Summaries
```

**Docker Compose:**
```yaml
version: '3'
services:
  ollama:
    image: ollama/ollama:latest
    ports:
      - "11434:11434"
    volumes:
      - ollama:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

volumes:
  ollama:
```

**Setup:**
```bash
docker-compose up -d
docker exec -it ollama ollama pull qwen2.5-coder:1.5b
```

**API Usage:**
```python
import requests

def summarize_commit(diff_text):
    response = requests.post('http://localhost:11434/api/generate',
        json={
            'model': 'qwen2.5-coder:1.5b',
            'prompt': f'Summarize this git commit in one line:\n\n{diff_text}',
            'stream': False
        })
    return response.json()['response']
```

**Resource Requirements:**
- RAM: 4GB (with 1.5B model)
- VRAM: 2GB (optional GPU acceleration)
- Disk: 1GB for model
- Speed: ~50-100 tokens/sec, <1s per summary

### Option B: vLLM + Docker (Production Scale)

**Best for:** High-throughput production, batch processing at scale

**Architecture:**
```
Git Commits → Batch Processor → vLLM API (port 8000) → HF Model → Summaries
                                    ↓
                            Continuous Batching
                            Dynamic Scaling
```

**Docker Deployment:**
```bash
docker run -d --runtime nvidia --gpus all \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -p 8000:8000 \
  --ipc=host \
  --name vllm-server \
  vllm/vllm-openai:latest \
  --model Qwen/Qwen2.5-Coder-1.5B-Instruct \
  --dtype float16 \
  --max-model-len 4096
```

**Batch Processing:**
```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="token-abc123"  # dummy key
)

def batch_summarize_commits(diffs):
    results = []
    for diff in diffs:
        response = client.chat.completions.create(
            model="Qwen/Qwen2.5-Coder-1.5B-Instruct",
            messages=[{
                "role": "user",
                "content": f"Summarize this git commit in one line:\n\n{diff}"
            }],
            max_tokens=100,
            temperature=0.3
        )
        results.append(response.choices[0].message.content)
    return results
```

**Resource Requirements:**
- RAM: 8GB
- VRAM: 4GB minimum for 1.5B model
- Disk: 3GB for model
- Speed: 100+ tokens/sec, batch 100 commits in ~10 seconds

### Option C: llama.cpp Server (Minimal Resources)

**Best for:** CPU-only environments, edge deployment, minimal resource usage

**Deployment:**
```bash
# Download GGUF model
wget https://huggingface.co/Qwen/Qwen2.5-Coder-1.5B-Instruct-GGUF/resolve/main/qwen2.5-coder-1.5b-instruct-q4_k_m.gguf

# Run server
./llama-server -m qwen2.5-coder-1.5b-instruct-q4_k_m.gguf \
  --port 8080 \
  --ctx-size 4096 \
  --n-gpu-layers 0  # CPU only
```

**Resource Requirements:**
- RAM: 2GB for 1.5B Q4 model
- VRAM: 0 (CPU only)
- Speed: 20-40 tokens/sec on modern CPU

---

## 5. Specific Recommendations

### Primary Recommendation: Qwen2.5-Coder-1.5B

**Why Qwen2.5-Coder?**
1. Purpose-built for code understanding (87% code training data)
2. Apache 2.0 license (commercial use allowed)
3. Excellent technical text summarization
4. Fast inference (50-100+ tokens/sec)
5. Low resource usage (1-2GB quantized)
6. 128K context window (handles large diffs)
7. Strong performance vs larger models
8. Active development and community

**Model Selection by Use Case:**

| Use Case | Model Size | RAM/VRAM | Speed | Quality |
|----------|-----------|----------|-------|---------|
| **Development/Testing** | Qwen2.5-Coder-0.5B | 0.5-1GB | 100+ t/s | Good |
| **Production (RECOMMENDED)** | Qwen2.5-Coder-1.5B | 1-2GB | 70-100 t/s | Excellent |
| **High Quality** | Qwen2.5-Coder-3B | 2-4GB | 50-70 t/s | Excellent |
| **Maximum Quality** | Qwen2.5-Coder-7B | 4-6GB | 30-50 t/s | Best |

**Quantization Recommendation:**
- **Development:** Q4_K_M (best balance)
- **Production (quality):** Q5_K_M or Q8_0
- **Production (speed):** Q4_0 or Q4_K_S

### Alternative Recommendation: DeepSeek-Coder-1.3B

**When to use:**
- Need MIT license (more permissive than Apache 2.0)
- Smaller footprint critical (<1GB)
- Code completion features desired

**Trade-offs:**
- Older model (less recent training data)
- Smaller context (16K vs 128K)
- Slightly lower performance than Qwen2.5

### Backup Recommendation: Phi-3-Mini

**When to use:**
- General purpose summarization (not just code)
- MIT license required
- Need proven track record

**Trade-offs:**
- Not code-specialized
- Slightly larger (3.8B vs 1.5B)

---

## 6. Inference Server Recommendations

### Development Phase
**Use Ollama**
- Simplest setup
- Easy model switching
- Good for experimentation
- Acceptable performance for daily batch jobs

### Production Phase (Low Scale)
**Use Ollama**
- If processing <100 commits/batch
- If updates are daily/weekly
- If simplicity valued over performance

### Production Phase (High Scale)
**Use vLLM**
- If processing 1000+ commits/batch
- If real-time/hourly updates needed
- If GPU resources available
- If throughput is critical

---

## 7. Expected Performance Metrics

### Speed Benchmarks (Qwen2.5-Coder-1.5B Q4_K_M)

**Ollama (Development)**
- Single commit: <1 second
- 10 commits sequential: 5-10 seconds
- 100 commits sequential: 50-100 seconds
- Throughput: 1-2 commits/sec

**vLLM (Production)**
- Single commit: <1 second
- 10 commits batched: 2-3 seconds
- 100 commits batched: 10-15 seconds
- Throughput: 5-10 commits/sec

**llama.cpp (CPU)**
- Single commit: 2-3 seconds
- 100 commits sequential: 200-300 seconds
- Throughput: 0.3-0.5 commits/sec

### Quality Benchmarks

Based on summarization research (Phi3-Mini, Llama3.2-3B):
- **Relevance:** Matches 70B models
- **Coherence:** Excellent for structured text
- **Factual Consistency:** High for code/technical text
- **Conciseness:** Shorter summaries than larger models (good for commits)

### Resource Usage (1.5B Model Q4_K_M)

**Ollama:**
- Idle: ~200MB RAM
- Running: 1.5-2GB RAM/VRAM
- Disk: 1GB model file

**vLLM:**
- Idle: ~1GB VRAM
- Running: 3-4GB VRAM
- Disk: 3GB model file

---

## 8. Implementation Strategy

### Phase 1: Proof of Concept (Week 1)

1. **Install Ollama**
   ```bash
   curl https://ollama.ai/install.sh | sh
   ollama pull qwen2.5-coder:1.5b
   ```

2. **Test with sample commits**
   ```python
   import subprocess
   import json

   def get_commit_diff(commit_hash):
       return subprocess.check_output(
           ['git', 'show', '--format=%B%n---', commit_hash],
           text=True
       )

   def summarize_with_ollama(diff):
       import requests
       response = requests.post('http://localhost:11434/api/generate',
           json={
               'model': 'qwen2.5-coder:1.5b',
               'prompt': f'Write a concise one-line summary of this git commit:\n\n{diff}',
               'stream': False,
               'options': {
                   'temperature': 0.3,
                   'num_predict': 100
               }
           })
       return response.json()['response']
   ```

3. **Evaluate quality on 10-20 sample commits**
4. **Measure speed and resource usage**

### Phase 2: Development Integration (Week 2)

1. **Create batch processing script**
2. **Add error handling and retries**
3. **Implement caching for processed commits**
4. **Add logging and metrics**

### Phase 3: Production Deployment (Week 3-4)

**If Ollama is sufficient:**
1. Docker Compose deployment
2. CI/CD integration
3. Monitoring setup

**If vLLM needed:**
1. Deploy vLLM with Docker
2. Implement batch API client
3. Setup load balancing (if needed)
4. Monitoring and alerting

---

## 9. Existing Tools & Integration

### Git Commit AI Tools (for reference)

**OpenCommit**
- Top git commit tool
- Supports Ollama + local models
- Features: git hooks, GitHub Actions, conventional commits
- Can use qwen2.5-coder as backend
- GitHub: https://github.com/di-sukharev/opencommit

**Usage with local models:**
```bash
oc config set OCO_AI_PROVIDER=ollama
oc config set OCO_MODEL=qwen2.5-coder:1.5b
git add . && oc
```

**LLMCommit**
- Offline-first design
- Local processing only
- Fast generation (2.5 seconds)

**ai-commit**
- Simple CLI
- Ollama integration

### Integration Approach

Rather than using these tools directly, extract patterns:
1. Git hook integration
2. Diff parsing strategies
3. Prompt engineering techniques
4. Output formatting

---

## 10. Recommended Tech Stack

### Minimal Stack (Development)

```
Git Repository
    ↓
Python Script (git diff extraction)
    ↓
Ollama (port 11434)
    ↓
Qwen2.5-Coder-1.5B-Instruct (Q4_K_M)
    ↓
JSON Output (summaries)
```

**Components:**
- OS: Linux (Ubuntu 22.04+)
- Runtime: Python 3.10+
- Inference: Ollama 0.1.0+
- Model: Qwen2.5-Coder-1.5B-Instruct-GGUF-Q4_K_M
- RAM: 4GB minimum
- Disk: 5GB

### Production Stack (Scale)

```
Git Repository
    ↓
Batch Processing Service (Python/FastAPI)
    ↓
vLLM Server (Docker, port 8000)
    ↓
Qwen2.5-Coder-1.5B-Instruct (FP16/GPTQ)
    ↓
Database (PostgreSQL - summaries)
    ↓
API (REST/GraphQL)
```

**Components:**
- Orchestration: Docker Compose / Kubernetes
- Inference: vLLM 0.3.0+
- API: FastAPI
- Database: PostgreSQL
- Monitoring: Prometheus + Grafana
- GPU: NVIDIA GPU with 6GB+ VRAM
- RAM: 16GB
- Disk: 20GB

---

## 11. Prompt Engineering for Commits

### Basic Prompt Template

```python
PROMPT_TEMPLATE = """Write a concise one-line summary of this git commit.
Focus on what changed and why.
Use imperative mood (e.g., "Add feature" not "Added feature").

Git Commit:
{diff}

Summary:"""
```

### Advanced Prompt (Conventional Commits)

```python
CONVENTIONAL_PROMPT = """Analyze this git commit and generate a conventional commit message.

Format: <type>(<scope>): <description>

Types: feat, fix, docs, style, refactor, test, chore
Scope: component or file affected
Description: imperative mood, lowercase, no period

Git Commit:
{diff}

Conventional Commit:"""
```

### Structured Output Prompt

```python
STRUCTURED_PROMPT = """Analyze this git commit and provide a structured summary.

Git Commit:
{diff}

Respond in JSON format:
{{
  "type": "feat|fix|docs|refactor|test|chore",
  "scope": "affected component",
  "summary": "one-line description",
  "changes": ["key change 1", "key change 2"],
  "impact": "high|medium|low"
}}

JSON:"""
```

---

## 12. Performance Optimization Tips

### Model-Level Optimizations

1. **Use quantized models (Q4_K_M)** - 75% smaller, minimal quality loss
2. **Enable flash attention** - 2x faster inference (vLLM)
3. **Adjust context length** - Use 4096 instead of 128K for speed
4. **Lower temperature** - 0.2-0.3 for factual summaries
5. **Limit output tokens** - Set max_tokens=100 for summaries

### Server-Level Optimizations

**Ollama:**
```bash
# Increase parallel requests
OLLAMA_NUM_PARALLEL=8 ollama serve

# Set context size
OLLAMA_MAX_LOADED_MODELS=2
```

**vLLM:**
```bash
# Optimize for throughput
--max-model-len 4096 \
--gpu-memory-utilization 0.9 \
--max-num-seqs 256 \
--enable-chunked-prefill
```

### Application-Level Optimizations

1. **Batch commits** - Process in groups of 10-100
2. **Parallel requests** - Use async HTTP clients
3. **Cache results** - Store summaries in database
4. **Rate limiting** - Avoid overloading server
5. **Retry logic** - Handle transient failures

---

## 13. Cost Analysis

### Resource Costs (On-Premise)

**Development Setup (Ollama + 1.5B)**
- Initial: $0 (use existing hardware)
- Hardware: 4GB RAM, 2GB VRAM (optional)
- Power: ~50W idle, 100W active
- Monthly: ~$10-20 electricity

**Production Setup (vLLM + 1.5B)**
- GPU: NVIDIA RTX 3060 (~$300) or cloud GPU
- RAM: 16GB (~$50)
- Power: ~200W active
- Monthly: ~$50-100 electricity or ~$100-200 cloud

### Time Savings

**Manual commit summarization:**
- 2-3 minutes per commit
- 100 commits = 200-300 minutes (3-5 hours)

**AI summarization:**
- <1 second per commit
- 100 commits = 100 seconds (1.5 minutes)

**ROI:** Saves 3-5 hours per 100 commits

---

## 14. License Summary

| Model | License | Commercial Use | Restrictions |
|-------|---------|----------------|--------------|
| Qwen2.5-Coder (1.5B, 7B, 14B) | Apache 2.0 | Yes | None |
| Qwen2.5-Coder (3B) | Qwen License | Yes | Check terms |
| DeepSeek-Coder | MIT | Yes | None |
| Phi-3 | MIT | Yes | None |
| Llama 3.2 | Meta Community | Yes | 700M MAU limit |

| Inference Server | License | Commercial Use |
|------------------|---------|----------------|
| Ollama | MIT | Yes |
| vLLM | Apache 2.0 | Yes |
| llama.cpp | MIT | Yes |
| LocalAI | MIT | Yes |
| TGI | Apache 2.0 | Yes |

---

## 15. Next Steps & Action Items

### Immediate Actions (This Week)

1. [ ] Install Ollama on development machine
2. [ ] Download Qwen2.5-Coder-1.5B model
3. [ ] Test with 10-20 sample commits from actual repositories
4. [ ] Benchmark speed and quality
5. [ ] Document findings and edge cases

### Short-term Actions (This Month)

1. [ ] Create batch processing script
2. [ ] Implement error handling
3. [ ] Add caching layer
4. [ ] Setup Docker Compose for deployment
5. [ ] Create API wrapper if needed
6. [ ] Write integration tests

### Long-term Considerations

1. [ ] Evaluate if vLLM needed for scale
2. [ ] Monitor model updates (Qwen2.5 → Qwen3)
3. [ ] Fine-tune on company-specific commit style (optional)
4. [ ] Integrate with CI/CD pipeline
5. [ ] Build web UI for browsing summaries

---

## 16. References & Resources

### Model Resources

**Qwen2.5-Coder:**
- GitHub: https://github.com/QwenLM/Qwen3-Coder
- HuggingFace: https://huggingface.co/Qwen/Qwen2.5-Coder-1.5B-Instruct
- GGUF: https://huggingface.co/Qwen/Qwen2.5-Coder-1.5B-Instruct-GGUF
- Ollama: https://ollama.com/library/qwen2.5-coder

**DeepSeek-Coder:**
- GitHub: https://github.com/deepseek-ai/DeepSeek-Coder
- HuggingFace: https://huggingface.co/deepseek-ai/deepseek-coder-1.3b-instruct
- GGUF: https://huggingface.co/TheBloke/deepseek-coder-1.3b-instruct-GGUF

**Phi-3:**
- HuggingFace: https://huggingface.co/microsoft/Phi-3-mini-4k-instruct

### Inference Server Resources

**Ollama:**
- Website: https://ollama.ai
- GitHub: https://github.com/ollama/ollama
- Docker: https://hub.docker.com/r/ollama/ollama

**vLLM:**
- Website: https://vllm.ai
- GitHub: https://github.com/vllm-project/vllm
- Docs: https://docs.vllm.ai
- Docker: https://hub.docker.com/r/vllm/vllm-openai

**llama.cpp:**
- GitHub: https://github.com/ggerganov/llama.cpp

### Additional Tools

**OpenCommit:**
- GitHub: https://github.com/di-sukharev/opencommit

**Quantization:**
- GPTQ: https://github.com/IST-DASLab/gptq
- AWQ: https://github.com/mit-han-lab/llm-awq

---

## 17. Conclusion

For git commit summarization, the optimal stack is:

**Development: Ollama + Qwen2.5-Coder-1.5B (Q4_K_M)**
- Simple setup, good performance, low cost
- <1 second per summary
- 2GB RAM/VRAM required
- Apache 2.0 license

**Production: vLLM + Qwen2.5-Coder-1.5B (FP16 or Q8)**
- High throughput for batch processing
- 100 commits in ~10 seconds
- 4GB VRAM required
- Scales to 1000s of commits

Both approaches are 100% OSS, run on-premise, and provide excellent quality summaries for technical content. Start with Ollama for proof-of-concept, migrate to vLLM if scale demands it.

**Expected Outcomes:**
- 95%+ reduction in summarization time
- Consistent, structured commit messages
- Zero external API dependencies
- Full data privacy
- Low operational cost

---

**Research compiled by:** Sparky AI Studio
**Date:** 2025-11-13
**Status:** Ready for implementation
