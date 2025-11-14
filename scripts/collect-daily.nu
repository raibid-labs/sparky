#!/usr/bin/env nu
# Sparky Daily Data Collection (Nushell)
# Zero cost - uses GitHub CLI

def main [] {
    let date = (date now | format date "%Y-%m-%d")
    let output_dir = "data/raw"

    mkdir $output_dir

    print "🚀 Sparky Daily Data Collection"
    print $"Date: ($date)"
    print "Using GitHub CLI (free, no API limits)"
    print ""

    # Get all raibid-labs repositories
    print "📦 Discovering repositories..."
    let repos = (gh repo list raibid-labs --limit 100 --json name,description,updatedAt,pushedAt | from json)
    let repo_count = ($repos | length)
    print $"   Found ($repo_count) repositories"

    # Save repos
    $repos | to json | save -f $"($output_dir)/($date)-repos.json"

    # Filter repos updated in last 7 days
    let cutoff = ((date now) - 7day)
    let active_repos = ($repos | where {|repo|
        ($repo.pushedAt | into datetime) > $cutoff
    })
    let active_count = ($active_repos | length)
    print $"   ($active_count) active in last 7 days"

    # Collect commits from active repos (last 24 hours)
    print ""
    print "📝 Collecting commits (last 24 hours)..."

    let commit_cutoff = (date now) - 1day
    let commit_cutoff_iso = ($commit_cutoff | format date "%Y-%m-%dT%H:%M:%SZ")

    let commits = ($active_repos | each {|repo|
        print $"   Processing: ($repo.name)"

        # Get commits from last 24 hours
        try {
            gh api $"repos/raibid-labs/($repo.name)/commits"
                | from json
                | each {|commit|
                    let commit_date = ($commit.commit.author.date | into datetime)
                    if $commit_date > $commit_cutoff {
                        {
                            repo: $repo.name
                            sha: $commit.sha
                            author: $commit.commit.author.name
                            email: $commit.commit.author.email
                            date: $commit.commit.author.date
                            message: $commit.commit.message
                        }
                    }
                }
                | where {|c| $c != null}
        } catch {
            []
        }
    } | flatten)

    let commit_count = ($commits | length)
    print $"   Collected ($commit_count) commits"

    # Save commits
    $commits | to json | save -f $"($output_dir)/($date)-commits.json"

    # Collect merged PRs (last 24 hours)
    print ""
    print "🔀 Collecting merged pull requests..."

    let prs = ($active_repos | each {|repo|
        print $"   Processing: ($repo.name)"

        try {
            (gh pr list --repo $"raibid-labs/($repo.name)" --state merged --limit 50 --json number,title,author,mergedAt,mergedBy,url
                | from json)
                | each {|pr|
                    let merged_date = ($pr.mergedAt | into datetime)
                    if $merged_date > $commit_cutoff {
                        $pr | merge {repo: $repo.name}
                    }
                }
                | where {|p| $p != null}
        } catch {
            []
        }
    } | flatten)

    let pr_count = ($prs | length)
    print $"   Collected ($pr_count) merged PRs"

    # Save PRs
    $prs | to json | save -f $"($output_dir)/($date)-prs.json"

    # Collect issues (last 24 hours)
    print ""
    print "📋 Collecting issue activity..."

    let issues = ($active_repos | each {|repo|
        print $"   Processing: ($repo.name)"

        try {
            (gh issue list --repo $"raibid-labs/($repo.name)" --limit 50 --json number,title,author,createdAt,updatedAt,url,state
                | from json)
                | each {|issue|
                    let updated_date = ($issue.updatedAt | into datetime)
                    if $updated_date > $commit_cutoff {
                        $issue | merge {repo: $repo.name}
                    }
                }
                | where {|i| $i != null}
        } catch {
            []
        }
    } | flatten)

    let issue_count = ($issues | length)
    print $"   Collected ($issue_count) issue activities"

    # Save issues
    $issues | to json | save -f $"($output_dir)/($date)-issues.json"

    # Calculate statistics
    print ""
    print "📊 Calculating statistics..."

    # Top contributors
    let top_contributors = ($commits
        | group-by author
        | transpose name commits
        | each {|g| {name: $g.name, commits: ($g.commits | length)}}
        | sort-by commits --reverse
        | first 5
    )

    # Active repos
    let active_repos_list = ($commits | get repo | uniq | sort)

    # Create summary
    let summary = {
        date: $date
        commits: $commit_count
        pull_requests: $pr_count
        issues: $issue_count
        active_repositories: ($active_repos_list | length)
        contributors: ($commits | get author | uniq | length)
        top_contributors: $top_contributors
        active_repos: $active_repos_list
    }

    # Save summary
    $summary | to json | save -f $"($output_dir)/($date)-summary.json"

    # Display summary
    print ""
    print "✅ Daily Collection Complete!"
    print ""
    print "Summary:"
    $summary | to json
    print ""
    print "Data files created:"
    print $"  - ($output_dir)/($date)-repos.json"
    print $"  - ($output_dir)/($date)-commits.json"
    print $"  - ($output_dir)/($date)-prs.json"
    print $"  - ($output_dir)/($date)-issues.json"
    print $"  - ($output_dir)/($date)-summary.json"
    print ""
    print "💰 Cost: $0 (GitHub CLI is free!)"
}
