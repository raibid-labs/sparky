#!/usr/bin/env nu
# Configuration management for Sparky
# Provides centralized configuration loading and validation

# Default configuration
export def default-config [] {
    {
        # General settings
        project_name: "sparky",
        version: "0.1.0",

        # Data collection
        collection: {
            org_name: "raibid-labs",
            max_repos: 100,
            max_prs_per_repo: 50,
            max_issues_per_repo: 50,
            lookback_days: {
                daily: 1,
                weekly: 7,
                monthly: 30
            }
        },

        # Paths
        paths: {
            data_raw: "data/raw",
            data_processed: "data/processed",
            output: "output"
        },

        # Logging
        logging: {
            level: "info",  # debug, info, warn, error
            timestamp_format: "%Y-%m-%d %H:%M:%S"
        },

        # GitHub API
        github: {
            cli_tool: "gh",
            rate_limit_check: true
        },

        # LLM settings
        llm: {
            provider: "ollama",
            model: "qwen2.5-coder:1.5b",
            host: "http://localhost:11434"
        }
    }
}

# Load configuration from file or return default
export def load-config [config_file?: string] {
    if ($config_file == null) or (not ($config_file | path exists)) {
        return (default-config)
    }

    try {
        let file_config = (open $config_file | from toml)
        # Merge with defaults (file config overrides defaults)
        default-config | merge $file_config
    } catch {
        print $"⚠️  Failed to load config from ($config_file), using defaults"
        default-config
    }
}

# Get configuration value by path
export def get-config-value [config: record, path: list<string>] {
    mut value = $config
    for key in $path {
        $value = ($value | get $key)
    }
    $value
}

# Validate configuration
export def validate-config [config: record] {
    mut errors = []

    # Check required fields
    if ($config.project_name? | is-empty) {
        $errors = ($errors | append "Missing project_name")
    }

    if ($config.collection?.org_name? | is-empty) {
        $errors = ($errors | append "Missing collection.org_name")
    }

    # Validate paths exist or can be created
    for path_name in ["data_raw", "data_processed", "output"] {
        let path_value = ($config.paths | get $path_name)
        if not ($path_value | path exists) {
            try {
                mkdir $path_value
            } catch {
                $errors = ($errors | append $"Cannot create path: ($path_value)")
            }
        }
    }

    if ($errors | length) > 0 {
        return {valid: false, errors: $errors}
    }

    {valid: true, errors: []}
}

# Create example config file
export def create-example-config [output_path: string] {
    let config = (default-config)
    $config | to toml | save -f $output_path
    print $"✅ Example config created: ($output_path)"
}
