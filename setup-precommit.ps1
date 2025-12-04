# Pre-commit Setup Script
# Run this to install pre-commit hooks

Write-Host "Setting up pre-commit hooks..." -ForegroundColor Cyan

# Make pre-commit hook executable
$hookPath = Join-Path $PSScriptRoot ".git\hooks\pre-commit"
if (Test-Path $hookPath) {
    # On Windows, we don't need chmod, but we can ensure the file is ready
    Write-Host "✅ Pre-commit hook is ready at: $hookPath"
} else {
    Write-Host "❌ Pre-commit hook not found at: $hookPath" -ForegroundColor Red
    exit 1
}

# Install pre-commit tools if available
if (Get-Command pre-commit -ErrorAction SilentlyContinue) {
    Write-Host "Installing pre-commit configuration..."
    pre-commit install
    Write-Host "✅ Pre-commit tools installed"
} else {
    Write-Host "⚠️ Pre-commit tool not found. Install with: pip install pre-commit" -ForegroundColor Yellow
}

Write-Host "🎉 Pre-commit setup complete!" -ForegroundColor Green