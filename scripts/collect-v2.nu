#!/usr/bin/env nu
# Sparky Data Collection (Refactored)
# Uses shared CLI/config/runtime patterns

use lib/cli.nu *
use lib/config.nu *
use lib/runtime.nu *

def main [
    --mode: string = "daily",        # Collection mode: daily, weekly, monthly
    --date: string,                  # Specific date (YYYY-MM-DD)
    --config: string,                # Config file path
    --verbose (-v): bool = false,    # Verbose output
    --quiet (-q): bool = false       # Quiet mode
] {
    # Initialize runtime
    let ctx = (init-runtime "sparky-collect" --config-file $config --verbose=$verbose --quiet=$quiet)

    print-header "Sparky Data Collection" $ctx.config.version

    # Check dependencies
    check-runtime-deps ["gh"]

    # Ensure directories exist
    ensure-runtime-dirs $ctx.config

    # Determine collection date
    let collection_date = if ($date | is-empty) {
        date now | format date "%Y-%m-%d"
    } else {
        $date
    }

    log-info $"Collection mode: ($mode)"
    log-info $"Collection date: ($collection_date)"

    # Get lookback period
    let lookback_days = ($ctx.config.collection.lookback_days | get $mode)
    let cutoff = (date now) - ($lookback_days * 1day)

    # Execute collection pipeline
    let repos = (safe-execute $ctx "Discover repositories" {
        discover-repositories $ctx.config
    })

    let active_repos = ($repos | where {|repo|
        ($repo.pushedAt | into datetime) > $cutoff
    })

    log-info $"Found ($repos | length) repositories, ($active_repos | length) active"

    let commits = (safe-execute $ctx "Collect commits" {
        collect-commits $active_repos $cutoff $ctx.config
    })

    let prs = (safe-execute $ctx "Collect pull requests" {
        collect-prs $active_repos $cutoff $ctx.config
    })

    let issues = (safe-execute $ctx "Collect issues" {
        collect-issues $active_repos $cutoff $ctx.config
    })

    # Calculate summary
    let summary = {
        date: $collection_date,
        mode: $mode,
        commits: ($commits | length),
        pull_requests: ($prs | length),
        issues: ($issues | length),
        active_repositories: ($active_repos | length),
        contributors: ($commits | get author | uniq | length)
    }

    # Save results
    let output_dir = $ctx.config.paths.data_raw
    safe-write $"($output_dir)/($collection_date)-repos.json" ($repos | to json)
    safe-write $"($output_dir)/($collection_date)-commits.json" ($commits | to json)
    safe-write $"($output_dir)/($collection_date)-prs.json" ($prs | to json)
    safe-write $"($output_dir)/($collection_date)-issues.json" ($issues | to json)
    safe-write $"($output_dir)/($collection_date)-summary.json" ($summary | to json)

    # Display summary
    print ""
    print "Summary:"
    print ($summary | to json)

    # Shutdown
    shutdown $ctx --success
}

def discover-repositories [config: record] {
    let org_name = $config.collection.org_name
    let max_repos = $config.collection.max_repos

    log-debug $"Discovering repositories for ($org_name)"

    gh repo list $org_name --limit $max_repos --json name,description,updatedAt,pushedAt
    | from json
}

def collect-commits [repos: list, cutoff: datetime, config: record] {
    $repos | each {|repo|
        log-debug $"Collecting commits from ($repo.name)"

        try {
            gh api $"repos/($config.collection.org_name)/($repo.name)/commits"
            | from json
            | each {|commit|
                let commit_date = ($commit.commit.author.date | into datetime)
                if $commit_date > $cutoff {
                    {
                        repo: $repo.name,
                        sha: $commit.sha,
                        author: $commit.commit.author.name,
                        email: $commit.commit.author.email,
                        date: $commit.commit.author.date,
                        message: $commit.commit.message
                    }
                }
            }
            | where {|c| $c != null}
        } catch {
            []
        }
    } | flatten
}

def collect-prs [repos: list, cutoff: datetime, config: record] {
    let max_prs = $config.collection.max_prs_per_repo
    let org_name = $config.collection.org_name

    $repos | each {|repo|
        log-debug $"Collecting PRs from ($repo.name)"

        try {
            gh pr list --repo $"($org_name)/($repo.name)" --state merged --limit $max_prs --json number,title,author,mergedAt,url
            | from json
            | each {|pr|
                let merged_date = ($pr.mergedAt | into datetime)
                if $merged_date > $cutoff {
                    $pr | merge {repo: $repo.name}
                }
            }
            | where {|p| $p != null}
        } catch {
            []
        }
    } | flatten
}

def collect-issues [repos: list, cutoff: datetime, config: record] {
    let max_issues = $config.collection.max_issues_per_repo
    let org_name = $config.collection.org_name

    $repos | each {|repo|
        log-debug $"Collecting issues from ($repo.name)"

        try {
            gh issue list --repo $"($org_name)/($repo.name)" --limit $max_issues --json number,title,author,createdAt,updatedAt,state,url
            | from json
            | each {|issue|
                let updated_date = ($issue.updatedAt | into datetime)
                if $updated_date > $cutoff {
                    $issue | merge {repo: $repo.name}
                }
            }
            | where {|i| $i != null}
        } catch {
            []
        }
    } | flatten
}
