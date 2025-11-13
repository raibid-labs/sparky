# Tools & Libraries Reference Guide

**Comprehensive list with direct links and use cases**

---

## GIT ANALYSIS TOOLS

### Visualization & GUI Tools

| Tool | Link | Language | License | Use Case |
|------|------|----------|---------|----------|
| **Gource** | https://gource.io | C++ | GPL-3.0 | Animated visualization, demo videos |
| **GitUp** | https://gitup.co | Objective-C | GPL-2.0 | Fast macOS client, 40k+ commits/sec |
| **Gilot** | https://github.com/hirokidaichi/gilot | JavaScript | MIT | Bug prediction, hotspot detection |
| **GitKraken** | https://www.gitkraken.com | Proprietary | Commercial | Team collaboration, visual client |
| **GitHub Desktop** | https://desktop.github.com | TypeScript | MIT | Official GitHub client |

### Analysis Libraries

#### Python
| Library | PyPI | GitHub | Best For |
|---------|------|--------|----------|
| **GitPython** | `pip install gitpython` | https://github.com/gitpython-developers/GitPython | Local repo analysis |
| **PyGithub** | `pip install PyGithub` | https://github.com/PyGithub/PyGithub | GitHub API interaction |
| **git-fame** | `pip install git-fame` | https://github.com/casperdcl/git-fame | Contributor stats |
| **gitinspector** | `pip install gitinspector` | https://github.com/ejwa/gitinspector | Statistical analysis |

#### JavaScript/TypeScript
| Library | NPM | GitHub | Best For |
|---------|-----|--------|----------|
| **Octokit** | `npm install octokit` | https://github.com/octokit/octokit.js | GitHub API (official SDK) |
| **simple-git** | `npm install simple-git` | https://github.com/steveukx/git-js | Git commands in Node.js |
| **nodegit** | `npm install nodegit` | https://github.com/nodegit/nodegit | libgit2 bindings |
| **isomorphic-git** | `npm install isomorphic-git` | https://github.com/isomorphic-git/isomorphic-git | Pure JS Git implementation |

#### Go
| Library | Go Get | GitHub | Best For |
|---------|--------|--------|----------|
| **go-git** | `go get github.com/go-git/go-git/v5` | https://github.com/go-git/go-git | Pure Go Git implementation |
| **Hercules** | `go get github.com/src-d/hercules` | https://github.com/src-d/hercules | Full history analysis |

#### Ruby
| Library | Gem | GitHub | Best For |
|---------|-----|--------|----------|
| **rugged** | `gem install rugged` | https://github.com/libgit2/rugged | libgit2 bindings |
| **git** | `gem install git` | https://github.com/ruby-git/ruby-git | Pure Ruby interface |

### Advanced Analysis Platforms
| Platform | Link | Type | Use Case |
|----------|------|------|----------|
| **GrimoireLab** | https://chaoss.github.io/grimoirelab | Open Source | Comprehensive metrics |
| **RepoSense** | https://github.com/reposense/RepoSense | Open Source | Contribution analysis |
| **gitbase** | https://github.com/src-d/gitbase | Open Source | SQL queries on Git |
| **eazyBI** | https://eazybi.com/blog/analyze-and-visualize-git-log | Commercial | OLAP analysis |

---

## GITHUB API & TOOLS

### Official GitHub Tools

| Tool | Link | Description |
|------|------|-------------|
| **GitHub CLI** | https://cli.github.com | Official command-line tool |
| **GitHub REST API** | https://docs.github.com/en/rest | REST API v3 documentation |
| **GitHub GraphQL API** | https://docs.github.com/en/graphql | GraphQL API v4 documentation |
| **GitHub API Explorer** | https://docs.github.com/en/graphql/overview/explorer | Interactive GraphQL playground |
| **GitHub Actions** | https://github.com/features/actions | CI/CD automation |
| **GitHub Apps** | https://docs.github.com/en/developers/apps | Bot framework |

### Third-Party Analysis Services

