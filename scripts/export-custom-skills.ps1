param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

$manifestPath = Join-Path $RepoRoot "config\skills\skills-manifest.json"
if (-not (Test-Path -LiteralPath $manifestPath)) {
    throw "skills-manifest.json not found"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json

foreach ($skill in $manifest.vendor_from_local) {
    $source = $skill.source_path
    $target = Join-Path $RepoRoot $skill.target_repo_path

    if (-not (Test-Path -LiteralPath $source)) {
        Write-Warning "Skip missing source: $source"
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
    Write-Host "Exported $($skill.name) -> $target"
}

# Export global config files
$exportClaudeConfig = Join-Path $PSScriptRoot "export-claude-config.ps1"
if (Test-Path -LiteralPath $exportClaudeConfig) {
    & $exportClaudeConfig -RepoRoot $RepoRoot
}

$exportCodexConfig = Join-Path $PSScriptRoot "export-codex-config.ps1"
if (Test-Path -LiteralPath $exportCodexConfig) {
    & $exportCodexConfig -RepoRoot $RepoRoot
}

Write-Host ""
Write-Host "Done. Remember to commit and push:"
Write-Host "  git add -A && git commit -m 'chore: sync skills and config' && git push"
