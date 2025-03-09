Write-Host "#########################################"
Write-Host "# Windows PowerShell Dotfiles Installer #"
Write-Host "#########################################"
Write-Host ""
Write-Host "-----------------------------------------"
Write-Host "Installing Windows PowerShell Dotfiles..."

try {
    $url = "https://raw.githubusercontent.com/flnbrt/dotfiles/main/windows/Microsoft.PowerShell_profile.ps1"
    Write-Host "Installing PowerShell Profile..."
    Invoke-WebRequest -Uri $url -OutFile $PROFILE -UseBasicParsing
    Write-Host "Profile Installation Successfully!"
    Write-Host "PowerShell Profile is up to date."
} catch {
    Write-Host "Failed to install PowerShell Profile: $_"
}