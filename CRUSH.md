# CRUSH.md - Development Setup Commands & Standards

## Quick Start Commands

```powershell
# Run the full setup
.\init.ps1

# Install individual components
.\init.ps1 -InstallScoop
.\init.ps1 -InstallApps
.\init.ps1 -SetupConfig

# Test your setup
fastfetch
sysinfo
```

## Development Commands

### Package Management
```powershell
# Update all scoop packages
scoop update *

# Install new package
scoop install <package-name>

# Search for packages
scoop search <package-name>

# Winget operations
winget upgrade --all
winget search <app-name>
```

### Git Operations
```powershell
# Enhanced git aliases (from profile)
gst          # git status -sb
gco <branch> # git checkout
gcm "msg"    # git commit -m
gp           # git push
gl           # git pull --rebase
gd           # git diff
gds          # git diff --staged
```

### Navigation & File Management
```powershell
# Enhanced ls with eza
ll           # eza -alF --icons
la           # eza -A --icons
lt           # eza -T (tree view)
lg           # eza --git

# Directory navigation
dev <dir>    # Navigate to dev directories
proj <name>  # Search and jump to projects
mkcd <dir>   # Create and enter directory
z <pattern>  # Smart cd with zoxide

# File operations
y            # Launch yazi file manager
find <name>  # Find files with fd
grep <pattern> # Search with ripgrep
```

### Development Tools
```powershell
# Node.js management
fnm list
fnm install <version>
fnm use <version>

# Python with uv
uv venv
uv pip install <package>
uv run <script>

# Container operations
d ps          # docker ps
dc up         # docker-compose up
dc down       # docker-compose down
```

## Build Commands

### PowerShell Scripts
```powershell
# Build and test PowerShell scripts
pwsh -NoProfile -File .\script.ps1

# Lint PowerShell
Invoke-ScriptAnalyzer -Path .\script.ps1

# Test with Pester
Invoke-Pester -Path .\tests\
```

### Node.js Projects
```powershell
# Install dependencies
pnpm install

# Build project
pnpm build

# Run tests
pnpm test

# Lint code
pnpm lint
pnpm lint:fix

# Type checking
pnpm type-check
```

### Python Projects
```powershell
# Create virtual environment
uv venv

# Install dependencies
uv pip install -r requirements.txt

# Run tests
uv run pytest

# Lint code
uv run ruff check .
uv run ruff format .

# Type checking
uv run mypy .
```

### Rust Projects
```powershell
# Build project
cargo build

# Run tests
cargo test

# Check code
cargo check
cargo clippy

# Format code
cargo fmt
```

### Go Projects
```powershell
# Build project
go build ./...

# Run tests
go test ./...

# Format code
go fmt ./...

# Lint code
golangci-lint run
```

## Code Style Standards

### General Principles
- Follow existing conventions in the codebase
- Use descriptive names for variables, functions, and files
- Handle errors gracefully with proper logging
- Write self-documenting code with clear intent

### PowerShell
- Use approved verbs for function names (Get-, Set-, New-, etc.)
- Follow PowerShell naming conventions (PascalCase for functions, camelCase for variables)
- Use `Write-Host` sparingly; prefer `Write-Verbose`, `Write-Warning`, or `Write-Error`
- Implement proper error handling with `try/catch` blocks
- Use `CmdletBinding` and parameter validation for advanced functions

### Shell Scripts (Bash)
- Use `#!/usr/bin/env bash` shebang
- Quote variables to prevent word splitting: `"$VAR"`
- Use `[[ ]]` for conditional tests instead of `[ ]`
- Follow shellcheck recommendations
- Use `set -euo pipefail` for strict error handling

### Configuration Files
- Use consistent indentation (2 spaces for YAML/TOML, 4 for JSON)
- Add comments explaining complex configurations
- Separate logical sections with comments
- Use environment variables for sensitive data

### Git Commits
- Use conventional commit format: `type(scope): description`
- Types: feat, fix, docs, style, refactor, test, chore
- Keep first line under 50 characters
- Wrap body at 72 characters

## Testing Standards

### Unit Tests
- Test public interfaces, not implementation details
- Use descriptive test names that explain the scenario
- Follow AAA pattern: Arrange, Act, Assert
- Mock external dependencies

### Integration Tests
- Test real interactions between components
- Use test databases/services when possible
- Clean up test data after each test
- Test both happy path and error scenarios

## Security Guidelines

- Never commit secrets, API keys, or passwords
- Use environment variables for sensitive configuration
- Validate all user inputs
- Follow principle of least privilege
- Keep dependencies updated regularly

## Performance Guidelines

- Profile before optimizing
- Use appropriate data structures
- Minimize I/O operations
- Cache expensive operations when appropriate
- Consider memory usage for large datasets
