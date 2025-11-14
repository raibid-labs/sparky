#!/usr/bin/env nu
# Sparky Unified Pipeline (Nushell)
# Runs the full data collection → analysis → generation pipeline
# Supports: daily, weekly, monthly modes

def main [mode: string = "daily"] {
    match $mode {
        "daily" => {
            print "🚀 Running Daily Pipeline"
            print "=========================="
            print ""

            print "Step 1/2: Collecting daily data..."
            nu scripts/collect-daily.nu
            print ""

            print "Step 2/2: Generating daily digest..."
            nu scripts/analyze-daily.nu
            print ""

            let date = (date now | format date "%Y-%m-%d")
            print "✅ Daily pipeline complete!"
            print $"   Output: output/daily/($date).md"
        }

        "weekly" => {
            print "🚀 Running Weekly Pipeline"
            print "==========================="
            print ""

            print "Step 1/2: Collecting weekly data..."
            nu scripts/collect-weekly.nu
            print ""

            print "Step 2/2: Generating weekly report..."
            nu scripts/analyze-weekly.nu
            print ""

            let week = (date now | format date "%Y-W%V")
            print "✅ Weekly pipeline complete!"
            print $"   Output: output/weekly/($week).md"
        }

        "monthly" => {
            print "🚀 Running Monthly Pipeline"
            print "============================"
            print ""

            print "Step 1/2: Collecting monthly data..."
            nu scripts/collect-monthly.nu
            print ""

            print "Step 2/2: Generating monthly review..."
            nu scripts/analyze-monthly.nu
            print ""

            let month = (date now | format date "%Y-%m")
            print "✅ Monthly pipeline complete!"
            print $"   Output: output/monthly/($month).md"
        }

        _ => {
            print $"❌ Invalid mode: ($mode)"
            print ""
            print "Usage: nu scripts/pipeline.nu [daily|weekly|monthly]"
            print ""
            print "Examples:"
            print "  nu scripts/pipeline.nu daily    # Run daily digest (default)"
            print "  nu scripts/pipeline.nu weekly   # Run weekly report"
            print "  nu scripts/pipeline.nu monthly  # Run monthly review"
            exit 1
        }
    }

    print ""
    print "💰 Total cost: $0 (100% free!)"
}
