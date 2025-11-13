# Quick Start: Git Commit Summarization with OSS Models

**TL;DR:** Use Ollama + Qwen2.5-Coder-1.5B for fastest setup and excellent results.

---

## 5-Minute Setup (Development)

### Step 1: Install Ollama

```bash
# Linux/macOS
curl https://ollama.ai/install.sh | sh

# Or use Docker
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

### Step 2: Download Model

```bash
ollama pull qwen2.5-coder:1.5b
```

### Step 3: Test

```bash
# Interactive test
ollama run qwen2.5-coder:1.5b
# Then type: "Summarize: Added user authentication with JWT tokens"
```

### Step 4: Use via API

```python
import requests

def summarize_commit(diff):
    response = requests.post('http://localhost:11434/api/generate',
        json={
            'model': 'qwen2.5-coder:1.5b',
            'prompt': f'Write a one-line summary of this git commit:\n\n{diff}',
            'stream': False,
            'options': {'temperature': 0.3}
        })
    return response.json()['response']

# Example usage
diff = """
diff --git a/auth.py b/auth.py
+import jwt
+def create_token(user_id):
+    return jwt.encode({'user': user_id}, SECRET_KEY)
"""

print(summarize_commit(diff))
# Output: "Add JWT token creation function for user authentication"
```

---

## Alternative Models (Just Change the Pull Command)

```bash
# Smaller/Faster (0.5B)
ollama pull qwen2.5-coder:0.5b

# Higher Quality (3B)
ollama pull qwen2.5-coder:3b

# Best Quality (7B)
ollama pull qwen2.5-coder:7b

# Alternative: DeepSeek Coder
ollama pull deepseek-coder:1.3b

# Alternative: Phi-3
ollama pull phi3:mini
```

---

## Production Setup with vLLM

### Docker Deployment

```bash
docker run -d \
  --runtime nvidia --gpus all \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -p 8000:8000 \
  --ipc=host \
  --name vllm-server \
  vllm/vllm-openai:latest \
  --model Qwen/Qwen2.5-Coder-1.5B-Instruct
```

### Python Client (OpenAI Compatible)

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="not-needed"
)

def summarize_commit(diff):
    response = client.chat.completions.create(
        model="Qwen/Qwen2.5-Coder-1.5B-Instruct",
        messages=[{
            "role": "user",
            "content": f"Summarize this git commit in one line:\n\n{diff}"
        }],
        max_tokens=100,
        temperature=0.3
    )
    return response.choices[0].message.content
```

---

## Batch Processing Example

```python
import subprocess
import requests
from concurrent.futures import ThreadPoolExecutor

def get_recent_commits(n=10):
    """Get last N commits"""
    result = subprocess.check_output(
        ['git', 'log', f'-{n}', '--format=%H'],
        text=True
    )
    return result.strip().split('\n')

def get_commit_diff(commit_hash):
    """Get diff for a commit"""
    return subprocess.check_output(
        ['git', 'show', '--format=%B%n---', commit_hash],
        text=True
    )

def summarize_with_ollama(diff):
    """Summarize using Ollama"""
    response = requests.post('http://localhost:11434/api/generate',
        json={
            'model': 'qwen2.5-coder:1.5b',
            'prompt': f'Write a concise one-line summary:\n\n{diff}',
            'stream': False,
            'options': {'temperature': 0.3, 'num_predict': 100}
        })
    return response.json()['response']

def process_batch(num_commits=10):
    """Process commits in batch"""
    commits = get_recent_commits(num_commits)

    results = []
    for commit in commits:
        diff = get_commit_diff(commit)
        summary = summarize_with_ollama(diff)
        results.append({
            'commit': commit,
            'summary': summary
        })
        print(f"{commit[:8]}: {summary}")

    return results

# Run it
if __name__ == '__main__':
    summaries = process_batch(10)
```

---

## Docker Compose (Full Stack)

```yaml
version: '3.8'

services:
  ollama:
    image: ollama/ollama:latest
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    restart: unless-stopped

volumes:
  ollama_data:
```

**Usage:**
```bash
docker-compose up -d
docker exec ollama ollama pull qwen2.5-coder:1.5b
```

---

## Performance Expectations

| Model | Size | Speed (t/s) | RAM/VRAM | Quality |
|-------|------|-------------|----------|---------|
| qwen2.5-coder:0.5b | 0.5B | 100+ | 1GB | Good |
| qwen2.5-coder:1.5b | 1.5B | 70-100 | 2GB | Excellent |
| qwen2.5-coder:3b | 3B | 50-70 | 4GB | Excellent |
| qwen2.5-coder:7b | 7B | 30-50 | 6GB | Best |

**Per-commit time:** <1 second
**Batch of 100 commits:** 1-2 minutes

---

## Prompt Templates

### Basic
```python
f"Summarize this git commit in one line:\n\n{diff}"
```

### Conventional Commits
```python
f"""Generate a conventional commit message for this diff.
Format: <type>(<scope>): <description>
Types: feat, fix, docs, style, refactor, test, chore

{diff}

Conventional commit:"""
```

### Structured Output
```python
f"""Analyze this commit and output JSON:
{{"type": "...", "scope": "...", "summary": "...", "files_changed": [...]}}

{diff}

JSON:"""
```

---

## Troubleshooting

### Ollama not responding
```bash
# Check if running
curl http://localhost:11434/api/tags

# Restart
ollama serve
```

### Out of memory
```bash
# Use smaller model
ollama pull qwen2.5-coder:0.5b

# Or reduce context
OLLAMA_MAX_LOADED_MODELS=1 ollama serve
```

### Slow inference
```bash
# Check GPU usage
nvidia-smi

# Pull GPU-optimized version
ollama pull qwen2.5-coder:1.5b-fp16
```

---

## Resource Requirements Summary

**Minimum (CPU only):**
- RAM: 4GB
- Disk: 2GB
- Model: qwen2.5-coder:0.5b or 1.5b

**Recommended (GPU):**
- RAM: 8GB
- VRAM: 4GB (NVIDIA GPU)
- Disk: 5GB
- Model: qwen2.5-coder:1.5b or 3b

**Production (GPU):**
- RAM: 16GB
- VRAM: 6GB+
- Disk: 10GB
- Model: qwen2.5-coder:3b or 7b
- Server: vLLM

---

## Next Steps

1. Install Ollama (5 minutes)
2. Pull qwen2.5-coder:1.5b (2 minutes)
3. Test with your commits (5 minutes)
4. Integrate into workflow (1 hour)
5. Deploy to production (optional)

---

## Full Documentation

See `/home/beengud/raibid-labs/sparky/research/git-commit-summarization-oss-models.md` for comprehensive research and details.
