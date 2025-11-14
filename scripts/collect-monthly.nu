#!/usr/bin/env nu
# Sparky Monthly Data Collection (Nushell)
# Zero cost - uses GitHub CLI

def main [] {
    let date = (date now | format date "%Y-%m-%d")
    let month = (date now | format date "%Y-%m")
    let output_dir = "data/raw"

    mkdir $output_dir

    print "🚀 Sparky Monthly Data Collection"
    print $"Month: ($month) \(($date))"
    print "Using GitHub CLI (free, no API limits)"
    print ""

    # Get all raibid-labs repositories
    print "📦 Discovering repositories..."
    let repos = (gh repo list raibid-labs --limit 100 --json name,description,updatedAt,pushedAt,stargazerCount,forkCount | from json)
    let repo_count = ($repos | length)
    print $"   Found ($repo_count) repositories"

    # Save repos
    $repos | to json | save -f $"($output_dir)/($month)-repos.json"

    # Filter repos updated in last 60 days
    let cutoff = ((date now) - 60day)
    let active_repos = ($repos | where {|repo|
        ($repo.pushedAt | into datetime) > $cutoff
    })
    let active_count = ($active_repos | length)
    print $"   ($active_count) active in last 60 days"

    # Collect commits from active repos (last 30 days)
    print ""
    print "📝 Collecting commits (last 30 days)..."

    let commit_cutoff = (date now) - 30day
    let commit_cutoff_iso = ($commit_cutoff | format date "%Y-%m-%dT%H:%M:%SZ")

    let commits = ($active_repos | each {|repo|
        print $"   Processing: ($repo.name)"

        # Get commits from last 30 days
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
    $commits | to json | save -f $"($output_dir)/($month)-commits.json"

    # Collect merged PRs (last 30 days)
    print ""
    print "🔀 Collecting merged pull requests..."

    let prs = ($active_repos | each {|repo|
        print $"   Processing: ($repo.name)"

        try {
            (gh pr list --repo $"raibid-labs/($repo.name)" --state merged --limit 100 --json number,title,author,mergedAt,mergedBy,url,additions,deletions
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
    $prs | to json | save -f $"($output_dir)/($month)-prs.json"

    # Collect issues (last 30 days)
    print ""
    print "📋 Collecting issue activity..."

    let issues = ($active_repos | each {|repo|
        print $"   Processing: ($repo.name)"

        try {
            (gh issue list --repo $"raibid-labs/($repo.name)" --limit 100 --json number,title,author,createdAt,updatedAt,url,state,labels
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
    $issues | to json | save -f $"($output_dir)/($month)-issues.json"

    # Collect releases (last 30 days)
    print ""
    print "🎉 Collecting releases..."

    let releases = ($active_repos | each {|repo|
        print $"   Processing: ($repo.name)"

        try {
            (gh release list --repo $"raibid-labs/($repo.name)" --limit 20 --json tagName,name,publishedAt,author,url
                | from json)
                | each {|release|
                    let published_date = ($release.publishedAt | into datetime)
                    if $published_date > $commit_cutoff {
                        $release | merge {repo: $repo.name}
                    }
                }
                | where {|r| $r != null}
        } catch {
            []
        }
    } | flatten)

    let release_count = ($releases | length)
    print $"   Collected ($release_count) releases"

    # Save releases
    $releases | to json | save -f $"($output_dir)/($month)-releases.json"

    # Calculate comprehensive statistics
    print ""
    print "📊 Calculating statistics..."

    # Top contributors
    let top_contributors = ($commits
        | group-by author
        | transpose name commits
        | each {|g| {name: $g.name, commits: ($g.commits | length)}}
        | sort-by commits --reverse
        | first 15
    )

    # Active repos
    let active_repos_list = ($commits | get repo | uniq | sort)

    # Commits per day
    let commits_per_day = ($commits
        | each {|c| {date: ($c.date | into datetime | format date "%Y-%m-%d")}}
        | group-by date
        | transpose date commits
        | each {|g| {date: $g.date, commits: ($g.commits | length)}}
        | sort-by date
    )

    # Commits per week
    let commits_per_week = ($commits
        | each {|c| {week: ($c.date | into datetime | format date "%Y-W%V")}}
        | group-by week
        | transpose week commits
        | each {|g| {week: $g.week, commits: ($g.commits | length)}}
        | sort-by week
    )

    # Total lines changed
    let total_additions = ($prs | get additions | math sum)
    let total_deletions = ($prs | get deletions | math sum)

    # Repository stats
    let repo_stats = ($repos | each {|r| {
        name: $r.name
        stars: $r.stargazerCount
        forks: $r.forkCount
    }})

    # Create summary
    let summary = {
        month: $month
        date_range_end: $date
        commits: $commit_count
        pull_requests: $pr_count
        issues: $issue_count
        releases: $release_count
        active_repositories: ($active_repos_list | length)
        contributors: ($commits | get author | uniq | length)
        total_additions: $total_additions
        total_deletions: $total_deletions
        top_contributors: $top_contributors
        active_repos: $active_repos_list
        commits_per_day: $commits_per_day
        commits_per_week: $commits_per_week
        repository_stats: $repo_stats
    }

    # Save summary
    $summary | to json | save -f $"($output_dir)/($month)-summary.json"

    # Display summary
    print ""
    print "✅ Monthly Collection Complete!"
    print ""
    print "Summary:"
    $summary | to json
    print ""
    print "Data files created:"
    print $"  - ($output_dir)/($month)-repos.json"
    print $"  - ($output_dir)/($month)-commits.json"
    print $"  - ($output_dir)/($month)-prs.json"
    print $"  - ($output_dir)/($month)-issues.json"
    print $"  - ($output_dir)/($month)-releases.json"
    print $"  - ($output_dir)/($month)-summary.json"
    print ""
    print "💰 Cost: $0 (GitHub CLI is free!)"
}
