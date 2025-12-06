#!/usr/bin/env nu
# Setup branch protection for main branch
# This script helps configure GitHub branch protection rules

def main [] {
    print "🔒 Branch Protection Setup for Sparky"
    print "======================================"
    print ""

    # Check if gh CLI is available
    if (which gh | is-empty) {
        print "❌ GitHub CLI (gh) not found. Please install it first."
        exit 1
    }

    print "This script will help you set up branch protection for the main branch."
    print ""
    print "Branch protection rules to be configured:"
    print "  ✓ Require pull request reviews before merging"
    print "  ✓ Require status checks to pass:"
    print "    - CI workflow"
    print "    - Documentation check"
    print "    - Phage policy check"
    print "  ✓ Require branches to be up to date before merging"
    print "  ✓ Enforce on administrators (optional)"
    print "  ✓ Require signed commits (optional)"
    print ""

    let repo = "raibid-labs/sparky"
    let branch = "main"

    print $"Setting up protection for ($repo):($branch)..."
    print ""

    # Check current protection status
    print "Checking current branch protection..."
    let current_protection = (
        gh api repos/($repo)/branches/($branch)/protection 2>/dev/null
        | from json
    )

    if ($current_protection | is-not-empty) {
        print "⚠️  Branch protection already exists. This will update it."
    } else {
        print "📝 No existing branch protection found. Creating new rules..."
    }

    print ""
    print "Run the following gh command to enable branch protection:"
    print ""
    print "───────────────────────────────────────────────────────────────"
    print $"gh api -X PUT repos/($repo)/branches/($branch)/protection \\"
    print "  -f required_status_checks[strict]=true \\"
    print "  -f 'required_status_checks[contexts][]=CI' \\"
    print "  -f 'required_status_checks[contexts][]=Documentation Check' \\"
    print "  -f 'required_status_checks[contexts][]=Phage Policy Check' \\"
    print "  -f required_pull_request_reviews[require_code_owner_reviews]=true \\"
    print "  -f required_pull_request_reviews[required_approving_review_count]=1 \\"
    print "  -f enforce_admins=true \\"
    print "  -f required_linear_history=true \\"
    print "  -f allow_force_pushes=false \\"
    print "  -f allow_deletions=false"
    print "───────────────────────────────────────────────────────────────"
    print ""

    print "Optional: Enable signed commits"
    print "───────────────────────────────────────────────────────────────"
    print $"gh api -X PUT repos/($repo)/branches/($branch)/protection \\"
    print "  -f required_signatures=true"
    print "───────────────────────────────────────────────────────────────"
    print ""

    print "Notes:"
    print "  • You must have admin access to the repository"
    print "  • Status check names must match your workflow job names"
    print "  • Review the settings at: https://github.com/($repo)/settings/branches"
    print ""

    print "Verify protection is enabled:"
    print $"  gh api repos/($repo)/branches/($branch)/protection | from json"
    print ""
}