| Service | Link | Pricing | Key Features |
|---------|------|---------|--------------|
| **Graphite Insights** | https://graphite.dev | Freemium | PR metrics, review times |
| **RepoBeats** | https://repobeats.axiom.co | Free | Contributor heatmaps |
| **CodeSee** | https://www.codesee.io | Freemium | Visual code mapping |
| **Gitpod** | https://www.gitpod.io | Freemium | Cloud dev environments |
| **Sourcegraph** | https://sourcegraph.com | Freemium | Universal code search |

### GitHub Profile Enhancement

| Tool | GitHub | Stars | Description |
|------|--------|-------|-------------|
| **GitHub Readme Stats** | https://github.com/anuraghazra/github-readme-stats | 150k+ | Dynamic stats cards |
| **GitHub Profile Trophy** | https://github.com/ryo-ma/github-profile-trophy | 4k+ | Achievement trophies |
| **GitHub Streak Stats** | https://github.com/DenverCoder1/github-readme-streak-stats | 4k+ | Commit streaks |
| **Activity Graph** | https://github.com/Ashutosh00710/github-readme-activity-graph | 1k+ | Contribution graphs |
| **Profile Views Counter** | https://github.com/antonkomarev/github-profile-views-counter | 400+ | View tracking |

---

## AI & LLM TOOLS

### LLM Providers

| Provider | API Docs | Pricing Page | Models |
|----------|----------|--------------|--------|
| **OpenAI** | https://platform.openai.com/docs | https://openai.com/pricing | GPT-4, GPT-4o, GPT-3.5 |
| **Anthropic (Claude)** | https://docs.anthropic.com | https://www.anthropic.com/pricing | Claude 4, Claude 3.5 Sonnet, Haiku |
| **Google Gemini** | https://ai.google.dev/docs | https://ai.google.dev/pricing | Gemini 1.5 Pro/Flash |
| **Cohere** | https://docs.cohere.com | https://cohere.com/pricing | Command, Embed |
| **Groq** | https://console.groq.com/docs | https://wow.groq.com/pricing | Llama 3, Mixtral (fast) |
| **Together AI** | https://docs.together.ai | https://www.together.ai/pricing | Open source models |

### LLM Frameworks

| Framework | Install | GitHub | Best For |
|-----------|---------|--------|----------|
| **LangChain** | `npm install langchain` | https://github.com/langchain-ai/langchainjs | Complex LLM workflows |
| **LlamaIndex** | `pip install llama-index` | https://github.com/run-llama/llama_index | RAG applications |
| **Haystack** | `pip install farm-haystack` | https://github.com/deepset-ai/haystack | NLP pipelines |
| **AutoGPT** | Clone repo | https://github.com/Significant-Gravitas/AutoGPT | Autonomous agents |
| **LangFlow** | `pip install langflow` | https://github.com/logspace-ai/langflow | Visual LLM builder |

### Local LLM Solutions

| Tool | Link | Description |
|------|------|-------------|
| **Ollama** | https://ollama.ai | Run Llama 3, Mistral locally |
| **LM Studio** | https://lmstudio.ai | GUI for local models |
| **LocalAI** | https://localai.io | OpenAI-compatible local API |
| **GPT4All** | https://gpt4all.io | Desktop app for local LLMs |
| **llama.cpp** | https://github.com/ggerganov/llama.cpp | C++ inference engine |

### Prompt Engineering Tools

| Tool | Link | Use Case |
|------|------|----------|
| **PromptLayer** | https://promptlayer.com | Prompt tracking & analytics |
| **LangSmith** | https://smith.langchain.com | LLM observability |
| **Helicone** | https://helicone.ai | LLM monitoring |
| **Portkey** | https://portkey.ai | LLM gateway & routing |
| **Prompt Flow** | https://github.com/microsoft/promptflow | Prompt engineering framework |

---

## CHANGELOG & RELEASE AUTOMATION

### AI-Powered Changelog Generators

