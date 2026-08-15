# One-time Windows setup for QChat after migrating from Linux.
$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path $PSScriptRoot -Parent

Write-Host "=== QChat Windows Setup ==="

. (Join-Path $ProjectRoot "scripts\ensure-node.ps1")

Set-Location $ProjectRoot
Write-Host "Installing frontend dependencies..."
pnpm install

Write-Host "Installing contract dependencies..."
Set-Location (Join-Path $ProjectRoot "contract")
npm install

Set-Location $ProjectRoot

$envExample = Join-Path $ProjectRoot ".env.example"
$envLocal = Join-Path $ProjectRoot ".env.local"
if (-not (Test-Path $envLocal) -and (Test-Path $envExample)) {
    Copy-Item $envExample $envLocal
    Write-Host "Created .env.local from .env.example — edit VITE_CONVEX_URL before running the app."
}

Write-Host ""
Write-Host "Setup complete."
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Install Docker Desktop (for Besu blockchain):"
Write-Host "     https://docs.docker.com/desktop/setup/install/windows-install/"
Write-Host "  2. In one terminal:  npx convex dev"
Write-Host "  3. In another:       .\start-project.ps1"
Write-Host ""
Write-Host "Optional — install Node.js system-wide (recommended):"
Write-Host "  winget install OpenJS.NodeJS.LTS"
Write-Host "  (requires Administrator approval)"
