# Sparky Zero-Cost Architecture

**Version:** 2.0 (Revised)
**Date:** 2025-11-12
**Focus:** No API costs - OSS tools + Claude Code agents

## Overview

This revised architecture eliminates all API costs by using:
- **Local git analysis** (no GitHub API)
- **OSS LLMs** (Ollama) or **Claude Code agents** (your existing subscription)
- **Standard command-line tools** (git, jq, grep, etc.)
- **Simple file-based storage** (no external databases)

## Cost Breakdown

```
GitHub Actions:    $0 (included in org)
Claude API:        $0 (using Claude Code instead)
Ollama:            $0 (self-hosted)
Infrastructure:    $0 (local file system)
Storage:           $0 (git repository)
Total:             $0/month 🎉
```

## Architecture Comparison

### Old (API-based) ❌
```
GitHub Actions → Claude API → $15-45/month
```

### New (Zero-Cost) ✅
```
Option A: GitHub Actions → Claude Code agents → $0
Option B: Local scripts → Ollama (local LLM) → $0
Option C: Manual trigger → Claude Code session → $0
```

## Revised System Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Trigger Mechanism (choose one)              │
│  1. GitHub Actions (scheduled)                           │
│  2. Manual execution (cron or adhoc)                     │
│  3. Git hooks (on push to main)                          │
└─────────────────┬───────────────────────────────────────┘
                  │
         ┌────────┴────────┐
         │                 │
         ▼                 ▼
