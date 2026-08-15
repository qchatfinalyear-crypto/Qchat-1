# Windows startup script for QChat (Besu + Vite frontend).
$ErrorActionPreference = "Stop"
$ProjectRoot = $PSScriptRoot

Write-Host "=================================================="
Write-Host "  POWERING UP QCHAT WEB2 + WEB3 ARCHITECTURE"
Write-Host "=================================================="

. (Join-Path $ProjectRoot "scripts\ensure-node.ps1")

if (-not (Test-Path (Join-Path $ProjectRoot ".env.local"))) {
    Write-Warning ".env.local not found. Copy .env.example to .env.local and set VITE_CONVEX_URL."
    Write-Warning "Run 'npx convex dev' in another terminal to create/link a Convex deployment."
}

Write-Host "Starting Hyperledger Besu..."
& (Join-Path $ProjectRoot "contract\scripts\start-besu.ps1")

Write-Host "Starting Vite frontend dev server..."
Set-Location $ProjectRoot
pnpm dev
