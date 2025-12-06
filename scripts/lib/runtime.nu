#!/usr/bin/env nu
# Runtime utilities for Sparky
# Provides runtime initialization, error handling, and cleanup

use cli.nu *
use config.nu *

# Initialize runtime environment
export def init-runtime [
    script_name: string,
    --config-file (-c): string,
    --verbose (-v): bool = false,
    --quiet (-q): bool = false
] {
    # Initialize CLI
    let cli_ctx = (init $script_name --verbose=$verbose --quiet=$quiet)

    # Load configuration
    let config = (load-config $config_file)

    # Validate configuration
    let validation = (validate-config $config)
    if not $validation.valid {
        log-error "Configuration validation failed:"
        for error in $validation.errors {
            print $"  - ($error)"
        }
        exit 1
    }

    # Set up runtime context
    {
        cli: $cli_ctx,
        config: $config,
        start_time: (date now),
        script_name: $script_name
    }
}

# Execute with error handling
export def safe-execute [
    ctx: record,
    task_name: string,
    code: closure
] {
    log-info $"Starting: ($task_name)"

    try {
        let result = (do $code)
        log-success $"Completed: ($task_name)"
        $result
    } catch {|err|
        log-error $"Failed: ($task_name)" {error: $err}
        null
    }
}

# Graceful shutdown
export def shutdown [ctx: record, --success: bool = true] {
    let duration = ((date now) - $ctx.start_time)

    if $success {
        log-success $"($ctx.script_name) completed successfully"
    } else {
        log-error $"($ctx.script_name) failed"
    }

    print ""
    print $"Duration: ($duration | into string)"
    print ""
}

# Create all necessary directories
export def ensure-runtime-dirs [config: record] {
    for path_name in ["data_raw", "data_processed", "output"] {
        let path = ($config.paths | get $path_name)
        ensure-dir $path
    }
}

# Check runtime dependencies
export def check-runtime-deps [deps: list<string>] {
    check-deps $deps
}

# Get runtime statistics
export def get-runtime-stats [ctx: record] {
    let duration = ((date now) - $ctx.start_time)

    {
        script: $ctx.script_name,
        start_time: $ctx.start_time,
        duration: $duration,
        config: $ctx.config.project_name
    }
}

# Register signal handlers (cleanup on exit)
export def register-cleanup [cleanup_code: closure] {
    # Note: Nushell doesn't have direct signal handling like Bash
    # This is a placeholder for future enhancement
    # In practice, cleanup code should be in try-catch or at script end
}
