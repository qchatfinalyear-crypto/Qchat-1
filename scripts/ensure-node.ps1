# Ensures Node.js and pnpm are available on Windows.
# Uses system Node if installed; otherwise falls back to a portable install.

$ErrorActionPreference = "Stop"

function Test-Command($Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-PortableNode {
    $toolsRoot = Join-Path $env:LOCALAPPDATA "qchat-tools"
    $nodeDir = Join-Path $toolsRoot "node"
    $nodeExe = Join-Path $nodeDir "node.exe"

    if (Test-Path $nodeExe) {
        return $nodeDir
    }

    Write-Host "Node.js not found. Downloading portable Node.js 22..."
    New-Item -ItemType Directory -Force -Path $toolsRoot | Out-Null

    $version = "22.20.0"
    $zipName = "node-v$version-win-x64.zip"
    $zipPath = Join-Path $env:TEMP $zipName
    $url = "https://nodejs.org/dist/v$version/$zipName"

    curl.exe -L -o $zipPath $url
    Expand-Archive -Path $zipPath -DestinationPath $toolsRoot -Force

    $extracted = Join-Path $toolsRoot "node-v$version-win-x64"
    if (Test-Path $nodeDir) {
        Remove-Item -Recurse -Force $nodeDir
    }
    Rename-Item $extracted $nodeDir

    return $nodeDir
}

if (-not (Test-Command "node")) {
    $nodeDir = Install-PortableNode
    $env:PATH = "$nodeDir;$env:PATH"
    Write-Host "Using portable Node.js from $nodeDir"
}

if (-not (Test-Command "pnpm")) {
    corepack enable
    corepack prepare pnpm@10.0.0 --activate
}

Write-Host "Node: $(node --version)"
Write-Host "pnpm: $(pnpm --version)"