| Tool | Link | Language | LLM Support |
|------|------|----------|-------------|
| **AI Changelog Generator** | https://github.com/entro314-labs/ai-changelog-generator | TypeScript | OpenAI, Claude, Ollama, Azure |
| **Changeish** | https://dev.to/itlackey/changeish-automate-your-changelog-with-ai | JavaScript | OpenAI, Ollama |
| **Release Drafter** | https://github.com/release-drafter/release-drafter | JavaScript | Template-based (no LLM) |
| **semantic-release** | https://github.com/semantic-release/semantic-release | JavaScript | Automated versioning |
| **GenAIScript (Microsoft)** | https://microsoft.github.io/genaiscript | TypeScript | Multiple LLMs |

### GitHub Actions for Releases

| Action | Marketplace Link | Features |
|--------|------------------|----------|
| **Release Drafter** | https://github.com/marketplace/actions/release-drafter | Auto-draft releases |
| **Semantic Release** | https://github.com/marketplace/actions/action-semantic-release | Automated versioning |
| **Create Release** | https://github.com/marketplace/actions/create-release | Simple release creation |
| **Auto Changelog** | https://github.com/marketplace/actions/auto-changelog | Generate CHANGELOG.md |
| **Conventional Changelog** | https://github.com/marketplace/actions/conventional-changelog-action | Conventional commits |

### Changelog Formats & Standards

| Standard | Link | Description |
|----------|------|-------------|
| **Keep a Changelog** | https://keepachangelog.com | Changelog format standard |
| **Semantic Versioning** | https://semver.org | Version numbering standard |
| **Conventional Commits** | https://www.conventionalcommits.org | Commit message standard |

---

## GITHUB BOTS & AUTOMATION

### Bot Frameworks

| Framework | Language | GitHub | Best For |
|-----------|----------|--------|----------|
| **Probot** | Node.js | https://github.com/probot/probot | GitHub Apps (official SDK) |
| **Octokit** | TypeScript | https://github.com/octokit/octokit.js | GitHub API interactions |
| **gidgethub** | Python | https://github.com/gidgethub/gidgethub | Python GitHub bots |
| **go-github** | Go | https://github.com/google/go-github | Go GitHub API client |
| **PyGithub** | Python | https://github.com/PyGithub/PyGithub | Python GitHub API client |

### Popular Probot Apps

| App | GitHub | Description |
|-----|--------|-------------|
| **Welcome Bot** | https://github.com/behaviorbot/welcome | Welcome new contributors |
| **Stale Bot** | https://github.com/probot/stale | Close stale issues/PRs |
| **WIP Bot** | https://github.com/wip/app | Block WIP pull requests |
| **Release Drafter** | https://github.com/release-drafter/release-drafter | Draft release notes |
| **Auto Assign** | https://github.com/kentaro-m/auto-assign-action | Auto-assign reviewers |
| **Label Sync** | https://github.com/Financial-Times/github-label-sync | Sync labels across repos |

### Google's Repo Automation Bots

| Bot | Description | Link |
|-----|-------------|------|
| **repo-automation-bots** | Collection by Google | https://github.com/googleapis/repo-automation-bots |
| **auto-label** | Auto-label PRs | Part of collection |
| **release-please** | Automated releases | https://github.com/googleapis/release-please |
| **conventional-commit-lint** | Enforce commit format | Part of collection |

---

## CONTENT GENERATION & AUTOMATION

### AI Writing Tools

| Tool | Link | Pricing | Best For |
|------|------|---------|----------|
| **Jasper** | https://www.jasper.ai | $49+/month | Marketing content |
| **Copy.ai** | https://www.copy.ai | Freemium | General copywriting |
| **Writesonic** | https://writesonic.com | Freemium | SEO content |
| **Frase** | https://www.frase.io | $15+/month | SEO research |
| **Rytr** | https://rytr.me | Freemium | Budget-friendly |
| **ContentBot** | https://contentbot.ai | $19+/month | Bulk content |
| **Spreadbot** | https://spreadbot.ai | Enterprise | Long-form automation |

### Developer Content Tools

| Tool | Link | Use Case |
|------|------|----------|
| **Carbon** | https://carbon.now.sh | Beautiful code screenshots |
| **Ray.so** | https://ray.so | Code snippet sharing |
| **Snappify** | https://snappify.com | Code presentations |
| **Chalk.ist** | https://chalk.ist | Code snippet images |
| **Codeimg.io** | https://codeimg.io | Code to image |

