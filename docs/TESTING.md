# Testing Guide

This document describes the testing strategy and practices for Sparky.

## Testing Philosophy

Sparky uses a pragmatic testing approach:
- **Unit tests**: Test individual functions and modules
- **Integration tests**: Test interactions between components
- **End-to-end tests**: Test complete workflows
- **UI tests**: Test terminal UI components (when applicable)

## Current Test Stack

### Nushell Scripts
- **Syntax validation**: `nu-check` for all scripts
- **Integration testing**: Execute scripts with test data
- **Manual testing**: Run scripts locally before committing

### Future: Rust Components

When Rust components are added, the following will be implemented:

#### Unit Testing
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_config() {
        // Test implementation
    }
}
```

#### Terminal UI Testing (ratatui)

For terminal UI components, use `ratatui-testlib`:

```toml
[dev-dependencies]
ratatui-testlib = "0.1"
```

```rust
#[cfg(test)]
mod ui_tests {
    use ratatui::backend::TestBackend;
    use ratatui::Terminal;

    #[test]
    fn test_render_dashboard() {
        let backend = TestBackend::new(80, 24);
        let mut terminal = Terminal::new(backend).unwrap();

        terminal.draw(|f| {
            // Render UI component
        }).unwrap();

        // Assert on terminal state
        let buffer = terminal.backend().buffer();
        assert_eq!(buffer.get(0, 0).symbol(), "Dashboard");
    }
}
```

## Running Tests

### Nushell Script Tests

```bash
# Validate all script syntax
just test-scripts

# Run integration tests
just test-integration

# Run end-to-end tests
just test-e2e
```

### CI/CD Tests

All tests run automatically in CI:
- On every pull request
- On pushes to main
- Before releases

See `.github/workflows/ci.yml` for details.

## Test Data

Test data is stored in:
- `tests/fixtures/` - Sample input data
- `tests/expected/` - Expected output data
- `tests/mocks/` - Mock API responses

### Creating Test Data

```bash
# Collect sample data
nu scripts/collect.nu --mode daily --dry-run > tests/fixtures/sample-daily.json

# Generate mock responses
nu scripts/test/create-mocks.nu
```

## Writing Tests

### Nushell Script Tests

Create test scripts in `tests/`:

```nu
#!/usr/bin/env nu
# Test script for collect.nu

use scripts/lib/cli.nu *

def test-discover-repos [] {
    # Test implementation
    assert (discover-repositories | length > 0)
}

def test-collect-commits [] {
    # Test implementation
}

# Run tests
test-discover-repos
test-collect-commits
```

### Future: Rust Tests

When adding Rust code:

1. **Unit tests**: Co-locate with source code in `src/`
2. **Integration tests**: Place in `tests/` directory
3. **UI tests**: Use `ratatui-testlib` for terminal UI
4. **Benchmarks**: Place in `benches/` directory

#### Example Rust Test Structure

```
src/
├── lib.rs
├── collector/
│   ├── mod.rs
│   └── github.rs
└── analyzer/
    ├── mod.rs
    └── metrics.rs

tests/
├── integration/
│   ├── mod.rs
│   ├── test_collection.rs
│   └── test_analysis.rs
└── ui/
    ├── mod.rs
    └── test_dashboard.rs

benches/
└── collection_benchmark.rs
```

## Test Coverage

### Current Coverage

Nushell scripts are tested via:
- Syntax validation in CI
- Integration tests for key workflows
- Manual testing during development

### Future: Rust Coverage

When Rust code is added:

```bash
# Install tarpaulin
cargo install cargo-tarpaulin

# Generate coverage report
cargo tarpaulin --out Html --output-dir coverage/

# View report
open coverage/index.html
```

Target coverage: 80% for critical paths

## Testing Best Practices

### General Guidelines

1. **Test behavior, not implementation**
   - Focus on what the code does, not how it does it
   - Allows for refactoring without breaking tests

2. **Use descriptive test names**
   ```rust
   #[test]
   fn test_collector_handles_rate_limit_gracefully() { }
   ```

3. **Keep tests independent**
   - Each test should run in isolation
   - No shared state between tests

4. **Use fixtures for test data**
   - Don't hardcode data in tests
   - Store in `tests/fixtures/`

5. **Test edge cases**
   - Empty inputs
   - Invalid data
   - Rate limits
   - Network failures

### Nushell-Specific

1. **Use assertions**
   ```nu
   assert ($result | length) > 0
   assert ($value == "expected")
   ```

2. **Handle errors explicitly**
   ```nu
   try {
       # Code that might fail
   } catch {
       # Expected to fail
   }
   ```

3. **Test with various inputs**
   ```nu
   for mode in ["daily", "weekly", "monthly"] {
       test-collection $mode
   }
   ```

### Future: Rust-Specific

1. **Use `#[should_panic]` for error tests**
   ```rust
   #[test]
   #[should_panic(expected = "Invalid configuration")]
   fn test_invalid_config() {
       parse_config("invalid");
   }
   ```

2. **Use `Result<T, E>` in tests**
   ```rust
   #[test]
   fn test_collection() -> Result<(), Box<dyn Error>> {
       let result = collect_data()?;
       assert!(result.commits.len() > 0);
       Ok(())
   }
   ```

3. **Mock external dependencies**
   ```rust
   use mockall::predicate::*;
   use mockall::*;

   #[automock]
   trait GitHubClient {
       fn get_repos(&self) -> Vec<Repo>;
   }
   ```

## Continuous Testing

### Pre-commit Hooks

Install pre-commit hooks to run tests locally:

```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install

# Run manually
pre-commit run --all-files
```

### Watch Mode

For rapid development:

```bash
# Rust (when added)
cargo watch -x test

# Nushell (custom watch)
while true; do
    nu-check scripts/**/*.nu
    sleep 2
done
```

## Performance Testing

### Benchmarking (Future: Rust)

```bash
# Run benchmarks
cargo bench

# Compare results
cargo bench -- --save-baseline main
# Make changes
cargo bench -- --baseline main
```

### Load Testing

```bash
# Run load tests
just test-load

# Test with high volume
nu scripts/test/test-load.nu --repos 1000 --commits 10000
```

## Test Maintenance

1. **Update tests when code changes**
   - Keep tests in sync with implementation
   - Update expected outputs

2. **Remove obsolete tests**
   - Delete tests for removed features
   - Clean up unused fixtures

3. **Refactor tests**
   - DRY: Don't repeat yourself
   - Extract common setup to helper functions

4. **Document test failures**
   - Add comments explaining tricky test cases
   - Link to related issues

## Resources

- [Nushell Testing](https://www.nushell.sh/book/testing.html)
- [Rust Testing Guide](https://doc.rust-lang.org/book/ch11-00-testing.html)
- [ratatui Testing](https://github.com/ratatui-org/ratatui/tree/main/ratatui-testlib)
- [cargo-tarpaulin](https://github.com/xd009642/tarpaulin)

## Questions?

For testing questions, open an issue with the `testing` label.
