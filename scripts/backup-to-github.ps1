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
    if ([string]::IsNullOrWhiteSpace($status)) {
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

    git commit -m $CommitMessage
    git push -u origin HEAD
}
catch {
    Write-Error $_
}
finally {
    Pop-Location
}