### Technical Writing Tools

| Tool | Link | Description |
|------|------|-------------|
| **Grammarly** | https://grammarly.com | Grammar & style checking |
| **Hemingway Editor** | https://hemingwayapp.com | Readability improvement |
| **Vale** | https://vale.sh | Prose linting |
| **Notion AI** | https://www.notion.so/product/ai | AI writing assistant |
| **GitHub Copilot** | https://github.com/features/copilot | Code & docs generation |

---

## WORKFLOW AUTOMATION

### No-Code/Low-Code Platforms

| Platform | Link | Pricing | GitHub Integration |
|----------|------|---------|-------------------|
| **n8n** | https://n8n.io | Open source / $20+ | Yes (native node) |
| **Zapier** | https://zapier.com | $20+/month | Yes (via integration) |
| **Make (Integromat)** | https://www.make.com | Freemium | Yes |
| **Pipedream** | https://pipedream.com | Freemium | Yes (code-first) |
| **Activepieces** | https://www.activepieces.com | Open source | Yes |
| **Temporal** | https://temporal.io | Open source / Cloud | Via webhooks |

### n8n Workflow Templates

| Template | Link | Description |
|----------|------|-------------|
| **Social Media Automation** | https://n8n.io/workflows/4637 | AI content for Instagram, Facebook, LinkedIn, X |
| **Social Content Generator** | https://n8n.io/workflows/3082 | Generate & publish to X, LinkedIn |
| **GitHub to Slack** | https://n8n.io/workflows/ | Webhook → Slack notifications |

### Webhook Tools

| Tool | Link | Use Case |
|------|------|----------|
| **Hookdeck** | https://hookdeck.com | Webhook infrastructure |
| **Svix** | https://www.svix.com | Webhook as a service |
| **webhook.site** | https://webhook.site | Testing webhooks |
| **RequestBin** | https://requestbin.com | Inspect HTTP requests |
| **ngrok** | https://ngrok.com | Local webhook testing |

---

## SOCIAL MEDIA AUTOMATION

### Multi-Platform Schedulers

| Tool | Link | Pricing | Features |
|------|------|---------|----------|
| **Buffer** | https://buffer.com | $6+/month | Simple scheduling |
| **Hootsuite** | https://www.hootsuite.com | $99+/month | Enterprise features |
| **Sprout Social** | https://sproutsocial.com | $249+/month | Advanced analytics |
| **Later** | https://later.com | Freemium | Visual planning |
| **SocialBee** | https://socialbee.com | $29+/month | Content categories |
| **Publer** | https://publer.io | Freemium | AI assistance |

### Developer-Focused Tools

| Tool | Link | Description |
|------|------|-------------|
| **Typefully** | https://typefully.com | Twitter threads |
| **Taplio** | https://taplio.com | LinkedIn automation |
| **Hypefury** | https://hypefury.com | Twitter growth |
| **Tweet Hunter** | https://tweethunter.io | Twitter content |

### Social Media APIs

| Platform | API Docs | Rate Limits |
|----------|----------|-------------|
| **Twitter/X** | https://developer.twitter.com/en/docs | 50 requests/15min (free) |
| **LinkedIn** | https://learn.microsoft.com/en-us/linkedin/marketing | Varies by endpoint |
| **Facebook/Instagram** | https://developers.facebook.com | 200 calls/hour |
| **Reddit** | https://www.reddit.com/dev/api | 60 requests/minute |
| **Dev.to** | https://developers.forem.com | Generous (no strict limit) |

---

## EMAIL & NEWSLETTER TOOLS

### Email Service Providers

| Service | Link | Free Tier | Best For |
|---------|------|-----------|----------|
| **Resend** | https://resend.com | 100/day | Transactional emails |
| **SendGrid** | https://sendgrid.com | 100/day | Reliable delivery |
| **Mailgun** | https://www.mailgun.com | 5000/month | Developer-friendly |
| **Postmark** | https://postmarkapp.com | 100/month | Transactional |
| **AWS SES** | https://aws.amazon.com/ses | 62000/month | Cost-effective at scale |
| **Loops** | https://loops.so | 2000/month | Simple API |

