param(
    [string]$RepoRoot = $PSScriptRoot,
    [switch]$InstallBaseTools,
    [switch]$RestoreVendoredSkills
)

$ErrorActionPreference = "Stop"

function Test-Tool {
    param([string]$Name)
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-WingetPackage {
    param(
        [string]$PackageId,
        [string]$Label
    )

    if (-not (Test-Tool -Name "winget")) {
        Write-Warning "winget not found; skip installing $Label"
        return
    }

    Write-Host "Installing $Label via winget..."
    winget install --id $PackageId --silent --accept-source-agreements --accept-package-agreements
}

if ($InstallBaseTools) {
    if (-not (Test-Tool -Name "git")) { Install-WingetPackage -PackageId "Git.Git" -Label "Git" }
    if (-not (Test-Tool -Name "gh")) { Install-WingetPackage -PackageId "GitHub.cli" -Label "GitHub CLI" }
    if (-not (Test-Tool -Name "node")) { Install-WingetPackage -PackageId "OpenJS.NodeJS.LTS" -Label "Node.js LTS" }
    if (-not (Test-Tool -Name "python")) { Install-WingetPackage -PackageId "Python.Python.3.12" -Label "Python 3.12" }
}

$codexSkillsDir = Join-Path $env:USERPROFILE ".codex\skills"
$codexConfigDir = Join-Path $env:USERPROFILE ".codex"
$claudeSkillsDir = Join-Path $env:USERPROFILE ".claude\skills"
$claudeConfigDir = Join-Path $env:USERPROFILE ".claude"
$agentsSkillsDir = Join-Path $env:USERPROFILE ".agents\skills"
$agentsBinDir = Join-Path $env:USERPROFILE ".agents\bin"

foreach ($dir in @($claudeConfigDir, $claudeSkillsDir, $codexConfigDir, $codexSkillsDir, $agentsSkillsDir, $agentsBinDir)) {
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

if ($RestoreVendoredSkills) {
    $restoreScript = Join-Path $RepoRoot "scripts\restore-vendored-skills.ps1"
    & $restoreScript -RepoRoot $RepoRoot
}

Write-Host ""
Write-Host "Manual steps still required:"
Write-Host "- install/sign in to Claude Code"
Write-Host "- install/sign in to Codex"
Write-Host "- run gh auth login"
Write-Host "- reconnect Google Drive / other connectors if needed"
Write-Host ""

$checkScript = Join-Path $RepoRoot "check-env.ps1"
& $checkScript -RepoRoot $RepoRoot
