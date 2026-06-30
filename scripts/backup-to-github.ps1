param(
    [Parameter()][string]$RepoUrl,
    [Parameter()][string]$CommitMessage = "Sauvegarde automatique $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Push-Location $repoRoot

try {
    git rev-parse --is-inside-work-tree | Out-Null

    if ($RepoUrl) {
        $remotes = @(git remote)
        if ($remotes -contains 'origin') {
            git remote set-url origin $RepoUrl
        }
        else {
            git remote add origin $RepoUrl
        }
    }

    git add --all

    $status = git status --short
    $hasUncommittedChanges = -not [string]::IsNullOrWhiteSpace($status)

    $upstreamRef = $null
    $upstreamOutput = git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>$null
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($upstreamOutput)) {
        $upstreamRef = $upstreamOutput.Trim()
    }

    $hasCommitsToPush = $false
    if ($upstreamRef) {
        $aheadCount = [int](git rev-list --count "$upstreamRef..HEAD")
        $hasCommitsToPush = $aheadCount -gt 0
    }
    else {
        $hasCommitsToPush = $true
    }

    if (-not $hasUncommittedChanges -and -not $hasCommitsToPush) {
        Write-Host 'Aucune modification à sauvegarder.'
        return
    }

    if (-not $RepoUrl) {
        $remoteUrl = git remote get-url origin 2>$null
        if (-not $remoteUrl) {
            Write-Host 'Aucun dépôt distant défini. Utilisez -RepoUrl https://github.com/UTILISATEUR/DEPOT.git'
            return
        }
    }

    if ($hasUncommittedChanges) {
        git commit -m $CommitMessage
    }

    git push -u origin HEAD
}
catch {
    Write-Error $_
}
finally {
    Pop-Location
}
