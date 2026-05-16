param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

$source = Join-Path $env:USERPROFILE ".claude\CLAUDE.md"
$target = Join-Path $RepoRoot "config\claude\CLAUDE.md"

if (-not (Test-Path -LiteralPath $source)) {
    Write-Warning "~/.claude/CLAUDE.md not found; skipping"
    exit 0
}

$targetParent = Split-Path -Parent $target
if (-not (Test-Path -LiteralPath $targetParent)) {
    New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
}

Copy-Item -LiteralPath $source -Destination $target -Force
Write-Host "Exported CLAUDE.md -> $target"
