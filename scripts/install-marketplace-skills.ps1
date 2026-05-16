param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$manifestPath = Join-Path $RepoRoot "config\skills\skills-manifest.json"
if (-not (Test-Path -LiteralPath $manifestPath)) {
    throw "skills-manifest.json not found"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$skillsDir = Join-Path $env:USERPROFILE ".claude\skills"

$missing  = @()
$present  = @()

foreach ($name in $manifest.reinstall_by_name) {
    $path = Join-Path $skillsDir $name
    if (Test-Path -LiteralPath $path) {
        $present += $name
    } else {
        $missing += $name
    }
}

Write-Host "Skills status:"
Write-Host "  Already installed : $($present.Count)"
Write-Host "  Missing           : $($missing.Count)"

if ($missing.Count -eq 0) {
    Write-Host "All marketplace skills are installed."
    exit 0
}

Write-Host ""
Write-Host "Missing skills:"
$missing | ForEach-Object { Write-Host "  - $_" }
Write-Host ""

if ($DryRun) {
    Write-Host "[DryRun] Would attempt: claude plugin install <name> for each missing skill."
    exit 0
}

$failed = @()
foreach ($name in $missing) {
    Write-Host "Installing $name ..."
    try {
        $result = & claude plugin install $name 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  OK"
        } else {
            Write-Warning "  Failed (exit $LASTEXITCODE): $result"
            $failed += $name
        }
    } catch {
        Write-Warning "  Error: $_"
        $failed += $name
    }
}

if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host "Could not auto-install the following ($($failed.Count)); install manually in Claude Code with /plugin install <name>:"
    $failed | ForEach-Object { Write-Host "  /plugin install $_" }
    exit 1
}

Write-Host ""
Write-Host "All marketplace skills installed."
