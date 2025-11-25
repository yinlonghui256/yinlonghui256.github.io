# Jekyll Development Server Startup Script for Windows
# Fixes UTF-8 encoding issues with Chinese path characters

# Set console code page to UTF-8
chcp 65001 > $null

# Configure Ruby encoding
$env:RUBYOPT = '-EUTF-8:UTF-8'
$env:LANG = 'en_US.UTF-8'

# Navigate to project directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "Starting Jekyll development server..." -ForegroundColor Green
Write-Host "Console: UTF-8 (Code Page 65001)" -ForegroundColor Gray
Write-Host "Ruby: External=UTF-8, Internal=UTF-8" -ForegroundColor Gray
Write-Host ""
Write-Host "Tip: Before committing, run .\format-before-commit.ps1 to auto-format files" -ForegroundColor Yellow
Write-Host ""

# Start Jekyll with live reload
bundle exec jekyll serve --host 127.0.0.1 --port 4000 --livereload --incremental

# Keep window open if error occurs
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Jekyll exited with error code $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Press any key to close..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
