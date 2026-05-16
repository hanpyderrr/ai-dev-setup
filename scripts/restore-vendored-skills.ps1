param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

$manifestPath = Join-Path $RepoRoot "config\skills\skills-manifest.json"
if (-not (Test-Path -LiteralPath $manifestPath)) {
    throw "skills-manifest.json not found"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json

# Restore vendored skills (copied into this repo)
foreach ($skill in $manifest.vendor_from_local) {
    $source = Join-Path $RepoRoot $skill.target_repo_path
    $target = [Environment]::ExpandEnvironmentVariables($skill.restore_path)

    if (-not (Test-Path -LiteralPath $source)) {
        Write-Warning "Skip missing vendored skill: $source"
        continue
    }

    $targetParent = Split-Path -Parent $target
    if (-not (Test-Path -LiteralPath $targetParent)) {
        New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    }

    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }

    Copy-Item -LiteralPath $source -Destination $target -Recurse
    Write-Host "Restored $($skill.name) -> $target"
}

# Restore git_clone skills (cloned from external repos)
foreach ($skill in $manifest.git_clone) {
    $target = [Environment]::ExpandEnvironmentVariables($skill.restore_path)

    if (Test-Path -LiteralPath $target) {
        Write-Host "Already exists, skipping git_clone: $($skill.name)"
        continue
    }

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Warning "git not found; cannot clone $($skill.name)"
        continue
    }

    $targetParent = Split-Path -Parent $target
    if (-not (Test-Path -LiteralPath $targetParent)) {
        New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    }

    Write-Host "Cloning $($skill.name) from $($skill.remote) ..."
    git clone $skill.remote $target
    Write-Host "Cloned $($skill.name) -> $target"
}

# Restore global Claude config
$claudeConfigSrc = Join-Path $RepoRoot "config\claude\CLAUDE.md"
if (Test-Path -LiteralPath $claudeConfigSrc) {
    $claudeConfigDst = Join-Path $env:USERPROFILE ".claude\CLAUDE.md"
    $dstParent = Split-Path -Parent $claudeConfigDst
    if (-not (Test-Path -LiteralPath $dstParent)) {
        New-Item -ItemType Directory -Path $dstParent -Force | Out-Null
    }
    Copy-Item -LiteralPath $claudeConfigSrc -Destination $claudeConfigDst -Force
    Write-Host "Restored CLAUDE.md -> $claudeConfigDst"
}

# Restore global Codex config
$codexConfigSrc = Join-Path $RepoRoot "config\codex\AGENTS.md"
if (Test-Path -LiteralPath $codexConfigSrc) {
    $codexConfigDst = Join-Path $env:USERPROFILE ".codex\AGENTS.md"
    $dstParent = Split-Path -Parent $codexConfigDst
    if (-not (Test-Path -LiteralPath $dstParent)) {
        New-Item -ItemType Directory -Path $dstParent -Force | Out-Null
    }
    Copy-Item -LiteralPath $codexConfigSrc -Destination $codexConfigDst -Force
    Write-Host "Restored AGENTS.md -> $codexConfigDst"
}
