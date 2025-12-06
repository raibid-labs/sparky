#!/usr/bin/env nu
# Shared CLI utilities for Sparky
# Provides standardized argument parsing, logging, and runtime setup

# Initialize CLI with standard logging and configuration
export def init [
    script_name: string,
    --verbose (-v): bool = false,
    --quiet (-q): bool = false
] {
    let log_level = if $verbose {
        "debug"
    } else if $quiet {
        "error"
    } else {
        "info"
    }

    {
        script_name: $script_name,
        log_level: $log_level,
        start_time: (date now)
    }
}

# Log message with timestamp and level
export def log [
    level: string,
    message: string,
    context?: record
] {
    let timestamp = (date now | format date "%Y-%m-%d %H:%M:%S")
    let prefix = match $level {
        "debug" => "🔍",
        "info" => "ℹ️ ",
        "warn" => "⚠️ ",
        "error" => "❌",
        "success" => "✅",
        _ => "  "
    }

    print $"($prefix) [($timestamp)] ($level | str upcase): ($message)"

    if ($context != null) {
        print $"   Context: ($context)"
    }
}

# Log info message
export def log-info [message: string] {
    log "info" $message
}

# Log debug message
export def log-debug [message: string] {
    log "debug" $message
}

# Log warning message
export def log-warn [message: string] {
    log "warn" $message
}

# Log error message
export def log-error [message: string, context?: record] {
    log "error" $message $context
}

# Log success message
export def log-success [message: string] {
    log "success" $message
}

# Validate required dependencies are installed
export def check-deps [deps: list<string>] {
    mut missing = []

    for dep in $deps {
        if (which $dep | is-empty) {
            $missing = ($missing | append $dep)
        }
    }

    if ($missing | length) > 0 {
        log-error $"Missing required dependencies: ($missing | str join ', ')"
        print ""
        print "Install missing dependencies:"
        for dep in $missing {
            match $dep {
                "gh" => {
                    print "  GitHub CLI: https://cli.github.com/"
                    print "    brew install gh     # macOS"
                    print "    apt install gh      # Ubuntu/Debian"
                },
                "ollama" => {
                    print "  Ollama: https://ollama.com/"
                    print "    curl -fsSL https://ollama.com/install.sh | sh"
                },
                "docker" => {
                    print "  Docker: https://docs.docker.com/get-docker/"
                },
                "kubectl" => {
                    print "  kubectl: https://kubernetes.io/docs/tasks/tools/"
                },
                _ => {
                    print $"  ($dep): Please install manually"
                }
            }
        }
        exit 1
    }

    log-success "All dependencies available"
}

# Parse common CLI options
export def parse-common-opts [args: record] {
    {
        verbose: ($args.verbose? | default false),
        quiet: ($args.quiet? | default false),
        dry_run: ($args.dry_run? | default false),
        config: ($args.config? | default "config/default.toml")
    }
}

# Display script header
export def print-header [title: string, version?: string] {
    let header_width = 60
    let border = ("=" | str repeat $header_width)

    print $border
    print $"  ($title)"
    if ($version != null) {
        print $"  Version: ($version)"
    }
    print $border
    print ""
}

# Display script footer with timing
export def print-footer [start_time: datetime] {
    let end_time = (date now)
    let duration = ($end_time - $start_time)

    print ""
    print "────────────────────────────────────────────────────────"
    print $"  Completed in ($duration | into string)"
    print "────────────────────────────────────────────────────────"
}

# Create output directory if it doesn't exist
export def ensure-dir [path: string] {
    if not ($path | path exists) {
        mkdir $path
        log-debug $"Created directory: ($path)"
    }
}

# Safe file write with backup
export def safe-write [path: string, content: string] {
    ensure-dir ($path | path dirname)

    if ($path | path exists) {
        let backup = $"($path).bak"
        cp $path $backup
        log-debug $"Created backup: ($backup)"
    }

    $content | save -f $path
    log-debug $"Wrote file: ($path)"
}

# Handle errors gracefully
export def handle-error [error: string, exit_code: int = 1] {
    log-error $error
    print ""
    print "For help, run the script with --help"
    exit $exit_code
}