### Newsletter Platforms

| Platform | Link | Pricing | API | Automation |
|----------|------|---------|-----|------------|
| **Beehiiv** | https://www.beehiiv.com | Freemium | Yes | Yes (IFTTT-style) |
| **Substack** | https://substack.com | Free (10% fee) | No | Limited |
| **ConvertKit** | https://convertkit.com | Freemium | Yes | Advanced |
| **MailerLite** | https://www.mailerlite.com | Freemium | Yes | Good |
| **Buttondown** | https://buttondown.email | $9+/month | Yes | Simple |
| **Ghost** | https://ghost.org | $9+/month | Yes | Advanced |

### Email Template Builders

| Tool | Link | Use Case |
|------|------|----------|
| **React Email** | https://react.email | React components → HTML |
| **MJML** | https://mjml.io | Responsive email framework |
| **Maizzle** | https://maizzle.com | Tailwind CSS emails |
| **Foundation Emails** | https://get.foundation/emails | Responsive framework |

---

## MONITORING & ANALYTICS

### Application Monitoring

| Service | Link | Free Tier | Features |
|---------|------|-----------|----------|
| **Sentry** | https://sentry.io | 5k errors/month | Error tracking |
| **LogRocket** | https://logrocket.com | 1k sessions/month | Session replay |
| **Datadog** | https://www.datadoghq.com | 14-day trial | Full observability |
| **New Relic** | https://newrelic.com | 100 GB/month | APM & monitoring |
| **Grafana Cloud** | https://grafana.com | Generous | Dashboards & alerts |

### Analytics Platforms

| Platform | Link | Privacy-Focused | Self-Hostable |
|----------|------|----------------|---------------|
| **Plausible** | https://plausible.io | Yes | Yes |
| **PostHog** | https://posthog.com | Yes | Yes |
| **Umami** | https://umami.is | Yes | Yes |
| **Fathom** | https://usefathom.com | Yes | No |
| **Simple Analytics** | https://simpleanalytics.com | Yes | No |

### Log Aggregation

| Tool | Link | Type | Use Case |
|------|------|------|----------|
| **SigNoz** | https://signoz.io | Open source | All-in-one observability |
| **Grafana Loki** | https://grafana.com/oss/loki | Open source | Log aggregation |
| **Fluentd** | https://www.fluentd.org | Open source | Log collection |
| **Vector** | https://vector.dev | Open source | Data pipeline |

---

## DEVELOPMENT UTILITIES

### Authentication & Auth

| Service | Link | Free Tier | OAuth Providers |
|---------|------|-----------|-----------------|
| **Clerk** | https://clerk.com | 10k users | Many |
| **Auth0** | https://auth0.com | 7k users | Many |
| **Supabase Auth** | https://supabase.com/auth | 50k users | Many |
| **NextAuth.js** | https://next-auth.js.org | Open source | 50+ |
| **Lucia** | https://lucia-auth.com | Open source | DIY |

### Database & Storage

| Service | Link | Free Tier | Type |
|---------|------|-----------|------|
| **Supabase** | https://supabase.com | 500 MB | Postgres + Auth + Storage |
| **PlanetScale** | https://planetscale.com | 5 GB | MySQL |
| **Neon** | https://neon.tech | 3 GB | Serverless Postgres |
| **Turso** | https://turso.tech | 9 GB | SQLite at the edge |
| **Upstash** | https://upstash.com | 10k commands | Redis |

### Hosting & Deployment

| Platform | Link | Free Tier | Best For |
|----------|------|-----------|----------|
| **Vercel** | https://vercel.com | Generous | Next.js, React |
| **Netlify** | https://www.netlify.com | 100 GB bandwidth | Static sites, JAMstack |
| **Railway** | https://railway.app | $5 credit/month | Full-stack apps |
| **Fly.io** | https://fly.io | 3 VMs | Containerized apps |
| **Render** | https://render.com | 750 hours | Web services, DBs |

### Queue & Background Jobs

