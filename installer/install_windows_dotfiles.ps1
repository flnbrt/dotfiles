Write-Host "#########################################"
Write-Host "# Windows PowerShell Dotfiles Installer #"
Write-Host "#########################################"
Write-Host ""
Write-Host "-----------------------------------------"
Write-Host "Installing Windows PowerShell Dotfiles..."
Invoke-RestMethod https://raw.githubusercontent.com/flnbrt/dotfiles/main/windows/Microsoft.PowerShell_profile.ps1 | Invoke-Expression


function Update-Profile {
    try {
        $url = "https://raw.githubusercontent.com/flnbrt/dotfiles/main/windows/Microsoft.PowerShell_profile.ps1"
        Write-Host "Installing PowerShell Profile..."
        Invoke-WebRequest -Uri $url -OutFile $PROFILE -UseBasicParsing
        Write-Host "Profile Installation Successfully!"
        Write-Host "PowerShell Profile is up to date."
    } catch {
        Write-Host "Failed to install PowerShell Profile: $_"
    }
}