┌──────────────┐  ┌──────────────────┐
│ Local Git    │  │ GitHub CLI       │
│ Analysis     │  │ (gh command)     │
│ (git log)    │  │ (free, no quota) │
└──────┬───────┘  └────────┬─────────┘
       │                   │
       └─────────┬─────────┘
                 │
                 ▼
      ┌────────────────────┐
      │ Data Collection    │
      │ (Bash/Python)      │
      │ - commits.json     │
      │ - prs.json         │
      │ - stats.json       │
      └─────────┬──────────┘
                │
                ▼
      ┌────────────────────┐
      │ Analysis Engine    │
      │ (Choose one:)      │
      │ A. Claude Code     │
      │ B. Ollama (local)  │
      │ C. Rule-based      │
      └─────────┬──────────┘
                │
                ▼
      ┌────────────────────┐
      │ Content Generator  │
      │ (Choose one:)      │
      │ A. Claude Code     │
      │ B. Ollama          │
      │ C. Templates       │
      └─────────┬──────────┘
                │
                ▼
      ┌────────────────────┐
      │ Output Files       │
      │ - daily/*.md       │
      │ - weekly/*.md      │
      │ - monthly/*.md     │
      └────────────────────┘
```

## Implementation Approaches

### Approach A: Claude Code Agents (Recommended)

**Concept:** Use Claude Code (your existing subscription) to analyze and generate content

**How It Works:**
1. GitHub Action collects raw data (git logs, gh cli output)
2. Creates a GitHub issue with collected data
3. Issue triggers Claude Code agent via comment
4. Agent analyzes data and generates content
5. Agent commits result to repository

**Pros:**
- Uses your existing Claude subscription (no new costs)
- High-quality AI analysis
- Leverages existing raibid-labs orchestrator patterns
- No local infrastructure needed

**Cons:**
- Requires GitHub issue/PR workflow
- Not fully automated (needs agent spawn)
- Rate limited by your Claude subscription

**Implementation:**
```bash
# 1. Collect data
./scripts/collect-git-data.sh > data/daily/2025-11-12-raw.json

# 2. Create GitHub issue with data
gh issue create \
  --title "Sparky Daily Analysis: 2025-11-12" \
  --body "$(cat data/daily/2025-11-12-raw.json)" \
  --label "sparky-daily"

# 3. Post agent spawn trigger
gh issue comment <issue-id> \
  --body "SPARKY-SPAWN-ANALYSIS-AGENT"

# 4. Claude Code agent responds with analysis
# 5. Agent commits generated content to repo
```

### Approach B: Local Ollama LLM

**Concept:** Self-hosted OSS LLM for analysis and content generation

**How It Works:**
1. Install Ollama on your machine or a server
2. Use llama3, mistral, or qwen models (free)
3. Scripts call Ollama API (local, no cost)
4. Generate content using local LLM

**Pros:**
- Completely free and unlimited
- Full privacy (no data leaves your network)
- Fast response times (local processing)
- No rate limits

**Cons:**
- Requires local infrastructure (RAM, GPU helpful)
- Lower quality than Claude/GPT-4
- Need to fine-tune prompts for OSS models

**Implementation:**
```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull a model (one-time, ~4GB download)
ollama pull llama3

# Use in scripts
cat data/daily/2025-11-12-raw.json | \
  ollama run llama3 "Analyze this git activity and create a daily digest..."
```

### Approach C: Rule-Based + Templates (No AI)

**Concept:** Simple statistical analysis with Markdown templates

**How It Works:**
1. Collect git data (commits, PRs, etc.)
2. Calculate basic metrics (commit count, top contributors)
3. Fill in Markdown templates with data
4. No AI, just data aggregation

**Pros:**
- Zero cost, zero dependencies
- Fast and reliable
- Easy to debug and customize
- Predictable output

**Cons:**
- No semantic analysis or insights
- No natural language generation
- Mechanical, not narrative
- Limited intelligence

**Implementation:**
```bash
# Calculate stats
COMMIT_COUNT=$(git log --since="1 day ago" --all --oneline | wc -l)
TOP_CONTRIBUTOR=$(git log --since="1 day ago" --all --format="%an" | \
  sort | uniq -c | sort -rn | head -1)

# Fill template
cat templates/daily.md | \
  sed "s/{{COMMIT_COUNT}}/$COMMIT_COUNT/g" | \
  sed "s/{{TOP_CONTRIBUTOR}}/$TOP_CONTRIBUTOR/g" \
  > output/daily/2025-11-12.md
```

## Recommended Hybrid Approach

**Best of all worlds: Mix approaches based on task**

```
Data Collection:     100% free (git, gh cli)
Statistical Analysis: Rule-based (free)
Narrative Generation: Claude Code agents (your subscription)
Publishing:          Git commits (free)
```

**Workflow:**
1. **Automated collection** (GitHub Actions, runs daily)
   - Collect git logs from all repos
   - Run basic statistics
   - Save raw data to JSON files

2. **Manual AI analysis** (when you want high-quality output)
   - Trigger Claude Code agent
   - Agent reads raw data
   - Agent generates narrative content
   - Agent commits to repo

3. **Automatic publishing** (GitHub Actions)
   - Push to docs repository
   - Create index pages
   - No AI needed

**Cost:** $0 (uses your existing Claude subscription only when needed)

## Data Collection (Zero-Cost)

### Local Git Analysis

```bash
#!/bin/bash
# scripts/collect-local.sh

# Collect commits from all local repos
for repo in ~/raibid-labs/*; do
  cd "$repo"
  git log --since="1 day ago" \
    --pretty=format:'{"repo":"%d","commit":"%H","author":"%an","date":"%ai","message":"%s"}' \
    --all
done | jq -s '.' > data/daily/$(date +%Y-%m-%d)-commits.json
```

**Cost:** $0 (local git commands)
**Pros:** No API limits, instant results
**Cons:** Requires local clones of all repos

### GitHub CLI (Free, No API Limits)

```bash
#!/bin/bash
# scripts/collect-gh.sh

# GitHub CLI doesn't count against API rate limits
gh repo list raibid-labs --limit 100 --json name | \
  jq -r '.[].name' | \
  while read repo; do
    gh pr list --repo raibid-labs/$repo \
      --state merged \
      --search "merged:>=2025-11-12" \
      --json number,title,author,mergedAt
  done | jq -s '.' > data/daily/$(date +%Y-%m-%d)-prs.json
```

**Cost:** $0 (gh CLI is free)
**Pros:** No rate limits, official tool
**Cons:** Slower than GraphQL API

## Analysis Engine Options

### Option 1: Claude Code Agent

**Create agent that analyzes data:**

```yaml
---
name: sparky-analyzer
description: Analyzes git activity data and generates insights
tools: Read, Write
---

You are Sparky's analysis engine. Your job is to:

1. Read raw git data from JSON files
2. Identify patterns, trends, and notable changes
3. Generate insightful summaries
4. Write output to markdown files

When invoked:
- Read: data/daily/YYYY-MM-DD-*.json
- Analyze commits, PRs, contributors
- Write: output/daily/YYYY-MM-DD.md

Focus on:
- Top contributors and their impact
- Project activity trends
- Significant changes
- Team collaboration patterns
```

**Usage:**
```bash
# Trigger agent via GitHub issue or manual session
claude-code --agent sparky-analyzer \
  --input data/daily/2025-11-12-commits.json \
  --output output/daily/2025-11-12.md
```

### Option 2: Ollama (Local LLM)

**Setup:**
```bash
# Install and run
ollama serve

# Pull model (one-time)
ollama pull llama3  # or mistral, qwen2.5, etc.
```

**Script integration:**
```python
# scripts/analyze-with-ollama.py
import json
import subprocess

def analyze_activity(data):
    prompt = f"""
    Analyze this git activity data and generate a daily digest.

    Data:
    {json.dumps(data, indent=2)}

    Create a summary with:
    - Key highlights
    - Top contributors
    - Notable changes
    - Activity trends

    Format as Markdown.
    """

    result = subprocess.run(
        ['ollama', 'run', 'llama3'],
        input=prompt,
        capture_output=True,
        text=True
    )

    return result.stdout

# Load data
with open('data/daily/2025-11-12-commits.json') as f:
    data = json.load(f)

# Generate analysis
summary = analyze_activity(data)

# Save output
with open('output/daily/2025-11-12.md', 'w') as f:
    f.write(summary)
```

### Option 3: Rule-Based (Pure Bash/Python)

**Simple statistical analysis:**
```bash
#!/bin/bash
# scripts/analyze-rule-based.sh

DATE=$(date +%Y-%m-%d)
DATA_FILE="data/daily/$DATE-commits.json"
OUTPUT_FILE="output/daily/$DATE.md"

# Calculate stats
TOTAL_COMMITS=$(jq length "$DATA_FILE")
REPOS=$(jq -r '.[].repo' "$DATA_FILE" | sort -u)
REPO_COUNT=$(echo "$REPOS" | wc -l)
TOP_AUTHOR=$(jq -r '.[].author' "$DATA_FILE" | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')

# Generate markdown
cat > "$OUTPUT_FILE" <<EOF
# raibid-labs Daily Digest - $DATE

## Overview
- **Total Commits:** $TOTAL_COMMITS
- **Active Repositories:** $REPO_COUNT
- **Top Contributor:** $TOP_AUTHOR

## Active Projects
$(echo "$REPOS" | sed 's/^/- /')

## Commit Activity
$(jq -r '.[] | "- [\(.repo)] \(.message) (@\(.author))"' "$DATA_FILE" | head -20)

---
*Generated by Sparky (rule-based analysis)*
EOF
```

## Content Generation

### Using Claude Code (Recommended)

**Create dedicated content generator agent:**

```yaml
---
name: sparky-writer
description: Generates polished content from analysis data
tools: Read, Write
---

You are Sparky's content writer. Transform analysis data into engaging content.

Styles:
- Daily: Casual, bullet points, quick scan (200-300 words)
- Weekly: Professional, narrative, comprehensive (800-1200 words)
- Monthly: Polished, reflective, strategic (2000-3000 words)

Always include:
- Engaging headline
- Key takeaways upfront
- Human-friendly language
- Celebration of accomplishments
```

### Using Ollama with Better Prompts

```python
# scripts/generate-content-ollama.py
import json
import subprocess

def generate_daily_digest(analysis_data):
    prompt = f"""
You are a technical writer for raibid-labs. Create a compelling daily digest.

Analysis Data:
{analysis_data}

Requirements:
- Casual, friendly tone
- 200-300 words
- Bullet points for key highlights
- Celebrate team accomplishments
- Mention top contributors by name

Format: Markdown with clear sections.
"""

    result = subprocess.run(
        ['ollama', 'run', 'llama3'],
        input=prompt,
        capture_output=True,
        text=True
    )

    return result.stdout
```

### Using Templates (No AI)

```markdown
<!-- templates/daily.md -->
# raibid-labs Daily Digest - {{DATE}}

## 📊 Today's Activity

- **{{COMMIT_COUNT}}** commits across **{{REPO_COUNT}}** repositories
- **{{PR_COUNT}}** pull requests merged
- **{{CONTRIBUTOR_COUNT}}** active contributors

## 🏆 Top Contributors

{{TOP_CONTRIBUTORS}}

## 🚀 Active Projects

{{ACTIVE_REPOS}}

## 📝 Notable Commits

{{NOTABLE_COMMITS}}

---

*Automated digest powered by Sparky*
```

## Automation Workflows

### Option 1: GitHub Actions + Claude Code

```yaml
# .github/workflows/sparky-daily.yml
name: Sparky Daily Collection

on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight
  workflow_dispatch:

jobs:
  collect:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Collect Git Data
        run: |
          ./scripts/collect-gh.sh

      - name: Create Analysis Issue
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          gh issue create \
            --title "Sparky Daily: $(date +%Y-%m-%d)" \
            --body-file data/daily/$(date +%Y-%m-%d)-raw.json \
            --label "sparky-daily"

      - name: Comment to Trigger Agent
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          ISSUE_NUM=$(gh issue list --label sparky-daily --limit 1 --json number -q '.[0].number')
          gh issue comment $ISSUE_NUM \
            --body "SPARKY-SPAWN-WRITER-AGENT"
```

**Then manually or via orchestrator:**
- Claude Code agent reads issue
- Analyzes data
- Generates content
- Commits to repo
- Closes issue

### Option 2: Local Cron + Ollama

```bash
# Add to crontab
0 0 * * * cd ~/raibid-labs/sparky && ./scripts/daily-pipeline-local.sh

# scripts/daily-pipeline-local.sh
#!/bin/bash
set -e

DATE=$(date +%Y-%m-%d)

# 1. Collect data
./scripts/collect-local.sh

# 2. Analyze with Ollama
python3 scripts/analyze-with-ollama.py

# 3. Generate content
python3 scripts/generate-content-ollama.py

# 4. Commit and push
git add output/daily/$DATE.md
git commit -m "Add daily digest for $DATE"
git push origin main
```

### Option 3: Manual Trigger + Claude Code Session

```bash
# Run when you want fresh content
./scripts/collect-and-prepare.sh

# This creates prepared.md with all the data
# Then you open Claude Code and say:

"Read prepared.md and create a daily digest in output/daily/2025-11-12.md
following the style guide in docs/style-guide.md"
```

## Storage Structure (File-Based, Zero Cost)

```
sparky/
├── data/
│   ├── raw/
│   │   ├── 2025-11-12-commits.json
│   │   ├── 2025-11-12-prs.json
│   │   └── 2025-11-12-stats.json
│   └── processed/
│       └── 2025-11-12-analysis.json
├── output/
│   ├── daily/
│   │   ├── 2025-11-12.md
│   │   └── 2025-11-13.md
│   ├── weekly/
│   │   └── 2025-W45.md
│   └── monthly/
│       └── 2025-11.md
├── scripts/
│   ├── collect-local.sh
│   ├── collect-gh.sh
│   ├── analyze-with-ollama.py
│   ├── analyze-rule-based.sh
│   └── generate-content-ollama.py
└── templates/
    ├── daily.md
    ├── weekly.md
    └── monthly.md
```

## Performance Comparison

| Approach | Quality | Speed | Cost | Automation |
|----------|---------|-------|------|------------|
| Claude Code | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | $0* | ⭐⭐⭐ |
| Ollama (llama3) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | $0 | ⭐⭐⭐⭐⭐ |
| Rule-Based | ⭐⭐ | ⭐⭐⭐⭐⭐ | $0 | ⭐⭐⭐⭐⭐ |

*Uses existing Claude subscription

## Recommended Implementation Path

### Phase 1: Start Simple (Week 1)
- Use **rule-based analysis** for automated daily stats
- Manual **Claude Code** for weekly narrative (when you have time)
- File-based storage, no external dependencies

### Phase 2: Add Intelligence (Week 2-3)
- Install **Ollama** locally
- Automate daily digest generation with Ollama
- Keep Claude Code for monthly reviews (highest quality)

### Phase 3: Full Automation (Week 4+)
- GitHub Actions triggers data collection
- Ollama generates daily/weekly automatically
- Claude Code for monthly (manual trigger for quality)

## Cost Comparison: Old vs New

### Old Architecture
```
Claude API:     $15-45/month
GitHub API:     $0 (within limits)
Total:          $15-45/month
```

### New Architecture
```
Claude Code:    $0 (existing subscription, manual triggers)
Ollama:         $0 (self-hosted)
Git commands:   $0 (local)
GitHub CLI:     $0 (free)
Total:          $0/month 🎉
```

## Next Steps

1. Choose your approach:
   - **Quick start:** Rule-based + manual Claude Code
   - **Best quality:** Claude Code agents + GitHub orchestration
   - **Full automation:** Ollama + cron jobs

2. Implement data collection (all approaches need this)
   ```bash
   mkdir -p data/{raw,processed} output/{daily,weekly,monthly}
   cp docs/examples/collect-gh.sh scripts/
   chmod +x scripts/collect-gh.sh
   ```

3. Test your chosen analysis method
   - Claude Code: Create agent and test manually
   - Ollama: Install and run test prompt
   - Rule-based: Run bash script on sample data

4. Automate what makes sense
   - Data collection: Daily cron or GitHub Actions
   - Analysis: Based on your chosen method
   - Publishing: Git commits (always automated)

## Examples

See `docs/examples/` for:
- `collect-gh.sh` - Zero-cost data collection
- `analyze-ollama.py` - Local LLM analysis
- `claude-code-agent.yml` - Agent configuration
- `daily-template.md` - Simple template example

---

**Philosophy:** Start simple, automate gradually, zero cost always.
