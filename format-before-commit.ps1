# Pre-commit Prettier Formatting Script
# Auto-formats all files before committing to prevent CI failures

Write-Host "=== Pre-Commit Prettier Formatter ===" -ForegroundColor Cyan
Write-Host ""

# Navigate to project directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Check if there are staged files
$stagedFiles = git diff --cached --name-only --diff-filter=ACMR
if (-not $stagedFiles) {
    Write-Host "No staged files found. Stage your changes first with:" -ForegroundColor Yellow
    Write-Host "  git add <files>" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Or format all files with:" -ForegroundColor Yellow
    Write-Host "  npx prettier . --write" -ForegroundColor Gray
    exit 0
}

Write-Host "Found $(@($stagedFiles).Count) staged file(s)" -ForegroundColor Green
Write-Host "Running Prettier..." -ForegroundColor Gray
Write-Host ""

# Format staged files
$stagedFiles | ForEach-Object {
    npx prettier $_ --write --log-level warn
}

Write-Host ""
Write-Host "Re-staging formatted files..." -ForegroundColor Gray
git add $stagedFiles

Write-Host ""
Write-Host "✓ All staged files formatted and re-staged!" -ForegroundColor Green
Write-Host ""
Write-Host "You can now commit:" -ForegroundColor Cyan
Write-Host "  git commit -m ""your message""" -ForegroundColor Gray
Write-Host ""
