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
