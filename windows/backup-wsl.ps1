param(
    [string]$Distro = "Ubuntu",
    [string]$BackupDirectory = "$HOME\WSL-Backups"
)

$ErrorActionPreference = "Stop"

$Timestamp = Get-Date -Format "yyyy-MM-dd-HHmm"
$BackupFile = Join-Path $BackupDirectory "$Distro-$Timestamp.tar"

New-Item -ItemType Directory -Force -Path $BackupDirectory | Out-Null

Write-Host "Stopping WSL distributions..."
wsl --shutdown

Write-Host "Exporting $Distro..."
Write-Host "Destination: $BackupFile"

wsl --export $Distro $BackupFile

if ($LASTEXITCODE -ne 0) {
    throw "WSL export failed with exit code $LASTEXITCODE."
}

$Hash = Get-FileHash $BackupFile -Algorithm SHA256
$File = Get-Item $BackupFile

Write-Host ""
Write-Host "Backup completed."
Write-Host "File:   $($File.FullName)"
Write-Host "Size:   $([math]::Round($File.Length / 1GB, 2)) GB"
Write-Host "SHA256: $($Hash.Hash)"
