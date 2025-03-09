Write-Host ""
Write-Host "#########################################"
Write-Host "# Windows PowerShell Dotfiles Installer #"
Write-Host "#########################################"
Write-Host ""
Write-Host "----------------------------------------"
Write-Host "Installing Windows PowerShell Profile..."

$profileDir = Split-Path -Parent $PROFILE
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

try {
    $url = "https://raw.githubusercontent.com/flnbrt/dotfiles/main/windows/Microsoft.PowerShell_profile.ps1"
    Invoke-WebRequest -Uri $url -OutFile $PROFILE -UseBasicParsing
    Write-Host "Profile Installation Successfully!"
} catch {
    Write-Host "Failed to install PowerShell Profile: $_"
}