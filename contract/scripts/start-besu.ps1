# Start a local Hyperledger Besu dev node on Windows (Docker or Podman).
param(
    [string]$ContainerName = "besu-local",
    [int]$RpcPort = 8545
)

$ErrorActionPreference = "Stop"

function Get-ContainerEngine {
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        return @{ Name = "docker"; Run = "docker" }
    }
    if (Get-Command podman -ErrorAction SilentlyContinue) {
        return @{ Name = "podman"; Run = "podman" }
    }
    throw @"
No container engine found.

Install one of:
  - Docker Desktop: https://docs.docker.com/desktop/setup/install/windows-install/
  - Podman Desktop: https://podman-desktop.io/downloads/windows

Then restart PowerShell and run this script again.
"@
}

$engine = Get-ContainerEngine
Write-Host "Using $($engine.Name)..."

$running = & $engine.Run ps --format "{{.Names}}" 2>$null
if ($running -contains $ContainerName) {
    Write-Host "Stopping existing container: $ContainerName"
    & $engine.Run stop $ContainerName | Out-Null
}

$existing = & $engine.Run ps -a --format "{{.Names}}" 2>$null
if ($existing -contains $ContainerName) {
    & $engine.Run rm $ContainerName | Out-Null
}

Write-Host "Starting Besu dev node with mining enabled on port $RpcPort..."
& $engine.Run run -d `
    --name $ContainerName `
    -p "${RpcPort}:8545" `
    hyperledger/besu:latest `
    --network=dev `
    --miner-enabled `
    --miner-coinbase=0xfe3b557e8fb62b89f4916b721be55ceb828dbd73 `
    --rpc-http-enabled `
    --rpc-http-host=0.0.0.0 `
    --rpc-http-port=8545 `
    --rpc-http-cors-origins='*' `
    --host-allowlist='*' `
    --rpc-http-api=ETH,NET,WEB3,MINER,TXPOOL

Write-Host "Waiting for RPC..."
$ready = $false
for ($i = 1; $i -le 30; $i++) {
    try {
        $body = '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
        $null = Invoke-RestMethod -Uri "http://127.0.0.1:$RpcPort" -Method Post `
            -ContentType "application/json" -Body $body -TimeoutSec 2
        $ready = $true
        break
    } catch {
        Start-Sleep -Seconds 1
    }
}

if (-not $ready) {
    throw "Besu RPC did not become ready on port $RpcPort within 30 seconds."
}

Write-Host "Besu RPC: http://127.0.0.1:$RpcPort"
Write-Host "View logs: $($engine.Run) logs -f $ContainerName"