| Tool | Link | Type | Use Case |
|------|------|------|----------|
| **BullMQ** | https://docs.bullmq.io | Library | Node.js queues |
| **Inngest** | https://www.inngest.com | Service | Durable workflows |
| **Trigger.dev** | https://trigger.dev | Service | Background jobs |
| **Quirrel** | https://quirrel.dev | Service | Job scheduling |

---

## LEARNING RESOURCES

### Documentation Sites

| Resource | Link | Description |
|----------|------|-------------|
| **GitHub Docs** | https://docs.github.com | Official GitHub documentation |
| **MDN Web Docs** | https://developer.mozilla.org | Web development reference |
| **LangChain Docs** | https://python.langchain.com/docs | LangChain documentation |
| **Vercel Docs** | https://vercel.com/docs | Next.js & deployment |

### Tutorial Repositories

| Repo | Link | Topic |
|------|------|-------|
| **GitHub Bot Tutorial** | https://github-bot-tutorial.readthedocs.io | Building GitHub bots |
| **LangChain Tutorials** | https://github.com/gkamradt/langchain-tutorials | LangChain examples |
| **Awesome Probot** | https://github.com/probot/awesome-probot | Probot resources |
| **Awesome GitHub Actions** | https://github.com/sdras/awesome-actions | GitHub Actions collection |

### Communities

| Community | Link | Platform |
|-----------|------|----------|
| **r/webdev** | https://reddit.com/r/webdev | Reddit |
| **r/SideProject** | https://reddit.com/r/SideProject | Reddit |
| **Dev.to** | https://dev.to | Community |
| **Indie Hackers** | https://www.indiehackers.com | Community |
| **Product Hunt** | https://www.producthunt.com | Launch platform |

---

## PRICING COMPARISON (Monthly Estimates)

### Starter Stack (0-100 users)
```
Vercel (Hobby)         $0
Supabase (Free)        $0
Resend (Free)          $0
Claude API            ~$10
GitHub Pro (optional)  $4
--------------------------
Total:           $10-14/month
```

### Growth Stack (100-1000 users)
```
Vercel (Pro)          $20
Supabase (Pro)        $25
Resend (Pro)          $20
Claude API           ~$100
Sentry (Team)         $26
Plausible             $9
--------------------------
Total:          $200/month
```

### Scale Stack (1000+ users)
```
Vercel (Enterprise)  $150+
Supabase (Team)       $599
Resend (Business)     $80
Claude API          ~$500
Datadog               $15/host
Stripe (payments)     2.9% + $0.30
--------------------------
Total:     $1500+/month
```

---

## QUICK COMMAND REFERENCE

### GitHub CLI Commands
```bash
# List repositories
gh repo list

# Clone with SSH
gh repo clone owner/repo

# Create pull request
gh pr create --title "Title" --body "Description"

# View workflow runs
gh run list

# Create release
gh release create v1.0.0 --notes "Release notes"
```

### Octokit Quick Start
```javascript
import { Octokit } from "octokit";

const octokit = new Octokit({ auth: "TOKEN" });

// List commits
const { data } = await octokit.rest.repos.listCommits({
  owner: "owner",
  repo: "repo"
});

// Create issue
await octokit.rest.issues.create({
  owner: "owner",
  repo: "repo",
  title: "Bug",
  body: "Description"
});
```

### Claude API Quick Start
```javascript
import Anthropic from "@anthropic-ai/sdk";

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY
});

const message = await anthropic.messages.create({
  model: "claude-sonnet-4-20250514",
  max_tokens: 1024,
  messages: [
    { role: "user", content: "Hello, Claude!" }
  ]
});

console.log(message.content[0].text);
```

### n8n Webhook Trigger
```javascript
// In n8n workflow, use Webhook node
// Webhook URL: https://your-n8n.com/webhook/github

// In GitHub repo settings:
// Webhooks → Add webhook
// Payload URL: [n8n webhook URL]
// Content type: application/json
// Events: Choose events to trigger
```

---

**Last Updated:** 2025-11-12
**Maintained By:** Research Team
**File Location:** /home/beengud/raibid-labs/sparky/TOOLS_AND_LIBRARIES.md

