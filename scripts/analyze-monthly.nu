#!/usr/bin/env nu
# Sparky Monthly Analysis (Nushell + Ollama)
# Zero cost - local LLM

def main [] {
    let month = (date now | format date "%Y-%m")
    let date = (date now | format date "%Y-%m-%d")
    let month_name = (date now | format date "%B %Y")
    let data_dir = "data/raw"
    let output_dir = "output/monthly"

    print "🤖 Sparky Monthly Analysis with Ollama"
    print $"📅 Month: ($month_name) \(($month))"
    print "🧠 Model: llama3.2 (local, free, better for prose)"
    print ""

    # Check if ollama is installed
    if (which ollama | is-empty) {
        print "❌ Ollama not found!"
        print ""
        print "Install Ollama with:"
        print "  just install-ollama"
        print ""
        print "Or manually:"
        print "  curl -fsSL https://ollama.com/install.sh | sh"
        print "  ollama pull llama3.2"
        exit 1
    }

    # Check if data exists
    let summary_file = $"($data_dir)/($month)-summary.json"
    if not ($summary_file | path exists) {
        print $"❌ No data found for ($month)"
        print "   Run: nu scripts/collect-monthly.nu"
        exit 1
    }

    # Load data
    print "📂 Loading monthly data..."
    let summary = (open $summary_file)
    let commits = (open $"($data_dir)/($month)-commits.json")
    let prs = (open $"($data_dir)/($month)-prs.json")
    let issues = (open $"($data_dir)/($month)-issues.json")
    let releases = if ($"($data_dir)/($month)-releases.json" | path exists) {
        open $"($data_dir)/($month)-releases.json"
    } else {
        []
    }

    print $"   ✅ Loaded: ($summary.commits) commits, ($summary.pull_requests) PRs, ($summary.issues) issues"
    if ($releases | length) > 0 {
        print $"              ($releases | length) releases"
    }

    # Sample data to keep prompt reasonable but comprehensive
    let sample_commits = ($commits | first 100)
    let sample_prs = ($prs | first 30)
    let sample_issues = ($issues | first 25)

    # Create analysis prompt
    print "📝 Creating monthly analysis prompt..."

    let prompt = $"You are a technical writer for raibid-labs, an open-source organization.
Analyze this month's development activity and create a comprehensive monthly review.

## Summary Statistics
- Month: ($summary.month)
- Total commits: ($summary.commits)
- Pull requests merged: ($summary.pull_requests)
- Issues activity: ($summary.issues)
- Releases published: ($summary.releases)
- Active repositories: ($summary.active_repositories)
- Active contributors: ($summary.contributors)
- Total additions: ($summary.total_additions) lines
- Total deletions: ($summary.total_deletions) lines

## Weekly Commit Trends
($summary.commits_per_week | to json)

## Daily Commit Activity
($summary.commits_per_day | first 31 | to json)

## Top Contributors
($summary.top_contributors | to json)

## Repository Statistics
($summary.repository_stats | first 20 | to json)

## Active Repositories
($summary.active_repos | to json)

## Sample Commits \(showing ($sample_commits | length) of ($commits | length))
($sample_commits | to json)

## Merged Pull Requests \(showing ($sample_prs | length) of ($prs | length))
($sample_prs | to json)

## Issue Activity \(showing ($sample_issues | length) of ($issues | length))
($sample_issues | to json)

## Releases
(if ($releases | length) > 0 { ($releases | to json) } else { "No releases this month" })

## Your Task
Create an in-depth monthly review with these sections:

1. **Executive Summary**: 3-4 paragraphs providing a high-level overview of the month
   - Overall theme and major milestones
   - Key metrics and how they compare to expectations
   - Biggest wins and challenges

2. **Development Highlights**: Major achievements and deliverables
   - New features and capabilities launched
   - Significant refactorings or infrastructure improvements
   - Notable bug fixes or performance improvements

3. **Repository Spotlight**: Deep dive into 3-5 most active repositories
   - What changed and why
   - Impact on the project
   - Key contributors

4. **Community & Collaboration**:
   - Contributor highlights with specific examples
   - New contributors welcomed
   - Cross-repo collaboration examples
   - Team dynamics and patterns

5. **Technical Insights**:
   - Interesting technical challenges solved
   - Architectural decisions made
   - Tech debt addressed
   - Code quality improvements

6. **Releases & Milestones**:
   - Version releases and what they included
   - Beta features promoted to stable
   - Deprecations or breaking changes

7. **Metrics & Trends**:
   - Commit velocity trends \(weekly breakdown)
   - PR merge rate and review times
   - Issue closure rate
   - Code churn \(additions/deletions)
   - Compare to previous periods if patterns emerge

8. **Challenges & Learnings**:
   - Obstacles encountered
   - How they were overcome
   - Lessons learned

9. **Looking Forward**:
   - Momentum carrying into next month
   - Upcoming features in progress
   - Areas needing attention

Style Guidelines:
- Professional, polished tone suitable for stakeholders
- 2000-3000 words total
- Use emojis sparingly for section breaks \(🚀, 🔥, ✨, 📊, 🎯, 🏆, 💡)
- Be highly specific: mention repo names, PR numbers, contributor names, line numbers
- Tell a cohesive narrative about the month's journey
- Balance celebration with honest assessment
- Include concrete metrics and data throughout
- Use subheadings within major sections
- Highlight both individual and team accomplishments

Format: Markdown with clear headings, subheadings, and formatting"

    # Run Ollama
    print "🧠 Running Ollama (this may take 60-120 seconds for comprehensive monthly review)..."
    print "   Note: Larger prompts take longer but produce better analysis"

    let analysis_raw = (echo $prompt | ollama run llama3.2)

    # Post-process: Convert repository references to proper markdown links
    print "🔗 Adding repository links..."
    mut analysis = $analysis_raw
    for repo in $summary.active_repos {
        # Replace [repo-name] with [repo-name](https://github.com/raibid-labs/repo-name)
        # But only if not already a link (not followed by parenthesis)
        let pattern = $'\[($repo)\](?!\()'
        let url = $'https://github.com/raibid-labs/($repo)'
        let replacement = $'[($repo)]' + '(' + $url + ')'
        $analysis = ($analysis | str replace --all --regex $pattern $replacement)
    }

    # Create output directory
    mkdir $output_dir

    # Generate report with appendix
    let output_file = $"($output_dir)/($month).md"

    let report = $"# raibid-labs Monthly Review - ($month_name)

*Month ending ($date)*

---

($analysis)

---

## Appendix: Key Metrics

- **Total Commits**: ($summary.commits)
- **Pull Requests Merged**: ($summary.pull_requests)
- **Issues Addressed**: ($summary.issues)
- **Releases Published**: ($summary.releases)
- **Active Repositories**: ($summary.active_repositories)
- **Contributors**: ($summary.contributors)
- **Lines Added**: ($summary.total_additions)
- **Lines Removed**: ($summary.total_deletions)
- **Net Change**: ($summary.total_additions - $summary.total_deletions) lines

---

*Generated by Sparky | Powered by Ollama \(llama3.2) | Zero cost*
"

    $report | save -f $output_file

    print ""
    print "✅ Monthly analysis complete!"
    print $"   Saved to: ($output_file)"
    print ""
    print "Preview:"
    print "=" * 80
    let lines = ($report | lines)
    let preview_lines = if ($lines | length) > 60 { 60 } else { ($lines | length) }
    $lines | first $preview_lines | each {|line| print $line}
    if ($lines | length) > 60 {
        print "..."
        print $"[($lines | length | $in - 60) more lines]"
    }
    print "=" * 80
    print ""
    print "💰 Cost: $0 (local Ollama)"
    print ""
    print "📊 Monthly Statistics:"
    print $"   - ($summary.commits) commits across ($summary.active_repositories) repositories"
    print $"   - ($summary.contributors) active contributors"
    print $"   - ($summary.pull_requests) PRs merged"
    print $"   - ($summary.releases) releases published"
    print $"   - ($summary.total_additions) lines added, ($summary.total_deletions) removed"
}
