# Configuration

This directory contains configuration files for Sparky.

## Files

- `default.toml` - Default configuration template
- `local.toml` - Local development config (git-ignored)
- `production.toml` - Production config (git-ignored)

## Usage

### Create Local Config

```bash
# Copy default config
cp config/default.toml config/local.toml

# Edit for your environment
$EDITOR config/local.toml
```

### Using Config with Scripts

```bash
# Use default config
nu scripts/collect-v2.nu

# Use custom config
nu scripts/collect-v2.nu --config config/local.toml
```

## Configuration Options

### General Settings

```toml
[general]
project_name = "sparky"
version = "0.1.0"
```

### Collection Settings

```toml
[collection]
org_name = "raibid-labs"        # GitHub organization
max_repos = 100                 # Maximum repos to scan
max_prs_per_repo = 50          # Max PRs per repo
max_issues_per_repo = 50       # Max issues per repo

[collection.lookback_days]
daily = 1                      # Days to look back for daily
weekly = 7                     # Days to look back for weekly
monthly = 30                   # Days to look back for monthly
```

### Path Configuration

```toml
[paths]
data_raw = "data/raw"          # Raw data storage
data_processed = "data/processed"  # Processed data
output = "output"              # Generated content
```

### Logging

```toml
[logging]
level = "info"                 # debug, info, warn, error
timestamp_format = "%Y-%m-%d %H:%M:%S"
```

### GitHub Settings

```toml
[github]
cli_tool = "gh"                # GitHub CLI command
rate_limit_check = true        # Check rate limits
```

### LLM Settings

```toml
[llm]
provider = "ollama"            # LLM provider
model = "qwen2.5-coder:1.5b"   # Model to use
host = "http://localhost:11434" # Ollama host
```

## Environment-Specific Configs

### Development (local.toml)

```toml
[logging]
level = "debug"

[collection]
max_repos = 10  # Smaller for faster testing
```

### Production (production.toml)

```toml
[logging]
level = "warn"

[collection]
max_repos = 100

[paths]
data_raw = "/data/sparky/raw"
data_processed = "/data/sparky/processed"
output = "/data/sparky/output"
```

## Security Notes

- **Never commit** `local.toml` or `production.toml`
- Keep sensitive settings (tokens, passwords) in environment variables
- Use `.gitignore` to exclude local configs

## Validation

Config files are validated on load:

```bash
# Generate example config
nu -c "use scripts/lib/config.nu; create-example-config 'config/example.toml'"

# Test config loading
nu -c "use scripts/lib/config.nu; load-config 'config/local.toml' | to json"
```
