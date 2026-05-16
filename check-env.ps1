param(
    [string]$RepoRoot = $PSScriptRoot
)

$checks = @(
    @{ Name = "git"; Present = ($null -ne (Get-Command git -ErrorAction SilentlyContinue)) },
    @{ Name = "gh"; Present = ($null -ne (Get-Command gh -ErrorAction SilentlyContinue)) },
    @{ Name = "node"; Present = ($null -ne (Get-Command node -ErrorAction SilentlyContinue)) },
    @{ Name = "python"; Present = ($null -ne (Get-Command python -ErrorAction SilentlyContinue)) },
    @{ Name = "claude"; Present = ($null -ne (Get-Command claude -ErrorAction SilentlyContinue)) },
    @{ Name = "codex"; Present = ($null -ne (Get-Command codex -ErrorAction SilentlyContinue)) }
)

Write-Host "Tool check:"
foreach ($check in $checks) {
    $status = if ($check.Present) { "OK" } else { "MISSING" }
    Write-Host ("- {0}: {1}" -f $check.Name, $status)
}

$manifest = Join-Path $RepoRoot "config\skills\skills-manifest.json"
Write-Host ""
Write-Host ("Skill manifest: {0}" -f $(if (Test-Path -LiteralPath $manifest) { "OK" } else { "MISSING" }))

$vendoredDir = Join-Path $RepoRoot "skills\vendored"
Write-Host ("Vendored skills dir: {0}" -f $(if (Test-Path -LiteralPath $vendoredDir) { "OK" } else { "MISSING" }))
